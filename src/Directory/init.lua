local Directory = {}

Directory.Cache = {}

function Directory.GetClass<T>() : T?
	return nil
end

function Directory.Retrieve(path: string) : ({}? | Instance, string)
	local split = string.split(path, "/")
	local current = script
	for i = 1, #split do
		if current then
			current = current:FindFirstChild(split[i])
		else
			return nil, "Path not found."
		end
	end

	if not current then return nil, "Path not found." end

	if current:IsA("ModuleScript") then
		return require(current), "Module retrieved."
	end

	return current, "Directory retrieved."
end

function Directory.GetExternalDependency(path: string)
	local dependency = script.Parent.ExternalDependencies:FindFirstChild(path)

	if dependency then
		local module = require(dependency)

		return module :: typeof(module), "External dependency retrieved."
	end

	return nil, "External dependency not found."
end

return Directory
