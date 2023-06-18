local CameraService = {}

local Camera = workspace.CurrentCamera
local Player = game.Players.LocalPlayer

Camera.CameraType = Enum.CameraType.Scriptable

CameraService.CameraHeight = 5
CameraService.CameraDistance = 150



CameraService.FOV = 6

function CameraService.Update(deltaTime: number)
	Camera.FieldOfView = CameraService.FOV

	local Character = Player.Character or Player.CharacterAdded:Wait()

	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

	local rootPosition = HumanoidRootPart.Position + Vector3.new(0, CameraService.CameraHeight, 0)
	local cameraPosition = rootPosition + Vector3.new(CameraService.CameraDistance,CameraService.CameraDistance,CameraService.CameraDistance)

	Camera.CFrame = CFrame.lookAt(cameraPosition, rootPosition)
end

return CameraService
