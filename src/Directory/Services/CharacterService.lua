local CharacterService = {}
local Character = require(script.Parent.Parent.Classes.Character)
type Character = Character.Character

CharacterService.Characters = {}

CharacterService.Effects = {
	Invisible = {
		Apply = function(character: Character, duration: number?)
			local playerCharacter = character.Player.Character or character.Player.CharacterAdded:Wait()

			for _,v in pairs(playerCharacter:GetChildren()) do
				if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
					v.Transparency = 0.5
				end
			end

			if duration then
				task.delay(duration, function()
					CharacterService.Effects["Invisible"].Remove(character)
				end)
			end

		end,
		
		Remove = function(character: Character)
			local playerCharacter = character.Player.Character or character.Player.CharacterAdded:Wait()

			for _,v in pairs(playerCharacter:GetChildren()) do
				if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
					v.Transparency = 0
				end
			end
		end
	}
}

function CharacterService.GetCharacterFromPlayer(player: Player) : Character
	return CharacterService.Characters[player] or CharacterService.LoadCharacter(player)
end

function CharacterService.LoadCharacter(player: Player) : Character
	local newCharacter = Character.new()
	CharacterService.Characters[player] = newCharacter

	newCharacter.Player = player

	return newCharacter
end

function CharacterService.UnloadCharacter(player: Player)
	CharacterService.Characters[player] = nil
end

return CharacterService