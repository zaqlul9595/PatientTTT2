if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "item_patient_immunity_title",
    desc = "item_patient_immunity_desc",
}
ITEM.CanBuy = { }

ITEM.material = "vgui/ttt/icon_speedrun"
ITEM.builtin = false

hook.Add("TTTPlayerSpeedModifier", "TTT2PatientSpeedrunGood", function(ply, _, _, speedMultiplierModifier)
    if not IsValid(ply) or not ply:HasEquipmentItem("item_pat_immunity") then
        return
    end

    speedMultiplierModifier[1] = speedMultiplierModifier[1] * 1.1
end)
