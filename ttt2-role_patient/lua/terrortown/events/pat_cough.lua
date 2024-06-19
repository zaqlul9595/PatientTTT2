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
end

-- Function that gives immune traits to a player
function makePlayerPatientImmune(sickPlayer)
    print(tostring(sickPlayer) .. " BECAME IMMUNE.")
    if SERVER then
        sickPlayer:GiveItem("item_ttt_speedrun")
    end
end