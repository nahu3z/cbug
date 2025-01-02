local isAutoReloadEnabled = false

-- Define a table containing the IDs of weapons that are allowed to use the auto-reload/recoil.
local AUTO_RELOAD_WEAPONS = {
    [23] = true, -- Silenced
    [24] = true, -- Desert Eagle
    [25] = true  -- Shotgun
    -- Add or remove weapon IDs as needed.
}

local currentSlot = getPedWeaponSlot(localPlayer)
local currentWeapon = getPedWeapon(localPlayer)

-- Event handler for auto-reload
addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weaponID)

	if AUTO_RELOAD_WEAPONS[weaponID] then
		setPedWeaponSlot(localPlayer, 0)
		setPedWeaponSlot(localPlayer, currentSlot)
	end
end)

-- Update the current weapon and slot
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function(prev, current)
	currentSlot = current
	currentWeapon = getPedWeapon(localPlayer, current)
end)

-- Key bind for a specific weapon (Sniper Rifle - ID 34)
bindKey("c", "down", function()
	-- Exit if auto-reload is not enabled.
	if not isAutoReloadEnabled then
		return false
	end

	-- Exit if the weapon is not 34.
	if currentWeapon ~= 34 then
		return false
	end

	-- Exit if the player is not walking.
	-- This prevents stopping aiming when crouching/standing up/rolling while aiming.
	if getPedMoveState(localPlayer) ~= "walk" then
		return false
	end

	setPedWeaponSlot(localPlayer, 0)
	setPedWeaponSlot(localPlayer, currentSlot)
end)

-- Event handler for the setting change
addEvent("onClientSettingChange", true)
addEventHandler("onClientSettingChange", root, function(value)
	-- Exit if the source is not the resource root.
	if source ~= resourceRoot then
		return false
	end

	isAutoReloadEnabled = value
end)