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

	return self
end
