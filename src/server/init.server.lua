local Players = game:GetService("Players")

local Directory = require(game:GetService("ReplicatedStorage").Directory)
local Item = Directory.Retrieve("Class/Item")
print(Item)


game.Players.PlayerAdded:Connect(function(Player: Player)
	local Apple = Directory.Retrieve("Item/Apple")
	
	local newApple = Item.new(Apple)

	Player.CharacterAdded:Connect(function(Character: Model)
		newApple:Equip(Player)

		wait(6)
		newApple:Unequip(Player)
	end)
end)