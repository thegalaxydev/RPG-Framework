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
		Feet = nil,

		MainHand = nil,
		OffHand = nil,
		
	}

	self.EquippedItem = nil

	self.Changed = Event.new()
	self.Died = Event.new()

	local Proxy = setmetatable({GetObject = function() return self end}, {	
		__newindex = function(tab, index, value)
			if tab.Changed then
				tab.Changed:Fire(index, value)
			end

			if RunService:IsServer() and ReplicatedStorage:FindFirstChild("Remotes") then
				local Remote = ReplicatedStorage.Remotes:FindFirstChild("ClientReplication")
				
				if Remote then
					if index == "EquippedItem" then
						print("equipped item changed", value)
						Remote:FireClient(self.Player, "EquipItem", value.Name)
					else
						Remote:FireAllClients("CharacterChanged", index, value)
					end
				end
			end

			self[index] = value
		end,

		__index = function(tab, index)
			return self[index]
		end
	})
	return Proxy
end

function Character:TakeDamage(Damage: number)
	self.Health = self.Health - Damage
	if self.Health <= 0 then
		self.Died:Fire()
	end
end

-- This will return multiple items if there are multiple items with the same name
function Character:GetItem(itemName: string) : {[any]: any}
	local itemQuery = {}
	
	for _, itemInfo in pairs(self.Inventory) do
		if itemInfo.Item.Name == itemName then
			table.insert(itemQuery, itemInfo)
		end
	end

	return itemQuery
end

function Character:AddItem(item: Item.Item, count: number?)
	local items = self:GetItem(item.Name)
	local lowestNotFull = nil

	count = count or 1

	item.Owner = self.Player 
	
	
	if #items == 0 then
		local maxStack = item.MaxStack or 1
		local remainder = count % maxStack
		local stacks = math.floor(count / maxStack)
		if maxStack < count then
			for i = 1, stacks do
				table.insert(self.Inventory, {Item = table.clone(item), Count = maxStack})
			end
			if remainder > 0 then
				table.insert(self.Inventory, {Item = table.clone(item), Count = remainder})
			end
		else
			table.insert(self.Inventory, {Item = table.clone(item), Count = count})
		end

		return 
	end


	for _, itemInfo in pairs(items) do
		if itemInfo.Count < item.MaxStack then
			if not lowestNotFull or itemInfo.Count < lowestNotFull.Count then
				lowestNotFull = itemInfo
			end
		end
	end

	if lowestNotFull then
		local lowestCount = lowestNotFull.Count
		if count + lowestCount > item.MaxStack then
			local fillCount = (item.MaxStack - lowestCount) 
			local remainder = count - fillCount

			lowestNotFull.Count = lowestNotFull.Count + fillCount

			table.insert(self.Inventory, {Item = table.clone(item), Count = remainder})
		else
			lowestNotFull.Count = lowestNotFull.Count + count
		end
	end
end

function Character:EquipItem(index: number)

	
	local itemInfo = self.Inventory[index] 
	if itemInfo and itemInfo.Item and itemInfo.Item.Equippable then

		if self.EquippedItem then
			self.EquippedItem:Unequip()
		end

		itemInfo.Item:Equip()
		self.EquippedItem = itemInfo.Item
	end
end

function Character:UseItem()
	if self.EquippedItem then
		self.EquippedItem:Use()
	end
end

function Character:UnequipItem()
	if self.EquippedItem then
		self.EquippedItem:Unequip()
		self.EquippedItem = nil
	end
end


return Character