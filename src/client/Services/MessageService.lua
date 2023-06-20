local MessageService = {}
local Message = game.ReplicatedStorage.Assets.UI.Message

local TweenService = game:GetService("TweenService")

function MessageService:SendMessage(msg: string, duration: number?)
	local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local Messages = PlayerGui:WaitForChild("Messages")


	local newMessage = Message:Clone()
	newMessage.Parent = Messages.Frame

	newMessage.TextTransparency = 1
	newMessage.BackgroundTransparency = 1

	local enterTween = TweenService:Create(newMessage, TweenInfo.new(0.5), {BackgroundTransparency = 0.5, TextTransparency = 0})

	enterTween:Play()

	task.wait(enterTween.TweenInfo.Time)

	for i = 1, #msg do
		newMessage.Text = msg:sub(1, i)

		if not newMessage.TextFits then
			-- size the textlabel to make it fit
			newMessage.Size = UDim2.new(0, newMessage.TextBounds.X + 20, 0, newMessage.TextBounds.Y + 20)
		end

		task.wait(0.5 / #msg)
	end

	local exitTween = TweenService:Create(newMessage, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1})

	if not duration then duration = 5 end

	task.delay(duration, function()
		exitTween:Play()
		task.wait(exitTween.TweenInfo.Time)
		newMessage:Destroy()
	end)
end

return MessageService
