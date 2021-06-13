ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local madenci = false
local kazmaal = false

function goreveIptal()
    madenci = false
    exports['mythic_notify']:SendAlert('error', 'Madencilikten Ayrıldınız')
end

function goreveBasla()
    madenci = true 
    exports['mythic_notify']:SendAlert('success', 'Madenciliğe başladınız')
end

function malzemeler()

	local malzem = {
		{label = 'Kazma Al <span style="color:red;">'..Config.KazmaFiyat.. '$</span>', value = 'kazma'},
        {label = 'Kazmayı Geri Ver + <span style="color:green;">'..Config.KazmaFiyat.. '$</span>', value = 'kazmaver'}

	}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'KibraDevWorks', {
		title    = "Malzeme Al",
		align    = 'top-left',
		elements = malzem
	}, function(data, menu)
		if data.current.value == 'kazma' then
            kazmaSatinAl()
		end
        if data.current.value == 'kazmaver' then 
            kazmaGeriVer()
        end
	end, function(data, menu)
		menu.close()
	end)

end 

function kazmaSatinAl()
    TriggerServerEvent("kibra-maden:kazmaSatinAldim")
end

function kazmaGeriVer()
    TriggerServerEvent("kibra-maden:kazmageriVerdim")
end

function araciniyerim()
    if vehicle == nil then
        TriggerServerEvent('kibra-maden:AracAlo')
    else
        exports['mythic_notify']:SendAlert('error', 'Zaten aracınız var!')
    end
end


Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dst = GetDistanceBetweenCoords(playercoords, Config.MadenStart.x, Config.MadenStart.y, Config.MadenStart.z, true)
        if dst < 1 then
            sleep = 2
            if not madenci then
            DrawText3D(Config.MadenStart.x, Config.MadenStart.y, Config.MadenStart.z + 0.1, '~g~E~s~ - Madencilik Basla')
            DrawMarker(20, Config.MadenStart.x, Config.MadenStart.y, Config.MadenStart.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 1, nil, nil, false)
            else 
                DrawText3D(Config.MadenStart.x, Config.MadenStart.y, Config.MadenStart.z + 0.1, '~g~G~s~ - Meslek Ayrıl')
                DrawMarker(20, Config.MadenStart.x, Config.MadenStart.y, Config.MadenStart.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 1, nil, nil, false)
                if IsControlJustReleased(0, 47) then 
                    goreveIptal()
                end
            end
           if IsControlJustReleased(0, 38) then 
              goreveBasla()
           end
            end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dst3 = GetDistanceBetweenCoords(playercoords, Config.AracBlip.x, Config.AracBlip.y, Config.AracBlip.z, true)
        if dst3 < 3 then
            sleep = 2
           if not madenci then 
           else
            DrawText3D(Config.AracBlip.x, Config.AracBlip.y, Config.AracBlip.z + 0.1, '~g~E~s~ - Araç Çıkar '..Config.AracFiyat..'$')
            DrawMarker(39, Config.AracBlip.x, Config.AracBlip.y, Config.AracBlip.z + 0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.9, 0.9, 255, 255, 255, 100, false, true, 1, nil, nil, false)
            if IsControlJustReleased(0, 38) then   
                araciniyerim()          
            end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function aracialparamiver()
    if vehicle ~= nil then
            DeleteEntity(vehicle)
            DeleteVehicle(vehicle)
            ESX.Game.DeleteVehicle(vehicle)
            vehicle = nil
            exports['mythic_notify']:SendAlert('error', 'Aracınız Silindi')
            TriggerServerEvent('kibra-maden:verParamiAmk')
        else
            exports['mythic_notify']:SendAlert('error', 'Araca binip tekrar deneyiniz.')
        end
    
end

Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dst3 = GetDistanceBetweenCoords(playercoords, Config.AracSil.x, Config.AracSil.y, Config.AracSil.z, true)
        if dst3 < 3 then
            sleep = 2
           if not madenci then 
           else
            DrawText3D(Config.AracSil.x, Config.AracSil.y, Config.AracSil.z + 0.1, '~g~E~s~ - Aracı Geri Ver ')
            DrawMarker(39, Config.AracSil.x, Config.AracSil.y, Config.AracSil.z + 0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.9, 0.9, 255, 10, 255, 100, false, true, 1, nil, nil, false)
            if IsControlJustReleased(0, 38) then   
                aracialparamiver()         
            end
            end
        end
        Citizen.Wait(sleep)
    end
end)


RegisterNetEvent('kibra-maden:aracVerSerikrdsm')
AddEventHandler('kibra-maden:aracVerSerikrdsm', function ()
    if vehicle == nil then
        local modelHash = GetHashKey("Rebel")
        RequestModel(modelHash)
        local isLoaded = HasModelLoaded(modelHash)
        while isLoaded == false do
            Citizen.Wait(100)
        end
        vehicle = CreateVehicle(modelHash, Config.AracSpawn, 145.50, 1, 0)
        exports['mythic_notify']:SendAlert('success', 'Aracınız Oluşturuldu')
    else
        exports['mythic_notify']:SendAlert('error', 'Zaten aracınız var!')
    end
end)



Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dstDolap = GetDistanceBetweenCoords(playercoords, Config.MadenDolap.x, Config.MadenDolap.y, Config.MadenDolap.z, true)
        if dstDolap < 1 then
            sleep = 2
            if not madenci then 
            else 
            DrawText3D(Config.MadenDolap.x, Config.MadenDolap.y, Config.MadenDolap.z + 0.1, '~g~E~s~ - Madenci Dolabı')
            DrawMarker(20, Config.MadenDolap.x, Config.MadenDolap.y, Config.MadenDolap.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 255, 255, 100, false, true, 1, nil, nil, false)
          if  IsControlJustReleased(0, 38) then
            malzemeler()
          end
            end
            end
        Citizen.Wait(sleep)
    end
end)






Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dsttopla1 = GetDistanceBetweenCoords(playercoords, Config.TasTopla1.x, Config.TasTopla1.y, Config.TasTopla1.z, true)
        if dsttopla1 < 1 then
            sleep = 2
            if not madenci then 
            else 
            DrawText3D(Config.TasTopla1.x, Config.TasTopla1.y, Config.TasTopla1.z + 0.1, '~g~E~s~ - Tas Kaz')
            DrawMarker(20, Config.TasTopla1.x, Config.TasTopla1.y, Config.TasTopla1.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 1, nil, nil, false)
            if IsControlJustReleased(0, 38) then 
                TriggerServerEvent("kibra-maden:kazmaKontrol1")
            end
        end
            end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dsttopla2 = GetDistanceBetweenCoords(playercoords, Config.TasTopla2.x, Config.TasTopla2.y, Config.TasTopla2.z, true)
        if dsttopla2 < 1 then
            sleep = 2
            if not madenci then 
            else 
            DrawText3D(Config.TasTopla2.x, Config.TasTopla2.y, Config.TasTopla2.z + 0.1, '~g~E~s~ - Tas Kaz')
            DrawMarker(20, Config.TasTopla2.x, Config.TasTopla2.y, Config.TasTopla2.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 1, nil, nil, false)
            if IsControlJustReleased(0, 38) then 
                TriggerServerEvent("kibra-maden:kazmaKontrol1")
            end
        end
            end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dsttopla3 = GetDistanceBetweenCoords(playercoords, Config.TasTopla3.x, Config.TasTopla3.y, Config.TasTopla3.z, true)
        if dsttopla3 < 1 then
            sleep = 2
            if not madenci then 
            else 
            DrawText3D(Config.TasTopla3.x, Config.TasTopla3.y, Config.TasTopla3.z + 0.1, '~g~E~s~ - Tas Kaz')
            DrawMarker(20, Config.TasTopla3.x, Config.TasTopla3.y, Config.TasTopla3.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 1, nil, nil, false)
            if IsControlJustReleased(0, 38) then 
                TriggerServerEvent("kibra-maden:kazmaKontrol1")
            end
        end
            end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dsttopla5 = GetDistanceBetweenCoords(playercoords, Config.TasTopla5.x, Config.TasTopla5.y, Config.TasTopla5.z, true)
        if dsttopla5 < 1 then
            sleep = 2
            if not madenci then 
            else 
            DrawText3D(Config.TasTopla5.x, Config.TasTopla5.y, Config.TasTopla5.z + 0.1, '~g~E~s~ - Tas Kaz')
            DrawMarker(20, Config.TasTopla5.x, Config.TasTopla5.y, Config.TasTopla5.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 1, nil, nil, false)
            if IsControlJustReleased(0, 38) then 
                TriggerServerEvent("kibra-maden:kazmaKontrol1")
            end
        end
            end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dsttopla6 = GetDistanceBetweenCoords(playercoords, Config.TasTopla6.x, Config.TasTopla6.y, Config.TasTopla6.z, true)
        if dsttopla6 < 1 then
            sleep = 2
            if not madenci then 
            else 
            DrawText3D(Config.TasTopla6.x, Config.TasTopla6.y, Config.TasTopla6.z + 0.1, '~g~E~s~ - Tas Kaz')
            DrawMarker(20, Config.TasTopla6.x, Config.TasTopla6.y, Config.TasTopla6.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 1, nil, nil, false)
            if IsControlJustReleased(0, 38) then 
                TriggerServerEvent("kibra-maden:kazmaKontrol1")
            end
        end
            end
        Citizen.Wait(sleep)
    end
end)


Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dsttopla7 = GetDistanceBetweenCoords(playercoords, Config.TasTopla7.x, Config.TasTopla7.y, Config.TasTopla7.z, true)
        if dsttopla7 < 1 then
            sleep = 2
            if not madenci then 
            else 
            DrawText3D(Config.TasTopla7.x, Config.TasTopla7.y, Config.TasTopla7.z + 0.1, '~g~E~s~ - Tas Kaz')
            DrawMarker(20, Config.TasTopla7.x, Config.TasTopla7.y, Config.TasTopla7.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 1, nil, nil, false)
            if IsControlJustReleased(0, 38) then 
                TriggerServerEvent("kibra-maden:kazmaKontrol1")
            end
        end
            end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dsttopla8 = GetDistanceBetweenCoords(playercoords, Config.TasTopla8.x, Config.TasTopla8.y, Config.TasTopla8.z, true)
        if dsttopla8 < 1 then
            sleep = 2
            if not madenci then 
            else 
            DrawText3D(Config.TasTopla8.x, Config.TasTopla8.y, Config.TasTopla8.z + 0.1, '~g~E~s~ - Tas Kaz')
            DrawMarker(20, Config.TasTopla8.x, Config.TasTopla8.y, Config.TasTopla8.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 1, nil, nil, false)
            if IsControlJustReleased(0, 38) then 
                TriggerServerEvent("kibra-maden:kazmaKontrol1")
            end
        end
            end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dstDolap = GetDistanceBetweenCoords(playercoords, Config.MadenTasEritme.x, Config.MadenTasEritme.y, Config.MadenTasEritme.z, true)
        if dstDolap < 1 then
            sleep = 2
            if not madenci then 
            else 
            DrawText3D(Config.MadenTasEritme.x, Config.MadenTasEritme.y, Config.MadenTasEritme.z + 0.1, '~g~E~s~ - Tas Eritme')
            DrawMarker(20, Config.MadenTasEritme.x, Config.MadenTasEritme.y, Config.MadenTasEritme.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 100, false, true, 1, nil, nil, false)
          if  IsControlJustReleased(0, 38) then
            TriggerServerEvent("kibra-maden:tasKontrol1")
          end
            end
            end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dstDolap = GetDistanceBetweenCoords(playercoords, Config.ParaAl.x, Config.ParaAl.y, Config.ParaAl.z, true)
        if dstDolap < 1 then
            sleep = 2
            if not madenci then 
            else 
            DrawText3D(Config.ParaAl.x, Config.ParaAl.y, Config.ParaAl.z + 0.1, '~g~E~s~ - Eritilmis Tasları Ver')
            DrawMarker(20, Config.ParaAl.x, Config.ParaAl.y, Config.ParaAl.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 100, false, true, 1, nil, nil, false)
          if  IsControlJustReleased(0, 38) then
            TriggerServerEvent("kibra-maden:erittikleriniVerAlPara")
          end
            end
            end
        Citizen.Wait(sleep)
    end
end)

-- RegisterCommand("maden", function()
--     madenci = true
-- end)

RegisterNetEvent('kazmasivarserbest')
AddEventHandler('kazmasivarserbest', function()
    TriggerEvent("mythic_progbar:client:progress", {
        name = "kayakaz",
        duration = 10000,
        label = "kaya kazıyorsun",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "melee@large_wpn@streamed_core",
            anim = "ground_attack_on_spot",
            flags = 49,
        },
        prop = {
            model = "prop_tool_pickaxe",
            bone = 57005,
            coords = { x = 0.18, y = -0.02, z = -0.02 },
            rotation = { x = 100.0, y = 150.00, z = 140.0 },
        },
    }, function(status)
        if not status then
            TriggerServerEvent("kibra-maden:tasToplaQWE")
        end
    end)
end)

RegisterNetEvent('tasivar')
AddEventHandler('tasivar', function()
    TriggerEvent("mythic_progbar:client:progress", {
        name = "kayakaz",
        duration = 10000,
        label = "Taşları Eritiyorsun...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "amb@prop_human_bum_bin@idle_a",
            anim = "idle_a",
            flags = 49,
        },
    }, function(status)
        if not status then
            TriggerServerEvent("kibra-maden:tasErit")
        end
    end)
end)



Citizen.CreateThread(function()
    if not madenci then 
      local blip = AddBlipForCoord(Config.MadenToplaBlip)
      SetBlipSprite(blip, 178)
      SetBlipDisplay(blip, 4)
      SetBlipScale(blip, 0.6)
      SetBlipColour(blip, 1)
      SetBlipAsShortRange(blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("Taş Toplama")
      EndTextCommandSetBlipName(blip)
    end
    
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.MadenBlip)
    SetBlipSprite(blip, 178)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.6)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.MadenBlipName)
    EndTextCommandSetBlipName(blip)
  
end)



DrawText3D = function (x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end