local CharacterService = {}
local Character = require(script.Parent.Parent.Classes.Character)
type Character = Character.Character


CharacterService.Characters = {}

function CharacterService.GetCharacterFromPlayer(player: Player) : Character
	return CharacterService.Characters[player] or CharacterService.LoadCharacter(player)
end

function CharacterService.LoadCharacter(player: Player) : Character
	local newCharacter = Character.new()
	CharacterService.Characters[player] = newCharacter

	return newCharacter
end

function CharacterService.UnloadCharacter(player: Player)
	CharacterService.Characters[player] = nil
end

return CharacterService