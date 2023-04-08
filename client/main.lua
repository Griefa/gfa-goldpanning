-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local inGoldArea = false
local inWashingArea = false
local inSmeltingArea = false
local currentspot = nil
local previousspot = nil
local GoldLocations = {}
local WashingLocations = {}
local SmeltingLocations = {}
local Blips = {}
local mineWait = false

-- Functions

local function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
       return tostring(o)
    end
end

local function loadModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
        RequestModel(model)
    end
    return model
end

local function loadDict(dict, anim)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
        RequestAnimDict(dict)
    end
    return dict
end

local function helpText(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function addBlip(coords, sprite, colour, scale, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

local function CreateBlips() -- Create mining blips
	for k, v in pairs(Config.Blips) do
        Blips[k] = AddBlipForCoord(v.blippoint)
        SetBlipSprite(Blips[k], v.blipsprite)
        SetBlipDisplay(Blips[k], 4)
        SetBlipScale(Blips[k], v.blipscale)
        SetBlipAsShortRange(Blips[k], true)
        SetBlipColour(Blips[k], v.blipcolour)
        SetBlipAlpha(Blips[k], 0.7)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(Blips[k])
    end
end

local function IsInWater()
    local startedCheck = GetGameTimer()

    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)

    local forwardVector = GetEntityForwardVector(ped)
    local forwardPos = vector3(pedPos["x"] + forwardVector["x"] * 10, pedPos["y"] + forwardVector["y"] * 10, pedPos["z"])

    local fishHash = `a_c_fish`

    loadModel(fishHash)

    local waterHeight = GetWaterHeight(forwardPos["x"], forwardPos["y"], forwardPos["z"])

    local fishHandle = CreatePed(1, fishHash, forwardPos, 0.0, false)
    
    SetEntityAlpha(fishHandle, 0, true) -- makes the fish invisible.

    QBCore.Functions.Notify("Checking washing location...", "success", "3000")

    while GetGameTimer() - startedCheck < 3000 do
        Citizen.Wait(0)
    end

    RemoveLoadingPrompt()

    local fishInWater = IsEntityInWater(fishHandle)

    DeleteEntity(fishHandle)

    SetModelAsNoLongerNeeded(fishHash)

    return fishInWater or false
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() -- Event when player has successfully loaded
    TriggerEvent('qb-goldpan:client:DestroyZones') -- Destroy all zones
	TriggerEvent('qb-goldpan:client:DestroyPeds') -- Destroy all peds
	Wait(100)
	TriggerEvent('qb-goldpan:client:UpdateGoldZones') -- Reload mining information
	Wait(100)
	TriggerEvent('qb-goldpan:client:UpdateWashingZones') -- Reload washing information
	Wait(100)
	TriggerEvent('qb-goldpan:client:UpdateSmeltingZones') -- Reload smelting information
	Wait(100)
	CreateBlips() --Reload blips
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() -- Reset all variables
	TriggerEvent('qb-goldpan:client:DestroyZones') -- Destroy all zones
	inGoldArea = false
    currentspot = nil
    previousspot = nil
    GoldLocations = {}
    WashingLocations = {}
    SmeltingLocations = {}
	Blips = {}
	Peds = {}
end)

AddEventHandler('onResourceStart', function(resource) -- Event when resource is reloaded
    if resource == GetCurrentResourceName() then -- Reload player information
		TriggerEvent('qb-goldpan:client:DestroyZones') -- Destroy all zones
		TriggerEvent('qb-goldpan:client:DestroyPeds') -- Destroy all peds
		Wait(100)
		TriggerEvent('qb-goldpan:client:UpdateGoldZones') -- Reload mining information
		Wait(100)
		TriggerEvent('qb-goldpan:client:UpdateWashingZones') -- Reload washing information
		Wait(100)
		TriggerEvent('qb-goldpan:client:UpdateSmeltingZones') -- Reload smelting information
		Wait(100)
		CreateBlips()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then -- Reload player information
		TriggerEvent('qb-goldpan:client:DestroyZones') -- Destroy all zones
		TriggerEvent('qb-goldpan:client:DestroyPeds') -- Destroy all peds
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) --Events when players change jobs
	TriggerEvent('qb-goldpan:client:DestroyZones') -- Destroy all zones
	TriggerEvent('qb-goldpan:client:DestroyPeds') -- Destroy all peds
	Wait(100)
	TriggerEvent('qb-goldpan:client:UpdateGoldZones') -- Reload mining information
	Wait(100)
	TriggerEvent('qb-goldpan:client:UpdateWashingZones') -- Reload washing information
	Wait(100)
	TriggerEvent('qb-goldpan:client:UpdateSmeltingZones') -- Reload smelting information
	Wait(100)
	CreateBlips() --Reload blips
end)

RegisterNetEvent('qb-goldpan:client:UpdateGoldZones', function() -- Update Mining Zones
    for k, v in pairs(Config.Gold) do
        GoldLocations[k] = PolyZone:Create(v.zones, {
            name='GoldStation '..k,
            minZ = 	v.minz,
            maxZ = v.maxz,
            debugPoly = Config.ZoneDebug
        })
    end
end)

RegisterNetEvent('qb-goldpan:client:UpdateWashingZones', function() -- Update Washing Zones
    for k, v in pairs(Config.Washing) do
        WashingLocations[k] = PolyZone:Create(v.zones, {
            name='WashingStation '..k,
            minZ = 	v.minz,
            maxZ = v.maxz,
            debugPoly = Config.ZoneDebug
        })
    end
end)

RegisterNetEvent('qb-goldpan:client:UpdateSmeltingZones', function() -- Update Smelting Zones
    for k, v in pairs(Config.Smelting) do
        SmeltingLocations[k] = PolyZone:Create(v.zones, {
            name='SmeltingStation '..k,
            minZ = 	v.minz,
            maxZ = v.maxz,
            debugPoly = Config.ZoneDebug
        })
    end
end)

RegisterNetEvent('qb-goldpan:client:DestroyZones', function() -- Destroy all zones
    if MiningLocations then
		for k, v in pairs(GoldLocations) do
			GoldLocations[k]:destroy()
		end
	end
    if WashingLocations then
		for k, v in pairs(WashingLocations) do
			WashingLocations[k]:destroy()
		end
	end
    if SmeltingLocations then
		for k, v in pairs(SmeltingLocations) do
			SmeltingLocations[k]:destroy()
		end
	end
	GoldLocations = {}
    WashingLocations = {}
    SmeltingLocations = {}
end)

RegisterNetEvent('qb-goldpan:client:startgravel', function(itemName)
	print(itemName)-- Start mining (itemName coming through)
	local item = itemName
	if not itemName then return end -- if the item doesn't match the name coming through or doesn't exist, cancel event.
	local Ped = PlayerPedId()
	local coord = GetEntityCoords(Ped)
	for k, v in pairs(GoldLocations) do
		if GoldLocations[k] then
			if GoldLocations[k]:isPointInside(coord) then
				QBCore.Functions.Progressbar("startmine", Config.Locales['gravel_progress'], Config.BucketDuration, false, false, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					}, {
						animDict = "amb@world_human_bum_wash@male@high@base", 
						anim = "base", 
						flags = 8,
					}, {}, {}, function() -- Done
					Wait(1000)
					ClearPedTasks(Ped)
					TriggerServerEvent('qb-goldpan:server:getItem', Config.GoldItems, itemName) -- we send table and the itemName aka bucket.
				end)
			end
		end
	end
end)

RegisterNetEvent('qb-goldpan:client:startwash', function(itemName) -- Start washing
	local item = itemName
	if not itemName then return end
	local Ped = PlayerPedId()
	local coord = GetEntityCoords(Ped)
	for k, v in pairs(WashingLocations) do
		if WashingLocations[k]:isPointInside(coord) then
			if IsPedSwimming(PlayerPedId()) then
				QBCore.Functions.Notify(Config.Locales['swimming_notify_error'], "error")
			else
				local waterValidated = IsInWater()
				if waterValidated then
					QBCore.Functions.Progressbar("startwash", Config.Locales['washing_progress'], Config.SifterDuration, false, false, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {
						animDict = "amb@world_human_bum_wash@male@high@base", 
						anim = "base", 
						flags = 8,
					}, {}, {}, function() -- Done
						StopAnimTask(Ped, "amb@world_human_bum_wash@male@high@base", "startwash", 1.0)
						ClearPedTasks(Ped)
						TriggerServerEvent('qb-goldpan:server:getItem', Config.WashingItems, itemName)
					end)
				else
					QBCore.Functions.Notify(Config.Locales['shallow_water_notify_error'], "error")
				end
			end
		else
			QBCore.Functions.Notify(Config.Locales['water_purity_notify_error'], 'error')
		end
	end	
end)

RegisterNetEvent('qb-goldpan:client:startsmelt', function(itemName) -- Start Smelting
	local item = itemName
	if not itemName then return end
	local Ped = PlayerPedId()
	local coord = GetEntityCoords(Ped)
	local amount = exports.ox_inventory:Search('count', 'rawgold')
	if Config.Inventory == "ox" then
		if amount >= Config.RawGoldAmount then
			for k, v in pairs(SmeltingLocations) do
				if SmeltingLocations[k] then 
					if SmeltingLocations[k]:isPointInside(coord) then
						QBCore.Functions.Progressbar("startsmelt", Config.Locales['mold_progress'], Config.MoldDuration, false, false, {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}, {
							animDict = "mp_arresting", 
							anim = "a_uncuff", 
							flags = 8,
						}, {}, {}, function() -- Done
							StopAnimTask(Ped, "mp_arresting", "startsmelt", 1.0)
							ClearPedTasks(Ped)
							TriggerServerEvent('qb-goldpan:server:getGoldBar', Config.SmeltingItems, itemName)
						end)
					end
				end
			end
		else
			QBCore.Functions.Notify(Config.Locales['not_enough_melt_notify_error'], 'error')
		end
	elseif Config.Inventory == "qb" or Config.Inventory == "lj" then
		for k, v in pairs(SmeltingLocations) do
			if SmeltingLocations[k] then 
				if SmeltingLocations[k]:isPointInside(coord) then
					QBCore.Functions.Progressbar("startsmelt", Config.Locales['mold_progress'], Config.MoldDuration, false, false, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {
						animDict = "mp_arresting", 
						anim = "a_uncuff", 
						flags = 8,
					}, {}, {}, function() -- Done
						StopAnimTask(Ped, "mp_arresting", "startsmelt", 1.0)
						ClearPedTasks(Ped)
						TriggerServerEvent('qb-goldpan:server:getGoldBar', Config.SmeltingItems, itemName)
					end)
				end
			end
		end
	end
end)
