local Players = game:GetService("Players")
local Directory = require(game:GetService("ReplicatedStorage").Directory)

local RemoteService = require(script.Services.RemoteService)
local ServerReplicationService = require(script.Services.ServerReplicationService)
local CharacterService = Directory.Retrieve("Services/CharacterService")

local Item = Directory.Retrieve("Classes/Item")

local PlayerService = require(script.Services.PlayerService)

RemoteService.InitializeRemoteEvent("ClientReplication")
local ServerReplication = RemoteService.InitializeRemoteEvent("ServerReplication")

Players.PlayerAdded:Connect(function(player: Player)
	PlayerService.PlayerAdded(player)

	player.CharacterAdded:Connect(PlayerService.CharacterAdded)
end)
Players.PlayerRemoving:Connect(PlayerService.PlayerRemoving)

ServerReplication.OnServerEvent:Connect(function(player: Player, event: string, ...)
	if ServerReplicationService.Callbacks[event] then
		ServerReplicationService.Callbacks[event](player, ...)
	end
end)