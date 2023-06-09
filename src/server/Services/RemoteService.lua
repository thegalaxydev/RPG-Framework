local RemoteService = {}

function RemoteService.InitializeRemoteFunction(name: string) : RemoteFunction
	local Remote = Instance.new("RemoteFunction")
	Remote.Name = name

	if game.ReplicatedStorage:FindFirstChild("Remotes") then
		Remote.Parent = game.ReplicatedStorage.Remotes
	else
		local Remotes = Instance.new("Folder")
		Remotes.Name = "Remotes"
		Remotes.Parent = game.ReplicatedStorage
		Remote.Parent = Remotes
	end
	
	return Remote
end

function RemoteService.InitializeRemoteEvent(name: string) : RemoteEvent
	local Remote = Instance.new("RemoteEvent")
	Remote.Name = name

	if game.ReplicatedStorage:FindFirstChild("Remotes") then
		Remote.Parent = game.ReplicatedStorage.Remotes
	else
		local Remotes = Instance.new("Folder")
		Remotes.Name = "Remotes"
		Remotes.Parent = game.ReplicatedStorage
		Remote.Parent = Remotes
	end

	return Remote
end

return RemoteService