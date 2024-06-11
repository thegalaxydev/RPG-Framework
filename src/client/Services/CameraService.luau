local CameraService = {}

local Camera = workspace.CurrentCamera
local Player = game.Players.LocalPlayer

Camera.CameraType = Enum.CameraType.Scriptable

CameraService.CameraHeight = 5
CameraService.CameraDistance = 125



CameraService.FOV = 6
Camera.FieldOfView = CameraService.FOV

function CameraService.Update(deltaTime: number)
	local Character = Player.Character
	if not Character then return end

	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local rootPosition = HumanoidRootPart.Position + Vector3.new(0, CameraService.CameraHeight, 0)
	local cameraPosition = rootPosition + Vector3.new(CameraService.CameraDistance, CameraService.CameraDistance, CameraService.CameraDistance)

	Camera.CFrame = CFrame.lookAt(cameraPosition, rootPosition)

	local mouse = Player:GetMouse()
	local target = mouse.Hit.Position

	local direction = (target - HumanoidRootPart.Position).Unit
	direction = Vector3.new(direction.X, 0, direction.Z).Unit

	local lookAtCFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + direction)

	Character:SetPrimaryPartCFrame(lookAtCFrame)

	local rayParams = RaycastParams.new()
	local cameraRay = workspace:Raycast(Camera.CFrame.Position, (HumanoidRootPart.Position - Camera.CFrame.Position).Unit * 999, rayParams)
	
	if Character:FindFirstChild("Highlight") then
		Character.Highlight:Destroy()
	end

	if cameraRay and not cameraRay.Instance:FindFirstAncestor(Character.Name) then

		local highlight = Instance.new("Highlight")
		highlight.Name = "Highlight"
		highlight.FillTransparency = 1
		highlight.OutlineColor = Color3.fromRGB(246, 244, 89)
		highlight.Parent = Character
	end
end

function CameraService.TweenCamera(properties: {any}, duration: number)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
	local tween = game:GetService("TweenService"):Create(Camera, tweenInfo, properties)
	tween:Play()
end


return CameraService
