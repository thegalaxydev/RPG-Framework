local System = {}

local RunService = game:GetService("RunService")
local Remotes = game.ReplicatedStorage.Remotes

local ClientReplication = Remotes:WaitForChild("ClientReplication")



function System.SendMessage(msg: string, player: Player?, duration: number?)
	if RunService:IsServer() then
		ClientReplication:FireClient(player, "SendMessage", msg, duration)
	else
		local localPlayer = game:GetService("Players").LocalPlayer

		local playerScripts = localPlayer:WaitForChild("PlayerScripts")
		local MessageService = require(playerScripts.Client.Services.MessageService)

		MessageService:SendMessage(msg, duration)
	end
end

function System.HandleDamage(player: Player, damage: number)
	local character = player.Character or player.CharacterAdded:Wait()
	local HRP = character:WaitForChild("HumanoidRootPart")
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {character}
	local rayResult = workspace:Raycast(HRP.Position, HRP.CFrame.LookVector * 5, rayParams)

	if rayResult then
		local hit = rayResult.Instance
		local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid:GetAttribute("Enemy") then
			humanoid:TakeDamage(damage)

			ClientReplication:FireClient(player, "ShowDamage", damage, hit.Position)
		end
	end

	

	return true
end

return System