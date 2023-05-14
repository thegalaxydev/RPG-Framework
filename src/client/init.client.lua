local Player = game.Players.LocalPlayer
local CameraService = require(script.Services.CameraService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local ClientReplication = Remotes:WaitForChild("ClientReplication")
local ClientReplicationService = require(script.Services.ClientReplicationService)

local ControlService = require(script.Services.ControlService)

game:GetService("RunService"):BindToRenderStep("Camera", Enum.RenderPriority.Camera.Value + 1, CameraService.Update)

ClientReplication.OnClientEvent:Connect(function(event: string, ...)
	if ClientReplicationService.Callbacks[event] then
		ClientReplicationService.Callbacks[event](...)
	end
end)

ControlService.InitializeKeybinds()
