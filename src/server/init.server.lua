local Players = game:GetService("Players")
local Directory = require(game:GetService("ReplicatedStorage").Directory)

local RemoteService = require(script.Services.RemoteService)
local ServerReplicationService = require(script.Services.ServerReplicationService)
local CharacterService = Directory.Retrieve("Services/CharacterService")

local Item = Directory.Retrieve("Classes/Item")

RemoteService.InitializeRemoteEvent("ClientReplication")
local ServerReplication = RemoteService.InitializeRemoteEvent("ServerReplication")

Players.PlayerAdded:Connect(function(player: Player)
	local character = CharacterService.LoadCharacter(player)
	print(character.MaxHealth)

	character.MaxHealth = 5

	local TestItem = Item.new(Directory.Retrieve("Items/Weapons/FishingRod"))

	TestItem.Owner = player

	character:EquipItem(TestItem:GetObject())
end)

Players.PlayerRemoving:Connect(function(player: Player)
	CharacterService.UnloadCharacter(player)
end)

ServerReplication.OnServerEvent:Connect(function(player: Player, event: string, ...)
	if ServerReplicationService.Callbacks[event] then
		ServerReplicationService.Callbacks[event](player, ...)
	end
end)