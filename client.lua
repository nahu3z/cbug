local isAutoReloadEnabled = false

local AUTO_RELOAD_WEAPONS = {
    [23] = true,
    [24] = true,
    [25] = true,
}

local currentSlot = getPedWeaponSlot(localPlayer)
local currentWeapon = getPedWeapon(localPlayer)

addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weaponID)
	if isAutoReloadEnabled and AUTO_RELOAD_WEAPONS[weaponID] then
		setPedWeaponSlot(localPlayer, 0)
		setPedWeaponSlot(localPlayer, currentSlot)
	end
end)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function(prev, current)
	currentSlot = current
	currentWeapon = getPedWeapon(localPlayer, current)
end)

bindKey("c", "down", function()
	if not isAutoReloadEnabled or currentWeapon ~= 34 or getPedMoveState(localPlayer) ~= "walk" then
		return false
	end

	setPedWeaponSlot(localPlayer, 0)
	setPedWeaponSlot(localPlayer, currentSlot)
end)

addEvent("onClientSettingReceive", true)
addEventHandler("onClientSettingReceive", resourceRoot, function(value)
	isAutoReloadEnabled = value
end)