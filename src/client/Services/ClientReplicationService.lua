local ClientReplicationService = {}
local Directory = require(game:GetService("ReplicatedStorage").Directory)
local Player = game.Players.LocalPlayer
local CharacterService = Directory.Retrieve("Services/CharacterService")
local MessageService = require(script.Parent.MessageService)

ClientReplicationService.Callbacks = {
	["CharacterChanged"] = function(index, value)
		if CharacterService.Characters[Player] then
			CharacterService.Characters[Player][index] = value
		else
			CharacterService.LoadCharacter(Player)
			CharacterService.Characters[Player][index] = value
		end 

		print("Updated character.", index, value)
	end,
	["SendMessage"] = function(msg, duration)
		MessageService:SendMessage(msg, duration)
	end
}

return ClientReplicationService