local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Directory = require(ReplicatedStorage.Directory)

local Event = Directory.Retrieve("Classes/Event")

local DataStoreInstance = {}
DataStoreInstance.__index = DataStoreInstance

export type DataStoreInstance = {
	DataKey: string,
	AutoSaveTask: thread?,
	Data: {[any]: any}
} & typeof(DataStoreInstance)

export type DataStoreParameters = {
	Name: string,
	AutoSaveInterval: number?,
	ShouldAutoSave: boolean?,
	DefaultData: {[any]: any}?
}

function DataStoreInstance.new(params: DataStoreParameters) : DataStoreInstance
	local self = setmetatable({}, DataStoreInstance)
	
	self.Name = params.Name
	self.Data = {}
	self.AutoSaveInterval = params.AutoSaveInterval or 0
	self.ShouldAutoSave = params.ShouldAutoSave or false

	self.DefaultData = params.DefaultData or {}

	self.Changed = Event.new()

	self.Loaded = false

	local Proxy = setmetatable({}, {	
		__newindex = function(tab, index, value)
			local privateValues = {
				"AutoSaveTask",
				"Changed",
			}

			if table.find(privateValues, index) then
				error("Tried to set the value of a private member variable. (" .. index .. ")")
				return
			end

			self[index] = value

			if tab.Changed then
				tab.Changed:Fire(index, value)
			end
		end,

		__index = function(tab, index)
			if index == "AutoSaveTask" then
				return nil
			end

			return self[index]
		end
	})
	self.AutoSaveTask = nil
	if self.ShouldAutoSave then
		self.AutoSaveTask = task.spawn(function()
			while self.ShouldAutoSave do
				if not self.Loaded then  
					task.wait()
					continue 
				end
				task.wait(self.AutoSaveInterval)
				for Key in pairs(self.Data) do
					self:Save(Key)
				end
			end
		end)
	end

	self.Changed:Connect(function(Index: any, Value: any)
		
		if Index == "ShouldAutoSave" and Value == true then
			if self.AutoSaveTask then
				task.cancel(self.AutoSaveTask)
			end
			self.AutoSaveTask = task.spawn(function()
				while self.ShouldAutoSave do
					if not self.Loaded then 
						task.wait()
						continue 
					end
					task.wait(self.AutoSaveInterval)
					for Key in pairs(self.Data) do
						self:Save(Key)
					end
				end
			end)
		end
	end)

	return Proxy
end

function getData(name: string, key: string) : DataStore?
	return DataStoreService:GetDataStore(name):GetAsync(key)
end

function setData(name: string, key: string, data: {[any]: any})
	DataStoreService:GetDataStore(name):SetAsync(key, data)
end

function updateData(name: string, key: string, callback: (data: {[any]: any}) -> ())
	DataStoreService:GetDataStore(name):UpdateAsync(key, callback)
end

function DataStoreInstance:Load(key: string) : ()
	local success, data
	
	local retries = 0

	local function load()
		success, data = pcall(getData, self.Name, key)

		if not success then 
			if retries > 3 then
				warn("[DataService] Critical Error while loading data from DataStore: " .. self.Name .. " with key: " .. key .. ": " .. data)

				return
			end

			task.delay(0, load)

			retries += 1
		end
	end

	load()

	if success and data then
		for Key, _ in pairs(data) do
			if self.DefaultData[Key] == nil then
				warn("[DataService] DataStore: " .. self.Name .. " with key: " .. key .. " contains data that doesn't exist in the default data table. Removing Key: " .. Key .. ", Value: ", data[Key])
				data[Key] = nil
			end
		end

		for Key, _ in pairs(self.DefaultData) do
			if data[Key] == nil then
				warn("[DataService] DataStore: " .. self.Name .. " with key: " .. key .. " is missing data that exists in the default data table. Creating Key: " .. Key .. ", Value: ", self.DefaultData[Key])
				data[Key] = self.DefaultData[Key]
			end
		end

		self.Data[key] = data

		print("[DataService] Loaded data from DataStore: " .. self.Name .. " with key: " .. key .. ". Data: ", data)
	else
		warn("[DataService] Data doesn't exist in DataStore: " .. self.Name .. " with key: " .. key .. ", creating new data.")
		self.Data[key] = self.DefaultData
	end

	self.Loaded = true

	return self.Data[key]
end

function DataStoreInstance:Save(key: string)
	if not key then 
		warn("[DataService] You cannot save without a key!") 
		return 
	end
	local data = self.Data[key]

	if not data then
		print(self.Name)
		warn("[DataService] Attempted to save data that doesn't exist in DataStore Instance: " .. self.Name .. " with key: " .. key)
		return
	end

	local success, err

	local retries = 0

	local function save()
		success, err = pcall(setData, self.Name, key, data)

		if not success then 
			if retries > 3 then
				warn("[DataService] Critical Error while saving data to DataStore: " .. self.Name .. " with key: " .. key .. ": " .. err)

				return
			end

			task.delay(0, save)

			retries += 1
		else
			print("[DataService] Saved data to DataStore: " .. self.Name .. " with key: " .. key.. ". Data: ", data)
		end
	end

	save()
end

function DataStoreInstance:Update(key: string, func: () -> ())
	local data = self.Data[key]

	if not data then
		warn("[DataService] Attempted to update data that doesn't exist in DataStore Instance: " .. self.Name .. " with key: " .. key)
		return
	end

	local success, err

	local retries = 0

	local function update()
		success, err = pcall(updateData, self.Name, key, func)

		if not success then 
			if retries > 3 then
				warn("[DataService] Critical Error while updating data in DataStore: " .. self.Name .. " with key: " .. key .. ": " .. err)

				return
			end

			task.delay(0, update)

			retries += 1
		else
			print("[DataService] Updated data in DataStore: " .. self.Name .. " with key: " .. key.. ". Data: ", data)
		end
	end

end

function DataStoreInstance:SetData(key: string, index: any, value: any)
	self.Data[key][index] = value
end

function DataStoreInstance:GetData(key: string)
	return self.Data[key]
end

function DataStoreInstance:UpdateData(key: string, index: any, func: (any) -> ())
	self.Data[key][index] = func(self.Data[key][index])
end



return DataStoreInstance