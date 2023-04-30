local Players = game:GetService("Players")
local Directory = require(game:GetService("ReplicatedStorage").Directory)

local CharacterService = Directory.Retrieve("Services/CharacterService")

Players.PlayerAdded:Connect(function(player: Player)
	local character = CharacterService.LoadCharacter(player)
	print(character.MaxHealth)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	CharacterService.UnloadCharacter(player)
end)