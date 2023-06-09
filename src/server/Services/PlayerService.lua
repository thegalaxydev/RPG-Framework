local PlayerService = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Directory = require(ReplicatedStorage.Directory)
local CharacterService = Directory.Retrieve("Services/CharacterService")
local Item = Directory.Retrieve("Classes/Item")

local DataService = require(script.Parent.DataService)


local Assets = ReplicatedStorage.Assets
local UI = Assets.UI
local OverheadUI = UI:WaitForChild("OverheadUI")

local PlayerData = DataService:CreateDataStoreInstance({
	Name = "PlayerData",
	AutoSaveInterval = 60,
	ShouldAutoSave = true,

	DefaultData = {
		Character = {}
	}
})

function PlayerService.CharacterAdded(Character: Model)
	local Player = game.Players:GetPlayerFromCharacter(Character)
	local HRP = Character:FindFirstChild("HumanoidRootPart")

	local facer = Assets.Models.Character.Facer:Clone()
	local newUI = OverheadUI:Clone()
	newUI.NameTag.Text = Player.DisplayName:upper()
	newUI.Parent = HRP

	facer.Parent = workspace.FacerCache

	local weld :WeldConstraint = Instance.new("WeldConstraint")
	weld.Parent = HRP
	weld.Part0 = HRP
	weld.Part1 = facer

	facer.CFrame = HRP.CFrame * CFrame.new(Vector3.new(0,-2,-1)) * CFrame.Angles(0,math.rad(180),0)

	local playerCharacter = CharacterService.GetCharacterFromPlayer(Player)

	playerCharacter.Changed:Connect(function(index, value)
		newUI.HealthBackground.Health.Size = UDim2.new(playerCharacter.Health / playerCharacter.MaxHealth, 0, 1, 0)
	end)

	playerCharacter.MaxHealth = 150
	playerCharacter.Health = 50

	local TestItem = Item.new(Directory.Retrieve("Items/Sword"))
	playerCharacter:AddItem(TestItem, 5)

	playerCharacter:EquipItem(3)	

end

function PlayerService.PlayerAdded(Player: Player)
	local data = PlayerData:Load(Player.UserId)

	print(data)
	
	local playerCharacter = CharacterService.LoadCharacter(Player)

	if # data.Character == 0 then
		print(playerCharacter:GetObject())
		PlayerData:SetData(Player.UserId, "Character", CharacterService.PackData(playerCharacter))

	else
		CharacterService.SetData(playerCharacter, data.Character)
	end

	PlayerData:Save(Player.UserId)

	
end
	



function PlayerService.PlayerRemoving(Player: Player)
	CharacterService.UnloadCharacter(Player)
end



return PlayerService