local Directory = require(game.ReplicatedStorage.Directory)
local System = Directory.Retrieve("System")

return {
	Name = "Sword",
	Cost = 10,
	Model = game:GetService("ReplicatedStorage").Assets.Models.Weapons.Sword,
	Icon = "rbxassetid://0",
	MaxStack = 1,
	Equippable = true,
	Tags = {
		ItemType = "Weapon",
		BaseDamage = 10,
		AttackCooldown = 0.3,
		CanAttack = true,
	},
	Callbacks = {
		Use = function(self, player: Player)
			if not self.Tags.CanAttack then return end

			self.Tags.CanAttack = false

			if game:GetService("RunService"):IsClient() then
				if not self.UseAnimation then
					local character = player.Character or player.CharacterAdded:Wait()
					local humanoid = character:WaitForChild("Humanoid")
					local animator = humanoid:WaitForChild("Animator")
					local anim = self.Model:WaitForChild("UseAnimation")
					
					self.UseAnimation = animator:LoadAnimation(anim)

					self.UseAnimation:AdjustSpeed(5)
					self.UseAnimation:Play()

				else
					self.UseAnimation:Play()
				end
			else
				System.HandleDamage(player, self.Tags.BaseDamage)
			end

			task.wait(self.Tags.AttackCooldown)

			self.Tags.CanAttack = true

			return true
		end,
	}
}