local System = {}

local RunService = game:GetService("RunService")
local Remotes = game.ReplicatedStorage.Remotes

local ClientReplication = Remotes:WaitForChild("ClientReplication")


function System.SendMessage(msg: string, player: Player?, duration: number?)
	if RunService:IsServer() then
		ClientReplication:FireClient(player, "SendMessage", msg, duration)
	else
		local localPlayer = game:GetService("Players").LocalPlayer

		local playerScripts = localPlayer:WaitForChild("PlayerScripts")
		local MessageService = require(playerScripts.Client.Services.MessageService)

		MessageService:SendMessage(msg, duration)
	end
end

return System