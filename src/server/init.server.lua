local Players = game:GetService("Players")
local Directory = require(game:GetService("ReplicatedStorage").Directory)

local RemoteService = require(script.Services.RemoteService)
local CharacterService = Directory.Retrieve("Services/CharacterService")

local Item = Directory.Retrieve("Classes/Item")
local Weapon = Directory.Retrieve("Classes/Weapon")

RemoteService.InitializeRemoteEvent("ClientReplication")

Players.PlayerAdded:Connect(function(player: Player)
	local character = CharacterService.LoadCharacter(player)
	print(character.MaxHealth)

	character.MaxHealth = 5

	local TestItem = Weapon.new(Directory.Retrieve("Items/Weapons/Sword"))

	TestItem.Owner = player

	TestItem:print()
	TestItem:Equip()
	
end)

Players.PlayerRemoving:Connect(function(player: Player)
	CharacterService.UnloadCharacter(player)
end)