local Directory = {}

function Directory.Retrieve(path: string) : ({}?, string)
	local split = string.split(path, "/")
	local current = script
	for i = 1, #split do
		if current then
			current = current:FindFirstChild(split[i])
		else
			return nil, "Path not found."
		end
	end

	if not current:IsA("ModuleScript") then
		return nil, "Path does not lead to a ModuleScript."
	end

	return require(current), ""
end

return Directory
