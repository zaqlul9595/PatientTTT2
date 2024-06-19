
if CLIENT then
    hook.Add("Initialize", "ttt2_pat_init", function()
		STATUS:RegisterStatus("ttt2_pat_infection_status", {
			hud = Material("vgui/ttt/dynamic/roles/icon_pat.vmt"),
			type = "bad",
			name = "Patient Infection",
			sidebarDescription = "You have been infected by the Patient. You will gain immunity soon."
		})

        STATUS:RegisterStatus("ttt2_pat_infection_status", {
			hud = Material("vgui/ttt/dynamic/roles/icon_pat.vmt"),
			type = "good",
			name = "Patient Immunity",
			sidebarDescription = "You have gained immunity to the Patient's sickness. Enjoy the benefits!"
		})
	end)
end

-- Function that gives sick traits to a player
function makePlayerPatientSick(sickPlayer)
    print(tostring(sickPlayer) .. " BECAME SICK.")
    sickPlayer:SetNWBool("patient_poisoned", true)
    if SERVER then
        sickPlayer:GiveItem("item_pat_infection")
    end
end

-- make the screen slightly yellow and blend some frames as a kind of "nausea" effect
if CLIENT then
    hook.Add("RenderScreenspaceEffects", "patient_infection_effects", function()
        if LocalPlayer():GetNWBool("patient_poisoned", false) then
            local colorModify = {
	        [ "$pp_colour_addr" ] = 0.3,
	        [ "$pp_colour_addg" ] = 0.3,
	        [ "$pp_colour_addb" ] = 0,
	        [ "$pp_colour_brightness" ] = 0,
	        [ "$pp_colour_contrast" ] = 1,
	        [ "$pp_colour_colour" ] = 1,
	        [ "$pp_colour_mulr" ] = 0,
	        [ "$pp_colour_mulg" ] = 0,
                [ "$pp_colour_mulb" ] = 0
            }
            DrawColorModify(colorModify)
            DrawMotionBlur(0.17, 0.65, 0.03)
        end
    end)
end

-- remove any poison effects on player death or round start
if SERVER then
    hook.Add("PostPlayerDeath", "patient_uninfection_effects_on_death", function(ply, infl, att)
        ply:SetNWBool("patient_poisoned", false)
    end)
    hook.Add("TTTPrepareRound", "patient_uninfection_effects_on_prepare", function()
        for i, j in pairs(player.GetAll()) do
            j:SetNWBool("patient_poisoned", false)
        end
    end)
end

-- Function that gives immune traits to a player
function makePlayerPatientImmune(sickPlayer)
    print(tostring(sickPlayer) .. " BECAME IMMUNE.")
    sickPlayer:SetNWBool("patient_poisoned", false)
    if SERVER then
        sickPlayer:GiveItem("item_pat_immunity")
        sickPlayer:RemoveItem("item_pat_infection")
    end
end
