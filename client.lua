local isAutoReloadEnabled = false

local AUTO_RELOAD_WEAPONS = {
    [23] = true,
    [24] = true,
    [25] = true
}

local currentSlot = getPedWeaponSlot(localPlayer)
local currentWeapon = getPedWeapon(localPlayer)

addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weaponID)
	if not isAutoReloadEnabled then
		return false
	end

	if AUTO_RELOAD_WEAPONS[weaponID] then
		setPedWeaponSlot(localPlayer, 0)
		setPedWeaponSlot(localPlayer, currentSlot)
	end
end)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function(prev, current)
	currentSlot = current
	currentWeapon = getPedWeapon(localPlayer, current)
end)

bindKey("c", "down", function()
	if not isAutoReloadEnabled then
		return false
	end

	if currentWeapon ~= 34 then
		return false
	end

	if getPedMoveState(localPlayer) ~= "walk" then
		return false
	end

	setPedWeaponSlot(localPlayer, 0)
	setPedWeaponSlot(localPlayer, currentSlot)
end)

addEvent("onClientSettingChange", true)
addEventHandler("onClientSettingChange", root, function(value)
	if source ~= resourceRoot then
		return false
	end

	isAutoReloadEnabled = value
end)