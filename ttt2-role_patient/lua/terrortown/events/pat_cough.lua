--Initialize statues
if CLIENT then
    hook.Add("Initialize", "ttt2_pat_init", function()
		STATUS:RegisterStatus("ttt2_pat_infection_status", {
			hud = Material("vgui/ttt/dynamic/roles/icon_pat.vmt"),
			type = "bad",
			name = "Patient Infection",
			sidebarDescription = "You have been infected by the Patient. You will gain immunity soon."
		})

        STATUS:RegisterStatus("ttt2_pat_immune_status", {
			hud = Material("vgui/ttt/dynamic/roles/icon_pat.vmt"),
			type = "good",
			name = "Patient Immunity",
			sidebarDescription = "You have gained immunity to the Patient's sickness. Enjoy the benefits!"
		})
		
		STATUS:RegisterStatus("ttt2_pat_cough_cooldown", {
			hud = Material("vgui/ttt/icons/lung_icon.png"),
			type = "bad",
			name = "Cough Cooldown",
			sidebarDescription = "You have coughed recently and it is on cooldown."
		})
	end)
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

function clearPatEffects(ply) --clears effects, use when players should no longer be infected/immunized
	timer.Remove("ttt2_sick_ply_cough" .. ply:SteamID64())
	ply:RemoveItem("item_pat_infection")
	ply:RemoveItem("item_pat_immunity")
	ply:SetNWBool("patient_poisoned", false)
end

-- remove any effects on player death
if SERVER then
	hook.Add("PostPlayerDeath", "patient_uninfection_effects_on_death", function(ply, infl, att)
		clearPatEffects(ply)
		timer.Remove("ttt2_sick_ply_cough" .. ply:SteamID64())
		timer.Remove("ttt2_pat_infection_timer" .. ply:SteamID64())
		timer.Remove("ttt2_wait_sickness" .. ply:SteamID64())
	end)
end


--remove statues from all players before, prepare and after a round
if SERVER then
	hook.Add("TTTPrepareRound","patient_remove_effects_prepare", function()
		for i, j in pairs(player.GetAll()) do
			clearPatEffects(j)
			timer.Remove("ttt2_sick_ply_cough" .. j:SteamID64())
			timer.Remove("ttt2_pat_infection_timer" .. j:SteamID64())
			timer.Remove("ttt2_wait_sickness" .. j:SteamID64())
		end
	end)

	hook.Add("TTTBeginRound", "patient_remove_effects_begin", function()
		for i, j in pairs(player.GetAll()) do
			clearPatEffects(j)
			timer.Remove("ttt2_sick_ply_cough" .. j:SteamID64())
			timer.Remove("ttt2_pat_infection_timer" .. j:SteamID64())
			timer.Remove("ttt2_wait_sickness" .. j:SteamID64())
		end
	end)

	hook.Add("TTTEndRound", "patient_remove_effects_end", function()
		for i, j in pairs(player.GetAll()) do
			clearPatEffects(j)
			timer.Remove("ttt2_sick_ply_cough" .. j:SteamID64())
			timer.Remove("ttt2_pat_infection_timer" .. j:SteamID64())
			timer.Remove("ttt2_wait_sickness" .. j:SteamID64())
		end
	end)
end
