local Item = {}
Item.__index = Item

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

export type Item = typeof(setmetatable({}, Item)) & ItemParameters

function Item.new(params: ItemParameters)
	local self = setmetatable({}, Item)
	
	self.Name = params.Name
	self.Cost = params.Cost or 0
	self.Model = params.Model
	self.Icon = params.Icon
	self.MaxStack = params.MaxStack or 1
	self.Count = 1
	self.Owner = params.Owner
	
	if params.Callbacks then
		for method, callback in pairs(params.Callbacks) do
			self[method] = callback
		end
	end
	
	return self
end

function Item:Use()
	warn("Item does not have a use function.")
end

function Item:Equip()
	warn("Item does not have an equip function.")
end

function Item:Unequip()
	warn("Item does not have an unequip function.")
end


return Item