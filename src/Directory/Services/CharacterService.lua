local CharacterService = {}
local Character = require(script.Parent.Parent.Classes.Character)
local Event = require(script.Parent.Parent.Classes.Event)
type Character = Character.Character

CharacterService.Characters = {}

CharacterService.CharacterAdded = Event.new()

CharacterService.Effects = {
	Invisible = {
		Apply = function(character: Character, duration: number?)
			
			local playerCharacter = character.Player.Character or character.Player.CharacterAdded:Wait()

			for _,v in pairs(playerCharacter:GetChildren()) do
				if v:IsA("MeshPart") and v.Name ~= "HumanoidRootPart" then
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
	local character = CharacterService.Characters[player.Name]

	return character
end

function CharacterService.LoadCharacter(player: Player) : Character
	local newCharacter = Character.new()
	CharacterService.Characters[player.Name] = newCharacter
	
	print(CharacterService.Characters)

	newCharacter.Player = player

	CharacterService.CharacterAdded:Fire(newCharacter)

	return newCharacter
end

function CharacterService.UnloadCharacter(player: Player)
	CharacterService.Characters[player.Name] = nil
end

return CharacterService