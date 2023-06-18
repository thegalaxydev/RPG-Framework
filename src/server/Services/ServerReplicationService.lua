local ServerReplicationService = {}
local Directory = require(game:GetService("ReplicatedStorage").Directory)
local CharacterService = Directory.Retrieve("Services/CharacterService")

ServerReplicationService.Callbacks = {
	["Sprint"] = function(player: Player, shouldSprint: boolean)
		local character = player.Character or player.CharacterAdded:Wait()

		character.Humanoid.WalkSpeed = shouldSprint and 32 or 16
	end,

	["UseItem"] = function(player: Player)
		local character = CharacterService:GetCharacterFromPlayer(player)

		character:UseItem()
	end
}

return ServerReplicationService