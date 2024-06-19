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
      desc = "Cough on other players to get them infected. Infected move slower, reduced vision, and an audible cough"
   };

   SWEP.Icon                = "vgui/ttt/icon_pat"
   SWEP.IconLetter          = "j"
end

SWEP.Base                   = "weapon_tttbase"

SWEP.UseHands               = true
SWEP.ViewModel              = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel             = "models/weapons/w_knife_t.mdl"

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Delay          = 1
SWEP.Primary.Ammo           = "none"

SWEP.Kind                   = WEAPON_CLASS
SWEP.AllowDrop              = false -- Is the player able to drop the swep

SWEP.IsSilent               = false

-- Pull out faster than standard guns
SWEP.DeploySpeed            = 2

--Removes the Talon on death or drop
function SWEP:OnDrop()
	self:Remove()
end

-- Override original primary attack
function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

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

   -- effects
   if IsValid(hitEnt) then
      --self:SendWeaponAnim( ACT_VM_MISSCENTER )

      local edata = EffectData()
      edata:SetStart(spos)
      edata:SetOrigin(tr.HitPos)
      edata:SetNormal(tr.Normal)
      edata:SetEntity(hitEnt)
      --if the entity he hit was a player
      if hitEnt:IsPlayer() then
        --code for when a cough is successful goes here
      end
   end

   if SERVER then
      self:GetOwner():SetAnimation()
   end
   if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) then
	   --coughing sound goes here
	   end
   end
   self:GetOwner():LagCompensation(false)