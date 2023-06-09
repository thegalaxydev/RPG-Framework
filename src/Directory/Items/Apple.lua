return {
	Name = "Apple",
	Cost = 10,
	Model = game:GetService("ReplicatedStorage").Assets.Models.Food.Apple,
	Icon = "rbxassetid://0",
	MaxStack = 10,

	Callbacks = {
		Equip = function(self, player: Player)
			local character = player.Character or player.CharacterAdded:Wait()
			local model = self.Model:Clone()
			model.Parent = character
			
			local main: BasePart = model.Main
			
			local hand = character:FindFirstChild("RightHand")
	
			local m6d = Instance.new("Motor6D")
			m6d.Parent = hand
			m6d.Part0 = hand
			m6d.Part1 = main
			m6d.C0 = CFrame.new(0, -main.Size.Y / 2, 0) * CFrame.Angles(math.rad(-90), 0, 0)

			self.Equipped = model

			return true
		end,

		Unequip = function(self, player: Player)
			if not self.Equipped then return false end
			self.Equipped:Destroy()

			return true
		end,

		Use = function(self, player: Player)
			if not self.Equipped then return end
			self.Count -= 1

			if self.Count <= 0 then
				self:Unequip(player)
			end
			
			return true
		end
	}
}