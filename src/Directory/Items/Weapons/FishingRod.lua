return {
	Name = "FishingRod",
	Cost = 10,
	Model = game:GetService("ReplicatedStorage").Assets.Models.Weapons.FishingRod,
	Icon = "rbxassetid://0",
	MaxStack = 1,

	Callbacks = {
		Use = function(self, player: Player)
			local character = player.Character or player.CharacterAdded:Wait()
			local humanoid = character:WaitForChild("Humanoid")
			local animator = humanoid:WaitForChild("Animator")

			local rod = self.Model
			local anim = rod:WaitForChild("UseAnimation")

			local animTrack = animator:LoadAnimation(anim)

			animTrack:Play()

			return true
		end
	}
}