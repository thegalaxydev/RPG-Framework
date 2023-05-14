local Character = {}
Character.__index = Character

local Event = require(script.Parent.Event)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Item = require(script.Parent.Item)

export type Character = typeof(setmetatable({}, Character))

function Character.new() : Character
	local self = setmetatable({}, Character)
	
	self.LevelStats = {
		Defense = 0,
		Agility = 0,
		Vitality = 0,
		Intelligence = 0,
		Strength = 0,
	}

	self.Health = 0
	self.MaxHealth = 0

	self.Mana = 0
	self.MaxMana = 0

	self.Player = nil

	self.AttackSpeed = 0
	self.Armor = 0
	self.Speed = 0
	self.Jump = 0 
	self.DodgeCooldown = 0
	self.Stamina = 0
	self.Reputation = 0

	self.Currency = {Platinum = 0, Gold = 0, Silver = 0, Copper = 0}

	self.Inventory = {}
	self.Equipment = {
		Head = nil,
		Torso = nil,
		Arms = nil,
		Legs = nil,
		Feet = nil
	}

	self.EquippedItem = nil

	self.Changed = Event.new()
	self.Died = Event.new()

	local Proxy = setmetatable({}, {	
		__newindex = function(tab, index, value)
			if tab.Changed then
				tab.Changed:Fire(index, value)
			end

			if RunService:IsServer() and ReplicatedStorage:FindFirstChild("Remotes") then
				local Remote = ReplicatedStorage.Remotes:FindFirstChild("ClientReplication")
				
				if Remote then
					Remote:FireAllClients("CharacterChanged", index, value)
				end
			end

			self[index] = value
		end,

		__index = function(tab, index)
			return self[index]
		end
	})
	
	function Character:TakeDamage(Damage: number)
		self.Health = self.Health - Damage
		if self.Health <= 0 then
			self.Died:Fire()
		end
	end

	function Character:EquipItem(Item: Item.Item)
		if self.EquippedItem then
			self.EquippedItem:Unequip(self.Owner)
		end

		self.EquippedItem = Item
		Item:Equip(self.Owner)
	end

	function Character:UnequipItem()
		if self.EquippedItem then
			self.EquippedItem:Unequip(self.Owner)
			self.EquippedItem = nil
		end
	end

	

	return Proxy
end






return Character