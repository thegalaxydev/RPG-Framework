local DataService = {}
local DataStoreInstance = require(script.DataStoreInstance)

type DataStoreInstance = DataStoreInstance.DataStoreInstance

local DataInstances = {}

function DataService:GetDataStoreInstance(name: string) : DataStoreInstance?
	for _, DataStore in ipairs(DataInstances) do
		if DataStore.Name == name then
			return DataStore
		end
	end

	return nil
end

function DataService:CreateDataStoreInstance(params: DataStoreInstance.DataStoreParameters) : DataStoreInstance
	local DataStore = DataStoreInstance.new(params)

	table.insert(DataInstances, DataStore)

	return DataStore
end

function DataService:RemoveDataStoreInstance(name: string) : boolean
	for index, DataStore in ipairs(DataInstances) do
		if DataStore.Name == name then
			table.remove(DataInstances, index)

			return true
		end
	end

	return false
end

return DataService