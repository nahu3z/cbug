-- Define a table containing the IDs of weapons that are allowed to use the auto-reload/recoil reset mechanic.
local autoReloadWeapon = {
    [23] = true, -- Silenced
    [24] = true, -- Desert Eagle
    [25] = true  -- Shotgun
    -- Add or remove weapon IDs as needed.
}

-- Event handler for when the local player fires a weapon.
-- This handler utilizes the 'quickreload' bug (by quickly switching weapon slots) to reset the reload/recoil of weapons listed in 'autoReloadWeapon'.
addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weaponID)
	if autoReloadWeapon[weaponID] then
		local currentSlot = getPedWeaponSlot(localPlayer)
		setPedWeaponSlot(localPlayer, 0)
		setPedWeaponSlot(localPlayer, currentSlot)
	end
end)

-- Key bind for a specific weapon (Sniper Rifle - ID 34) to reset its reload.
-- This utilizes the same 'quickreload' bug as the event handler but is triggered by pressing the 'C' key.
bindKey("c", "down", function()
	-- Exit if the player is not using a weapon.
	if getPedTask(localPlayer, "secondary", 0) ~= "TASK_SIMPLE_USE_GUN" then
		return false
	end

	-- Exit if the weapon is not 34.
	if getPedWeapon(localPlayer) ~= 34 then
		return false
	end

	-- Exit if the player is not walking.
	-- This prevents the player from stopping aiming when crouching/standing up/rolling while aiming.
	if getPedMoveState(localPlayer) ~= "walk" then
		return false
	end
	local currentSlot = getPedWeaponSlot(localPlayer)
	setPedWeaponSlot(localPlayer, 0)
	setPedWeaponSlot(localPlayer, currentSlot)
end)