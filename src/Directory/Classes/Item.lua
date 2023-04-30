local Item = {}
Item.__index = Item

local Event = require(script.Parent.Event)

export type Item = typeof(setmetatable({}, Item)) & ItemParameters

export type ItemParameters = {
	Name: string,
	Cost: number?,
	Model: Model,
	Icon: string?,
	MaxStack: number?,
	Owner: Player,
	Callbacks: {
		Use: (self: Item, player: Player) -> ()?,
		Equip: (self: Item, player: Player) -> ()?,
		Unequip: (self: Item, player: Player) -> ()?,
	}?
}

function Item.new(params: ItemParameters)
	local self = setmetatable({}, Item)
	
	self.Name = params.Name
	self.Cost = params.Cost or 0
	self.Model = params.Model
	self.Icon = params.Icon
	self.MaxStack = params.MaxStack or 1
	self.Count = 1
	self.Owner = params.Owner

	self.Callbacks = {}
	
	if params.Callbacks then
		for method, callback in pairs(params.Callbacks) do
			self.Callbacks[method] = callback
		end
	end
	
	self.Changed = Event.new()
	self.OnEquip = Event.new()
	self.OnUnequip = Event.new()

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


	return Proxy
end

function Item:Use(player: Player)
	if not self.Callbacks["Use"] then
		warn(self.Name .. " does not have a use callback.")
		return	
	end

	self.Callbacks["Use"](self, player)
end

function Item:Equip(player: Player)
	if not self.Callbacks["Equip"] then
		warn(self.Name .. " does not have an equip callback.")
	elseif not self.Callbacks["Equip"](self, player) then
		return
	end

	self.OnEquip:Fire()
end

function Item:Unequip(player: Player)
	if not self.Callbacks["Unequip"] then
		warn(self.Name .. " does not have an unequip callback.")
	elseif not self.Callbacks["Unequip"](self, player) then
		return
	end

	self.OnUnequip:Fire()
end


return Item