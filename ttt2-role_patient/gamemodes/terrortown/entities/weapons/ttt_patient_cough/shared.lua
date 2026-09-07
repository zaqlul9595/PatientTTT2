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
SWEP.Primary.Delay          = GetConVar("ttt2_pat_cough_cooldown_timer"):GetInt()
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

if CLIENT then

    hook.Add("PostDrawTranslucentRenderables", "DrawPlayerCircle", function()

            --only render sphere for patients, and have the cough equipped
            if GetRoundState() ~= ROUND_ACTIVE then return end
            local client = LocalPlayer()
            if not client:IsValid() then return end
            if not client:Alive() or client:IsSpec() then return end
            if client:GetSubRole() ~= ROLE_PATIENT then return end
            if client:GetActiveWeapon() == NULL then return end
            if client:GetActiveWeapon():GetClass() ~= "ttt_patient_cough" then return end

            --Initialize colorsphere as the color of the role
            local colorSphere = util.ColorLighten(roles.PATIENT.color, 120)

            --alpha value for the sphere
            colorSphere.a = 3
            local pos = client:GetPos()

            --size of the sphere
            local maxRenderDistance = 200

            --set the color
            render.SetColorMaterial()

            --render both the back and front site of the sphere
            render.CullMode(MATERIAL_CULLMODE_CW)

            render.DrawSphere(pos, maxRenderDistance, 30, 30, colorSphere)
            render.CullMode(MATERIAL_CULLMODE_CCW)

    end)
end


-- Function that gives sick traits to a player
function makePlayerPatientSick(sickPlayer)

    sickPlayer:SetNWBool("patient_poisoned", true)
    if SERVER then
        sickPlayer:GiveItem("item_pat_infection") --give them the infection item that slows them down

        --add to global values
        --PATIENT_DATA:AddInfected(ply) --nil value error!

        local timerName = "ttt2_sick_ply_cough" .. sickPlayer:SteamID64()

        local function cough() --play cough procedure randomly, calls itself
            if not IsValid(sickPlayer) then return end
            if not sickPlayer:GetNWBool("patient_poisoned", false) then return end

            sickPlayer:EmitSound("coof.wav")
            local coughPitch = math.Rand(10, 25)
            local coughYaw = math.Rand(-10, 10)
            sickPlayer:ViewPunch(Angle(coughPitch, coughYaw, 0))

            local newCoughInterval = math.Rand(2,10)
            timer.Create(timerName, newCoughInterval, 1, cough)
        end


        --Begin the infection!
        timer.Create(timerName, math.Rand(2, 10), 1, cough)
        STATUS:AddTimedStatus(sickPlayer, "ttt2_pat_infection_status", GetConVar("ttt2_pat_sickness_timer"):GetInt(), true)
        timer.Create("ttt2_pat_infection_timer" .. sickPlayer:SteamID64(), GetConVar("ttt2_pat_sickness_timer"):GetInt(), 1, function()
            makePlayerPatientImmune(sickPlayer)
        end)







    end
end

-- Function that gives immune traits to a player
function makePlayerPatientImmune(sickPlayer)
    timer.Remove("ttt2_sick_ply_cough" .. sickPlayer:SteamID64())
    sickPlayer:SetNWBool("patient_poisoned", false)

    if SERVER then --replace infection items with immunity items
        sickPlayer:GiveItem("item_pat_immunity")
        sickPlayer:RemoveItem("item_pat_infection")
        STATUS:AddStatus(sickPlayer, "ttt2_pat_immune_status")

        if GetConVar("ttt2_get_full_health_on_immunity"):GetBool() then
            sickPlayer:SetHealth(sickPlayer:GetMaxHealth())
        end
    end
end



--function that checks if players are in the infection sphere
function checkIfPlyInSphere(patient, playersInfected)
    --makePlayerPatientSick(patient) --make patient sick for testing
    local patPos = patient:GetPos()
    for _, ply in ipairs( player.GetAll() ) do

        --valid player checks
        if not ply:Alive() or ply:IsSpec() then return end
        if ply:HasEquipmentItem("item_pat_immunity") then continue end

        --skip patient player
        if patient == ply then continue end
            --if in radius, infect!
            if ply:GetPos():Distance(patPos) <= 200 then
                makePlayerPatientSick(ply)
                table.insert(playersInfected, ply:Nick())
            end

    end

end

-- Override original primary attack
function SWEP:PrimaryAttack()

    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    STATUS:AddTimedStatus(owner, "ttt2_pat_cough_cooldown", GetConVar("ttt2_pat_cough_cooldown_timer"):GetInt() , true)



    --Initialize table to track players infected this cough
    local playersInfected = {}

    owner:LagCompensation(true)


    --play cough sound
    owner:EmitSound("coof.wav")

    if SERVER then
        --Check if anyone is in the sphere
        checkIfPlyInSphere(owner, playersInfected)
    end

    --init players infected as nobody
    --concatenate table as a string of players
    print(playersInfected)
    local playersInfectedStr = "Nobody"

    if #playersInfected > 0 then
        playersInfectedStr = table.concat(playersInfected, "\n")
    end

    --display message of people infected
    if SERVER then
        EPOP:AddMessage(owner, {text = "Players Infected!", color = roles.PATIENT.color}, playersInfectedStr, 4, true)
    end

    owner:LagCompensation(false)

end












