local Character = {}
Character.__index = Character

local Event = require(script.Parent.Event)

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
		Weapon = nil,
		Head = nil,
		Torso = nil,
		Arms = nil,
		Legs = nil,
		Feet = nil
	}

	self.Changed = Event.new()
	self.Died = Event.new()

	local Proxy = setmetatable({}, {	
		__newindex = function(tab, index, value)
			if tab.Changed then
				tab.Changed:Fire(index, value)
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

	return Proxy
end






return Character