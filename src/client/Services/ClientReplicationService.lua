local ClientReplicationService = {}
local Directory = require(game:GetService("ReplicatedStorage").Directory)
local Player = game.Players.LocalPlayer
local CharacterService = Directory.Retrieve("Services/CharacterService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessageService = require(script.Parent.MessageService)
local TS = game:GetService("TweenService")

local Item = Directory.Retrieve("Classes/Item")

ClientReplicationService.Callbacks = {
	["CharacterChanged"] = function(index, value)
		if CharacterService.Characters[Player.Name] then
			CharacterService.Characters[Player.Name][index] = value
		else
			CharacterService.LoadCharacter(Player)
			CharacterService.Characters[Player.Name][index] = value
		end 

	end,
	["SendMessage"] = function(msg, duration)
		MessageService:SendMessage(msg, duration)
	end,

	["ShowDamage"] = function(damage: number, position: Vector3)
		print("showing damage")
		local part = Instance.new("Part")
		part.Transparency = 1
		part.Size = Vector3.new(0.05,0.05,0.05)
		part.Anchored = true
		
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false

		part.Parent = workspace

		part.CFrame = CFrame.new(position)

		local PlayerGui = Player:WaitForChild("PlayerGui")

		local gui = Instance.new("BillboardGui")
		gui.Parent = PlayerGui
		gui.AlwaysOnTop = true
		gui.Size = UDim2.new(1,0,1,0)
		gui.Adornee = part

		local text = ReplicatedStorage.Assets.UI.DamageText:Clone()
		text.Text = tostring(damage)
		text.Parent = gui

		text.FontFace = Font.new("rbxassetid://12187375194")
		
		gui.StudsOffset = Vector3.new(math.random(-3,3), math.random(-3,3), math.random(-3,3))
		local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local guiTween = TS:Create(gui, tweenInfo, {StudsOffset = Vector3.new(gui.StudsOffset.X,6,gui.StudsOffset.Z)})
		TS:Create(text, tweenInfo, {TextTransparency = 1}):Play()
		guiTween:Play()


		game:GetService("Debris"):AddItem(part, guiTween.TweenInfo.Time)
		game:GetService("Debris"):AddItem(gui, guiTween.TweenInfo.Time)
	end,
	
	["EquipItem"] = function(name: string)
		local Items = Directory.Retrieve("Items")
		local item = Items:FindFirstChild(name)
		if item then item = require(item) end

		if item then
			local newItem = Item.new(item):GetObject()
			newItem.Owner = Player
			CharacterService.Characters[Player.Name].EquippedItem = newItem

			if newItem.EquipAnimation then
				newItem.EquipAnimation:Play()
			else
				local character = Player.Character or Player.CharacterAdded:Wait()
				local humanoid = character:WaitForChild("Humanoid")
				local animator = humanoid:WaitForChild("Animator")
				local anim = newItem.Model:WaitForChild("EquipAnimation")
				
				if anim then
					newItem.EquipAnimation = animator:LoadAnimation(anim)
		
					newItem.EquipAnimation:Play()
				end
	
			end

			
		end
	end
}

return ClientReplicationService