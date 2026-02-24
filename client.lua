local isAutoReloadEnabled = false

local AUTO_RELOAD_WEAPONS = {
    [23] = true,
    [24] = true,
    [25] = true,
}

local validMoveState = {
	["walk"] = true,
	["fall"] = true,
}

local currentSlot = getPedWeaponSlot(localPlayer)
local currentWeapon = getPedWeapon(localPlayer)

addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weaponID)
	if isAutoReloadEnabled and AUTO_RELOAD_WEAPONS[weaponID] and not getPedOccupiedVehicle(localPlayer) then
		setPedWeaponSlot(localPlayer, 0)
		setPedWeaponSlot(localPlayer, currentSlot)
	end
end)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function(prev, current)
	currentSlot = current
	currentWeapon = getPedWeapon(localPlayer, current)
end)

bindKey("c", "down", function()
	if isAutoReloadEnabled and currentWeapon == 34 and validMoveState[getPedMoveState(localPlayer)] then
		setPedWeaponSlot(localPlayer, 0)
		setPedWeaponSlot(localPlayer, currentSlot)
	end
end)

addEvent("onClientSettingReceive", true)
addEventHandler("onClientSettingReceive", resourceRoot, function(value)
	isAutoReloadEnabled = value
end)
