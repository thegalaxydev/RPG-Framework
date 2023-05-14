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

	local Proxy = setmetatable({GetObject = function() return self end}, {	
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

function Item:Use()
	if not self.Callbacks["Use"] then
		warn(self.Name .. " does not have a use callback.")
		if not self.Equipped then return end
		print(self.Count)
		self.Count -= 1

		if self.Count <= 0 then
			self:Unequip(self.Owner)
		end

		return	
	end

	self.Callbacks["Use"](self, self.Owner)
end

function Item:Equip()
	if not self.Callbacks["Equip"] then
		warn(self.Name .. " does not have an equip callback. Using default callback.")

		local character = self.Owner.Character or self.Owner.CharacterAdded:Wait()
		local model = self.Model:Clone()
		model.Parent = character
		
		local main: BasePart = model.Main
		
		local hand = character:FindFirstChild("RightHand")

		local m6d = Instance.new("Motor6D")
		m6d.Parent = hand
		m6d.Part0 = hand
		m6d.Part1 = main
		m6d.C0 = CFrame.new(0, -main.Size.Y / 2, 0) * CFrame.Angles(math.rad(-90), 0, 0)

		self.Equipped = model
	elseif not self.Callbacks["Equip"](self, self.Owner) then
		return
	end

	self.OnEquip:Fire()
end

function Item:Unequip()
	if not self.Callbacks["Unequip"] then
		warn(self.Name .. " does not have an unequip callback. Using default callback.")
		if not self.Equipped then return end
		self.Equipped:Destroy()
	elseif not self.Callbacks["Unequip"](self, self.Owner) then
		return
	end

	self.OnUnequip:Fire()
end


return Item