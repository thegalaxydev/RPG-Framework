local Weapon = {}
Weapon.__index = Weapon

local Item = require(script.Parent.Item)

type ItemParameters = Item.ItemParameters
type Item = Item.Item

type WeaponParameters = {
	AttackSpeed: number,
	Damage: number,
	Range: number,
} & ItemParameters

export type Weapon = typeof(setmetatable({}, Weapon)) & WeaponParameters & Item

function Weapon.new(params: WeaponParameters)
	local self = setmetatable(Item.new(params), Weapon)

	self.AttackSpeed = params.AttackSpeed
	self.Damage = params.Damage
	self.Range = params.Range

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

return Weapon