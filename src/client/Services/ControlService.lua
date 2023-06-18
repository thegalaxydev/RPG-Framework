local ContextActionService = game:GetService("ContextActionService")
local Directory = require(game:GetService("ReplicatedStorage").Directory)
local ControlService = {}

local Player = game.Players.LocalPlayer
local CharacterService = Directory.Retrieve("Services/CharacterService")
local CameraService = require(script.Parent.CameraService)

local ServerReplication = game.ReplicatedStorage.Remotes.ServerReplication


ControlService.Keybinds = {
	["ITEM_USE"] = {{Enum.UserInputType.MouseButton1}, function(actionName, inputState, inputObject)
		local Character = CharacterService.GetCharacterFromPlayer(Player)

		Character:UseItem()
	end},

	["ITEM_EQUIP_1"] = {{Enum.KeyCode.One}, function(actionName, inputState, inputObject) 
		
	end},

	["ITEM_EQUIP_2"] = {{Enum.KeyCode.Two}, function(actionName, inputState, inputObject) 
		
	end},

	["ITEM_EQUIP_3"] = {{Enum.KeyCode.Three}, function(actionName, inputState, inputObject) 
	
	end},

	["ITEM_EQUIP_4"] = {{Enum.KeyCode.Four}, function(actionName, inputState, inputObject) 
	
	end},
	
	["ITEM_EQUIP_5"] = {{Enum.KeyCode.Five}, function(actionName, inputState, inputObject) 
	
	end},
	
	["ITEM_EQUIP_6"] = {{Enum.KeyCode.Six}, function(actionName, inputState, inputObject) 
	
	end},
	
	["ITEM_EQUIP_7"] = {{Enum.KeyCode.Seven}, function(actionName, inputState, inputObject) 
	
	end},
	
	["ITEM_EQUIP_8"] = {{Enum.KeyCode.Eight}, function(actionName, inputState, inputObject) 
	
	end},
	
	["ITEM_EQUIP_9"] = {{Enum.KeyCode.Nine}, function(actionName, inputState, inputObject) 
	
	end},

	["ITEM_EQUIP_0"] = {{Enum.KeyCode.Zero}, function(actionName, inputState, inputObject) 
	
	end},

	["SPRINT"] = {{Enum.KeyCode.LeftShift}, function(actionName, inputState, inputObject) 
		local fov = CameraService.FOV
		CameraService.FOV = inputState == Enum.UserInputState.Begin and fov + 2 or fov - 2
		ServerReplication:FireServer("Sprint", inputState == Enum.UserInputState.Begin)
	end},



	

}

function ControlService.InitializeKeybinds()
	for bind, keyInfo in pairs(ControlService.Keybinds) do
		ContextActionService:BindAction(bind, keyInfo[2] or function(actionName, inputState, inputObject)
			if inputState ~= Enum.UserInputState.Begin then return end
			warn("No callback available for " .. bind .. ".")
		end, false, unpack(keyInfo[1]))
	end
end

return ControlService