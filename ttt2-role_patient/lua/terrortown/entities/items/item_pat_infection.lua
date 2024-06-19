if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "item_patient_infection_title",
    desc = "item_patient_infection_desc",
}
ITEM.CanBuy = { }

ITEM.material = "vgui/ttt/icon_speedrun"
ITEM.builtin = false

hook.Add("TTTPlayerSpeedModifier", "TTT2PatientSpeedrunBad", function(ply, _, _, speedMultiplierModifier)
    if not IsValid(ply) or not ply:HasEquipmentItem("item_pat_infection") then
        return
    end

    speedMultiplierModifier[1] = speedMultiplierModifier[1] * 0.8
end)
