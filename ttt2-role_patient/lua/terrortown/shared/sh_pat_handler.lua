AddCSLuaFile()

--global variables to track players infected
PATIENT_DATA = {}
PATIENT_DATA.players_infected = 0
PATIENT_DATA.players_needed_to_infect = 99

--networking incase values need to get updated
if CLIENT then
    net.Receive("ttt2_role_patient_update", function()
    PATIENT_DATA.players_infected = netReadUInt(16)
    PATIENT_DATA.players_needed_to_infect = netReadUInt(16)
    end)
end



if SERVER then
    util.AddNetworkString("ttt2_role_patient_update")

    hook.Add("TTTBeginRound","PatientStartRound",function()

        PATIENT_DATA.players_infected = 0
        --Calculate how many players to infect to start pandemic
        PATIENT_DATA.players_needed_to_infect = math.ceil(#util.GetActivePlayers() * 0.5)
        PATIENT_DATA.infected_players = {}

        --Sends to client
        net.Start("ttt2_role_patient_update")
        net.WriteUInt(PATIENT_DATA.players_infected, 16)
        net.WriteUInt(PATIENT_DATA.players_needed_to_infect, 16)
        net.Broadcast()

    end)

    -- reset hooks at round end AND start
    hook.Add("TTTEndRound", "PatientEndRound", function()
        PATIENT_DATA.players_infected = 0
        PATIENT_DATA.infected_players = {}
    end)

end

--add infected player
function PATIENT_DATA:AddInfected(infected_ply)

    self.players_infected = self.players_infected + 1

    --Sync to client
    net.Start("ttt2_role_patient_update")
    net.WriteUInt(PATIENT_DATA.players_infected, 16)
    net.WriteUInt(PATIENT_DATA.players_needed_to_infect, 16)
    net.Broadcast()


    checkStartPandemic()

end

--Needed for clientside HUD display
function PATIENT_DATA:GetInfectedAmount()
    return self.players_infected
end

function PATIENT_DATA:GetPlayersNeededToInfect()
    return self.players_needed_to_infect
end

function PATIENT_DATA:GetInfectedPlayers()
    return self.infected_players
end

function checkStartPandemic()
    if self.players_infected >= self.players_needed_to_infect
        startPandemic()
    end
end

function startPandemic()
    LANG.MsgAll("The Pandemic... Is Starting", nil, MSG_MSTACK_WARN)
end


