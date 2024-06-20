if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_pat.vmt")
	resource.AddFile( "materials/vgui/ttt/icons/lung_icon.png" )
end

function ROLE:PreInitialize()
  self.color = Color(191, 214, 65, 255)

  self.abbr = "pat" -- abbreviation
  self.surviveBonus = 0 -- bonus multiplier for every survive while another player was killed
  self.scoreKillsMultiplier = 2 -- multiplier for kill of player of another team
  self.scoreTeamKillsMultiplier = -8 -- multiplier for teamkill
  self.unknownTeam = true

  self.defaultTeam = TEAM_INNOCENT

  self.conVarData = {
    pct = 0.17, -- necessary: percentage of getting this role selected (per player)
    maximum = 1, -- maximum amount of roles in a round
    minPlayers = 6, -- minimum amount of players until this role is able to get selected
    credits = 0, -- the starting credits of a specific role
    togglable = true, -- option to toggle a role for a client if possible (F1 menu)
    random = 33,
    traitorButton = 0, -- can use traitor buttons
    shopFallback = SHOP_DISABLED
  }
end

-- now link this subrole with its baserole
function ROLE:Initialize()
  roles.SetBaseRole(self, ROLE_INNOCENT)
end

if SERVER then
   -- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentWeapon("ttt_patient_cough")
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon("ttt_patient_cough")
	end
end

CreateConVar("ttt2_pat_cough_cooldown_timer", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_pat_sickness_timer", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_get_full_health_on_immunity", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})

if CLIENT then
  function ROLE:AddToSettingsMenu(parent)
    local form = vgui.CreateTTT2Form(parent, "header_roles_additional")
	
	 form:MakeCheckBox({
      serverConvar = "ttt2_get_full_health_on_immunity",
      label = "label_pat_get_full_health_on_immunity"
    })
	
    form:MakeSlider({
      serverConvar = "ttt2_pat_cough_cooldown_timer",
      label = "label_pat_cough_cooldown_timer",
      min = 5,
      max = 120,
      decimal = 0
	
	})
	
	form:MakeSlider({
      serverConvar = "ttt2_pat_sickness_timer",
      label = "label_pat_sickness_timer",
      min = 5,
      max = 120,
      decimal = 0
    
	})
	
  end
end