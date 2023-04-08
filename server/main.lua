local QBCore = exports['qb-core']:GetCoreObject()

-- Events

RegisterServerEvent('qb-goldpan:server:getItem', function(itemlist, itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemlist = itemlist
    local removed = false
    for k, v in pairs(itemlist) do
        if itemName == v.start then
            local amount = math.random(v.min, v.max)
            if Config.Inventory == "ox" then
                if exports.ox_inventory:CanCarryItem(source, v.name, amount) then
                    if v.remove then
                        Player.Functions.RemoveItem(v.remove, amount)
                        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.remove], "remove")
                    end
                    if v.threshold > math.random(0, 100) then
                        Player.Functions.AddItem(v.name, amount)
                        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.name], "add", amount)
                    end
                else
                    TriggerClientEvent('QBCore:Notify', src, Config.Locales['overweight_notify_error'], 'error')
                    return 
                end
            elseif Config.Inventory == "qb" then
                if v.remove then
                    Player.Functions.RemoveItem(v.remove, amount)
                    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.remove], "remove")
                end
                if v.threshold > math.random(0, 100) then
                    Player.Functions.AddItem(v.name, amount)
                    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.name], "add", amount)
                end
            end
        end
    end
end)

RegisterServerEvent('qb-goldpan:server:getGoldBar', function(itemlist, itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemlist = itemlist
    local removed = false
    local getOxItem = exports.ox_inventory:GetItem(src, 'rawgold', nil, true)
    for k, v in pairs(itemlist) do
        if itemName == v.start then
            local amount = math.random(v.min, v.max)
            if Config.Inventory == "ox" then
                if exports.ox_inventory:CanCarryItem(source, v.name, amount) then
                    if v.remove then
                        Player.Functions.RemoveItem(v.remove, Config.RawGold)
                        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.remove], "remove")
                    end
                    if v.threshold > math.random(0, 100) then
                        Player.Functions.AddItem(v.name, amount)
                        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.name], "add", amount)
                    end
                else
                    TriggerClientEvent('QBCore:Notify', src, Config.Locales['overweight_notify_error'], 'error')
                    return 
                end
            elseif Config.Inventory == "qb" then
                if v.remove then
                    Player.Functions.RemoveItem(v.remove, amount)
                    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.remove], "remove")
                end
                if v.threshold > math.random(0, 100) then
                    Player.Functions.AddItem(v.name, amount)
                    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.name], "add", amount)
                end
            end
        end
    end
end)


QBCore.Functions.CreateUseableItem(Config.BucketName, function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.BucketDecay and Config.Inventory == "ox" then
        TriggerClientEvent('qb-goldpan:client:startgravel', src, item.name)
        item.metadata.durability = item.metadata.durability -Config.BucketDecayAmount
        exports.ox_inventory:SetMetadata(source, item.slot, item.metadata)
        if item.metadata.durability <= 0 then 
            Wait(100)
            exports.ox_inventory:RemoveItem(src, Config.BucketName, 1)
            TriggerClientEvent('QBCore:Notify', src, Config.Locales['bucket_decay_notify_error'], 'error')
        end
    elseif Config.Inventory == "qb" or Config.Inventory == "lj" then
        TriggerClientEvent('qb-goldpan:client:startgravel', src, item.name)
    end
end)

QBCore.Functions.CreateUseableItem(Config.SifterName, function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if  Config.SifterDecay and Config.Inventory == "ox" then
        local getOxItem = exports.ox_inventory:GetItem(src, 'gravel', nil, true)
        if getOxItem > 0 then
            TriggerClientEvent('qb-goldpan:client:startwash', src, item.name)
            item.metadata.durability = item.metadata.durability -Config.SifterDecayAmount
            exports.ox_inventory:SetMetadata(source, item.slot, item.metadata)
            if item.metadata.durability <= 0 then 
                Wait(100)
                exports.ox_inventory:RemoveItem(src, Config.SifterName, 1)
                TriggerClientEvent('QBCore:Notify', src, Config.Locales['sifter_decay_notify_error'], 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Config.Locales['no_wash_notify_error'], 'error')
        end
    elseif Config.Inventory == "qb" or Config.Inventory == "lj" then
        local hasQBItem = Player.Functions.GetItemByName("gravel")
        if hasQBItem ~=nil then
            TriggerClientEvent('qb-goldpan:client:startwash', src, item.name)
        else
            TriggerClientEvent('QBCore:Notify', src, Config.Locales['no_wash_notify_error'], 'error')
        end
    end
end)

QBCore.Functions.CreateUseableItem(Config.MoldName, function(source, item)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.MoldDecay and Config.Inventory == "ox" then
        local getOxItem = exports.ox_inventory:GetItem(src, 'rawgold', nil, true)
        if getOxItem > 0 then
            TriggerClientEvent('qb-goldpan:client:startsmelt', src, item.name)
            item.metadata.durability = item.metadata.durability -Config.MoldDecayAmount
            exports.ox_inventory:SetMetadata(source, item.slot, item.metadata)
            if item.metadata.durability <= 0 then 
                Wait(100)
                exports.ox_inventory:RemoveItem(src, Config.MoldName, 1)
                TriggerClientEvent('QBCore:Notify', src, Config.Locales['mold_decay_notify_error'], 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Config.Locales['no_melt_notify_error'], 'error')
        end
    elseif Config.Inventory == "qb" or Config.Inventory == "lj" then
        local hasQBItem = Player.Functions.GetItemByName("rawgold")
        if hasQBItem ~=nil then
            TriggerClientEvent('qb-goldpan:client:startsmelt', src, item.name)
        else
            TriggerClientEvent('QBCore:Notify', src, Config.Locales['no_melt_notify_error'], 'error')
        end
    end
end)
