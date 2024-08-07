if SERVER then
	AddCSLuaFile()	
end

SWEP.HoldType               = "normal"

if CLIENT then
   SWEP.PrintName           = "Patient Cough"
   SWEP.Slot                = 8
   SWEP.ViewModelFlip       = false
   SWEP.ViewModelFOV        = 90
   SWEP.DrawCrosshair       = false
	
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Cough on other players to get them infected. Infected move slower, reduced vision, and have an audible cough"
   };

   SWEP.Icon                = "vgui/ttt/icon_pat"
   SWEP.IconLetter          = "j"

   function SWEP:Initialize()
		self:AddTTT2HUDHelp("Cough on other players to infect them. Eventually they will develop an immunity.")
	end
end

SWEP.Base                   = "weapon_tttbase"

SWEP.UseHands               = true
SWEP.ViewModel              = "models/weapons/c_arms.mdl"
SWEP.WorldModel             = ""

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Delay          = 2
SWEP.Primary.Ammo           = "none"

SWEP.Kind                   = WEAPON_CLASS
SWEP.AllowDrop              = false -- Is the player able to drop the swep

SWEP.IsSilent               = false

-- Pull out faster than standard guns
SWEP.DeploySpeed            = 2

--Removes the SWEP on death or drop
function SWEP:OnDrop()
	self:Remove()
end

-- Override original primary attack

function SWEP:PrimaryAttack()
   if timer.Exists("ttt2_pat_infection_timer") and SERVER then 
	   LANG.Msg(self:GetOwner(), "You can only infect one player at a time!", nil, MSG_MSTACK_WARN)
   end
   if not timer.Exists("ttt2_pat_timer_cooldown") and not timer.Exists("ttt2_pat_infection_timer") then
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      local coughPitch = math.Rand(10,25)
      local coughYaw = math.Rand(-10,10)
      self:GetOwner():ViewPunch(Angle( coughPitch, coughYaw, 0 ) )
      if not IsValid(self:GetOwner()) then return end

      self:GetOwner():LagCompensation(true)

      local spos = self:GetOwner():GetShootPos()
      local sdest = spos + (self:GetOwner():GetAimVector() * 70)

      local kmins = Vector(1,1,1) * -10
      local kmaxs = Vector(1,1,1) * 10

      local tr = util.TraceHull({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

      -- Hull might hit environment stuff that line does not hit
      if not IsValid(tr.Entity) then
         tr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
      end

      local hitEnt = tr.Entity

      -- special cough sound and poison effect
      self:GetOwner():EmitSound( "coof.wav")
      local pdata = EffectData()
      pdata:SetEntity(self:GetOwner())
      local mouthOrigin = self:GetOwner():GetNetworkOrigin()
      mouthOrigin:Add( Vector(0, 0, 70)) -- 70 is height of player head
      pdata:SetOrigin(mouthOrigin)
      util.Effect("AntlionGib", pdata)

      -- effects
      if IsValid(hitEnt) then
         --if the entity he hit was a player
         if hitEnt:IsPlayer() then
            -- code for when a cough is successful goes here
            -- check if relevant player has immunity
            if hitEnt:HasEquipmentItem("item_pat_immunity") then 
				LANG.Msg(self:GetOwner(), "You have already infected that player!", nil, MSG_MSTACK_WARN)
			return end
            --start the cough cooldown
            STATUS:AddTimedStatus(self:GetOwner(), "ttt2_pat_cough_cooldown", GetConVar("ttt2_pat_cough_cooldown_timer"):GetInt() , true)
            timer.Create("ttt2_pat_timer_cooldown",GetConVar("ttt2_pat_cough_cooldown_timer"):GetInt(), 1, function()
            end)
            STATUS:AddTimedStatus(hitEnt, "ttt2_pat_infection_status", GetConVar("ttt2_pat_sickness_timer"):GetInt(), true)
            makePlayerPatientSick(hitEnt)
            timer.Create("ttt2_pat_infection_timer", GetConVar("ttt2_pat_sickness_timer"):GetInt(), 1, function()
               -- this is called when the timer runs out, player gains immunity.
               makePlayerPatientImmune(hitEnt)
            end)
         end
      end
      self:GetOwner():LagCompensation(false)
   end
end

--Remove timers when a round is started or ended
hook.Add("TTTBeginRound", "remove_timers_on_prepare", function()
	timer.Remove("ttt2_pat_timer_cooldown")
	timer.Remove("ttt2_pat_infection_timer")
end)

hook.Add("TTTEndRound", "remove_timers_on_prepare", function()
	timer.Remove("ttt2_pat_timer_cooldown")
	timer.Remove("ttt2_pat_infection_timer")
end)