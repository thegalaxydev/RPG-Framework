local CharacterService = require(script.Parent.Parent.Services.CharacterService)
local System = require(script.Parent.Parent.System)

return {
	Name = "The One Ring",
	Cost = math.huge,
	Model = nil,
	Icon = "rbxassetid://0",
	MaxStack = 1,

	Callbacks = {
		Equip = function(self, player: Player)
			local character = CharacterService.GetCharacterFromPlayer(player)
			character.Burdened = true
			System.SendMessage("One ring to rule them all, one ring to find them. One ring to bring them all, and in the darkness bind them.", player, 4)
			task.wait(5)
			System.SendMessage("You are burdened with power. You have left the physical world.", player)
			CharacterService.Effects["Invisible"].Apply(character)

			return true
		end,

		Unequip = function(self, player: Player)
			local character = CharacterService.GetCharacterFromPlayer(player)
			character.Burdened = false

			CharacterService.Effects["Invisible"].Remove(character)

			return true
		end,

		Use = function(self, player: Player)			
			return true
		end
	}
}