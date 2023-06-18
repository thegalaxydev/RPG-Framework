export type Rarity = {
	Color: Color3,
	HasOverlay: boolean?,
	Chance: number
}

return {
	Common = {
		Color = Color3.fromRGB(148, 148, 148),
		HasOverlay = false,
		Chance = 0.7
	},
	
	Uncommon = {
		Color = Color3.fromRGB(121, 230, 102),
		HasOverlay = true,
		Chance = 0.4
	},

	Rare = {
		Color = Color3.fromRGB(102, 204, 255),
		HasOverlay = true,
		Chance = 0.2
	},

	Epic = {
		Color = Color3.fromRGB(204, 102, 255),
		HasOverlay = true,
		Chance = 0.1
	},

	Legendary = {
		Color = Color3.fromRGB(255, 255, 102),
		HasOverlay = true,
		Chance = 0.05
	}
}