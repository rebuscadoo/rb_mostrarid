--###################--
--#### RBSYSTEM© ####--
--###################--

ESX = nil

local jugador = 2
local verIds = false
distaciaJugador = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand(
    "mostrarid",
    function(source, args) -- Mostrar la ID de los jugadores cercanos. (Modifica "mostrarid" al comando que mas te guste)
        verIds = true
        jugador = 2
        exports.pNotify:SendNotification({text = "Ahora se muestran las IDs", layout = "bottomCenter", type = "info", timeout = math.random(1000, 10000)}) -- Puedes modificar esta línea para implementar tu script de Notificaciónes.
    end,
    false
)

RegisterCommand(
    "ocultarid",
    function(source, args) -- Ocultar la ID de lo jugadores cercanos. (Modifica "ocultarid" al comando que mas te guste)
        verIds = false
        exports.pNotify:SendNotification({text = "Ahora no se muestran las IDs", layout = "bottomCenter", type = "info", timeout = math.random(1000, 10000)}) -- Puedes modificar esta línea para implementar tu script de Notificaciónes.
    end,
    false
)

Citizen.CreateThread(function()
    Wait(50)
    while true do
        if(verIds)then
            for id = 0, 255 do 
                if NetworkIsPlayerActive(id) then
                    if PlayerPedId(id) ~= PlayerPedId() then
                        if (distaciaJugador[id] ~= nil and distaciaJugador[id] < jugador) then
                            x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                            if NetworkIsPlayerTalking(id) then
                                DrawText3D(x2, y2, z2+1.2, GetPlayerServerId(id), 0,255,0)
                            else
                                DrawText3D(x2, y2, z2+1.2, GetPlayerServerId(id), 255,255,255)
                            end
                        end  
                    end
                end
            end
        end
        Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
    while true do
        if(verIds)then
            for id = 0, 255 do
                if PlayerPedId(id) ~= PlayerPedId() then
                    x1, y1, z1 = table.unpack(GetEntityCoords(PlayerPedId(), true))
                    x2, y2, z2 = table.unpack(GetEntityCoords(PlayerPedId(id), true))
                    distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                    distaciaJugador[id] = distance
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

function DrawText3D(x,y,z, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.60*scale)
        SetTextFont(0)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
