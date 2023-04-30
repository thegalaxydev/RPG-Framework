local CharacterService = require(script.Parent.Parent.Parent.Services.CharacterService)

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
			-- System.SendMessage("One ring to rule them all, one ring to find them. One ring to bring them all, and in the darkness bind them.", player)
			-- System.SendMessage("You are burdened with power. You have left the physical world.", player)

			-- System.ApplyEffect(player, "Invisible", math.huge)

			return true
		end,

		Unequip = function(self, player: Player)
			local character = CharacterService.GetCharacterFromPlayer(player)
			character.Burdened = false

			return true
		end,

		Use = function(self, player: Player)			
			return true
		end
	}
}