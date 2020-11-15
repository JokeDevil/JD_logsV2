local serverip = ''
RegisterNetEvent("serverip")
AddEventHandler("serverip", function(ip)
    serverip = ip
end)

--Sending logs to https://logs.jokdevil.com/
function dashboardLogs(type,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15,m16,m17,m18,m19,m20,m21)
	PerformHttpRequest("https://logs.jokedevil.com/api/sendDiscord.php", function(err, text, headers) end,  'POST', 'type='..type..'&1='..m1..'&2='..m2..'&3='..m3..'&4='..m4..'&5='..m5..'&6='..m6..'&7='..m7..'&8='..m8..'&9='..m9..'&10='..m10..'&11='..m11..'&12='..m12..'&13='..m13..'&14='..m14..'&15='..m15..'&16='..m16..'&17='..m17..'&18='..m18..'&19='..m19..'&20='..serverip..'&21='..Config.Key..'&pid='..m20..'&pid2='..m21..'', { ["Content-Type"] = 'application/x-www-form-urlencoded' })
end

function shootingLogs(type,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15,m16,m17,m18,m19,m20,m21)
	PerformHttpRequest("https://logs.jokedevil.com/api/shooting.php", function(err, text, headers) end,  'POST', 'type='..type..'&1='..m1..'&2='..m2..'&3='..m3..'&4='..m4..'&5='..m5..'&6='..m6..'&7='..m7..'&8='..m8..'&9='..m9..'&10='..m10..'&11='..m11..'&12='..m12..'&13='..m13..'&14='..m14..'&15='..m15..'&16='..m16..'&17='..m17..'&18='..m18..'&19='..m19..'&20='..serverip..'&21='..Config.Key..'&pid='..m20..'&pid2='..m21..'', { ["Content-Type"] = 'application/x-www-form-urlencoded' })
end

RegisterNetEvent("clientExport")
AddEventHandler("clientExport", function(message, pid, pid2, type)
	if pid ~= 0 then
		ids = 		ExtractIdentifiers(pid)
		postal = 	getPlayerLocation(pid)
		name = 		GetPlayerName(pid)
		steam = 	ids.steam
		license = 	ids.license
		xbl = 		ids.xbl
		live = 		ids.live
		discord = 	ids.discord
		fivem = 	ids.fivem
		ip = 		ids.ip
	else
		steam = 	'0'
		license = 	'0'
		xbl = 		'0'
		live = 		'0'
		discord = 	'0'
		fivem = 	'0'
		ip = 		'0'
		postal = 	'0'
		name = 		'0'
	end
	if pid2 ~= 0 then
		ids2 = 		ExtractIdentifiers(pid2)
		postal2 = 	getPlayerLocation(pid2)
		name2 = 	GetPlayerName(pid2)
		steam2 = 	ids2.steam
		license2 = 	ids2.license
		xbl2 = 		ids2.xbl
		live2 = 	ids2.live
		discord2 = 	ids2.discord
		fivem2 = 	ids2.fivem
		ip2 = 		ids2.ip
	else
		steam2 = 	'0'
		license2 = 	'0'
		xbl2 = 		'0'
		live2 = 	'0'
		discord2 = 	'0'
		fivem2 = 	'0'
		ip2 = 		'0'
		postal2 = 	'0'
		name2 = 	'0'
	end
	dashboardLogs(type, steam, name, license, xbl, live, discord, fivem, ip, postal, message, steam2, name2, license2, xbl2, live2, discord2, fivem2, ip2, postal2, pid, pid2)
end)

exports('sendLogs', function(message, pid, pid2, type)
	TriggerEvent('clientExport', message, pid, pid2, type)
end)

-- Send message when Player connects to the server.
AddEventHandler("playerConnecting", function(name, setReason, deferrals)
	local ids = ExtractIdentifiers(source)
	dashboardLogs('connect',ids.steam, GetPlayerName(source), ids.license, ids.xbl, ids.live, ids.discord, ids.fivem, ids.ip, '0', 'Connected', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0')
end)

-- Send message when Player disconnects from the server
AddEventHandler('playerDropped', function(reason)
	local ids = ExtractIdentifiers(source)
	local postal = getPlayerLocation(source)
	dashboardLogs('disconnect',ids.steam, GetPlayerName(source), ids.license, ids.xbl, ids.live, ids.discord, ids.fivem, ids.ip, postal, 'left the server. (Reason: ' .. reason .. ')', '0', '0', '0', '0', '0', '0', '0', '0', '0', source, '0')
end)

-- Send message when Player creates a chat message (Does not show commands)
AddEventHandler('chatMessage', function(source, name, msg)
	local ids = ExtractIdentifiers(source)
	local postal = getPlayerLocation(source)
	dashboardLogs('chat',ids.steam, GetPlayerName(source), ids.license, ids.xbl, ids.live, ids.discord, ids.fivem, ids.ip, postal, '`'..msg..'`', '0', '0', '0', '0', '0', '0', '0', '0', '0', source, '0')
end)

-- Send message when Player died (including reason/killer check) (Not always working)
RegisterServerEvent('playerDied')
AddEventHandler('playerDied',function(id,player,killer,DeathReason,Weapon)
	local ids = ExtractIdentifiers(source)
	local postal = getPlayerLocation(source)
	if DeathReason then _DeathReason = "`"..DeathReason.."`" else _DeathReason = "`died`" end
	if Weapon then _Weapon = ""..Weapon.."" else _Weapon = "" end
	if id == 1 then  -- Suicide/died
		dashboardLogs('death',ids.steam, GetPlayerName(source), ids.license, ids.xbl, ids.live, ids.discord, ids.fivem, ids.ip, postal, '`'.._DeathReason..'`', '0', '0', '0', '0', '0', '0', '0', '0', '0', source, '0')
		return
	elseif id == 2 then -- Killed by other player
	local ids2 = ExtractIdentifiers(killer)
	local postal2 = getPlayerLocation(killer)
		dashboardLogs('death',ids.steam, GetPlayerName(source), ids.license, ids.xbl, ids.live, ids.discord, ids.fivem, ids.ip, postal, '`'.._DeathReason..'`', ids2.steam, GetPlayerName(killer), ids2.license, ids2.xbl, ids2.live, ids2.discord, ids2.fivem, ids2.ip, postal2, source, killer)
	else -- When gets killed by something else
		dashboardLogs('death',ids.steam, GetPlayerName(source), ids.license, ids.xbl, ids.live, ids.discord, ids.fivem, ids.ip, postal, '`Died`', '0', '0', '0', '0', '0', '0', '0', '0', '0', source, '0')
	end
end)

-- Send message when Player fires a weapon
RegisterServerEvent('playerShotWeapon')
AddEventHandler('playerShotWeapon', function(weapon)
	local ids = ExtractIdentifiers(source)
	local postal = getPlayerLocation(source)
	shootingLogs('shooting', ids.steam, GetPlayerName(source), ids.license, ids.xbl, ids.live, ids.discord, ids.fivem, ids.ip, postal, '`Fired a ' ..weapon..'`', '0', '0', '0', '0', '0', '0', '0', '0', '0', source, '0')
end)

-- Send message when a resource is being stopped
AddEventHandler('onResourceStop', function (resourceName)
	local resource = resourceName
	dashboardLogs('resource', '0', '0', '0', '0', '0', '0', '0', '0', '0', '`'..resource .. ' has been stopped`', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0')
end)

-- Send message when a resource is being started
AddEventHandler('onResourceStart', function (resourceName)
	Wait(500)
	local resource = resourceName
	dashboardLogs('resource', '0', '0', '0', '0', '0', '0', '0', '0', '0', '`'..resource .. ' has been started`', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0')
end)

RegisterServerEvent('JDlogs:GetIdentifiers')
AddEventHandler('JDlogs:GetIdentifiers', function(src)
	local ids = ExtractIdentifiers(src)
	return ids
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
		live = "",
		fivem = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        elseif string.find(id, "fivem") then
            identifiers.fivem = id
        end
    end

    return identifiers
end

function getPlayerLocation(src)

local raw = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
local postals = json.decode(raw)
local nearest = nil

local player = src
local ped = GetPlayerPed(player)
local playerCoords = GetEntityCoords(ped)

local x, y = table.unpack(playerCoords)

	local ndm = -1
	local ni = -1
	for i, p in ipairs(postals) do
		local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
		if ndm == -1 or dm < ndm then
			ni = i
			ndm = dm
		end
	end

	if ni ~= -1 then
		local nd = math.sqrt(ndm)
		nearest = {i = ni, d = nd}
	end
	_nearest = postals[nearest.i].code
	return _nearest
end