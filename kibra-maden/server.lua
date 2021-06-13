ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("kibra-maden:kazmaSatinAldim")
AddEventHandler("kibra-maden:kazmaSatinAldim", function()
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.getQuantity('cash') >= Config.KazmaFiyat then
        if xPlayer.getQuantity('kazma') < 1 then
            xPlayer.removeMoney(Config.KazmaFiyat)
            xPlayer.addInventoryItem('kazma', 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Başarıyla bir kazma satın aldınız!'})

    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Zaten kazmanız var!'})
    end
else
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Paranız yok!'})
end
end)

RegisterServerEvent("kibra-maden:tasErit")
AddEventHandler("kibra-maden:tasErit", function()
    local x = ESX.GetPlayerFromId(source)
    if x.getQuantity('tas') >= 5 then
        x.removeInventoryItem('tas', 5)
        x.addInventoryItem('eritilmis', 5)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = '5 Tane taş erittiniz'})
    else 
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Yeterli Taşınız yok!'})
    end
end)

RegisterServerEvent("kibra-maden:erittikleriniVerAlPara")
AddEventHandler("kibra-maden:erittikleriniVerAlPara", function()
    local x = ESX.GetPlayerFromId(source)
    if x.getQuantity('eritilmis') >= 5 then
    x.removeInventoryItem('eritilmis', 5)
    x.addMoney(Config.Para)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = '5 Tane Eritilmiş Taş vererek '..Config.Para..'$ kazandınız!'})
    else 
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Yeterli Eritilmiş Taşınız yok!'})
    end
end)

RegisterNetEvent('kibra-maden:tasKontrol1')
AddEventHandler('kibra-maden:tasKontrol1', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer.getQuantity('tas') < 1 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Taşınız yok!', length = 2500})
    else 
        TriggerClientEvent('tasivar', source) 
	end	
end)
RegisterServerEvent("kibra-maden:kazmageriVerdim")
AddEventHandler("kibra-maden:kazmageriVerdim", function()
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
            xPlayer.removeInventoryItem('kazma', 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kazmanı geri verdin +500 $'})
end)

RegisterServerEvent('kibra-maden:AracAlo')
AddEventHandler('kibra-maden:AracAlo', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if Config.AracFiyat < xPlayer.getMoney() then
		xPlayer.removeMoney(Config.AracFiyat)
		TriggerClientEvent('kibra-maden:aracVerSerikrdsm', src)
	else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Paranız yok!'})
	end
end)

RegisterServerEvent('kibra-maden:verParamiAmk')
AddEventHandler('kibra-maden:verParamiAmk', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.addMoney(Config.AracFiyat)
end)

RegisterServerEvent("kibra-maden:tasToplaQWE")
AddEventHandler("kibra-maden:tasToplaQWE", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('tas', 1)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = '1 Tane Taş Elde ettiniz!'})
end)

RegisterNetEvent('kibra-maden:kazmaKontrol1')
AddEventHandler('kibra-maden:kazmaKontrol1', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer.getQuantity('kazma') < 1 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kazmanız yok!', length = 2500})
    else 
        TriggerClientEvent('kazmasivarserbest', source) 
	end	
end)
