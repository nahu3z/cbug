local defaultSettings = {
    ["crouchbug"] = true,
    ["fastfire"] = true,
    ["fastmove"] = true,
    ["fastsprint"] = true,
    ["quickstand"] = true
}

local AUTO_CBUG_WEAPONS = {
    [23] = true,
    [24] = true
}

local function sendSetting(value)
    if value == nil then
        value = get("autoreload")
    end
    triggerClientEvent(getElementsByType("player"), "onClientSettingChange", resourceRoot, value)
    setGlitchEnabled("quickreload", value)
end

local function toggleAutoCbug(value)
    for weaponID, _ in pairs(AUTO_CBUG_WEAPONS) do
        local time = value and 0 or getOriginalWeaponProperty(weaponID, "pro", "anim_breakout_time")
        for _, skill in ipairs({ "poor", "std", "pro" }) do
            setWeaponProperty(weaponID, skill, "anim_breakout_time", time)
        end
    end
end

addEventHandler("onResourceStart", resourceRoot, function()
    for glitch, isEnabled in pairs(defaultSettings) do
        setGlitchEnabled(glitch, isEnabled)
    end

    setTimer(sendSetting, 200, 1)

    toggleAutoCbug(get("autocbug"))
end)

addEventHandler("onResourceStop", resourceRoot, function()
    setGlitchEnabled("quickreload", false)
    for glitch, _ in pairs(defaultSettings) do
        setGlitchEnabled(glitch, false)
    end
end)

addEventHandler("onSettingChange", root, function(setting, _, value)
    -- Exit if the resource is not the same as this resource.
	local resourceSetting = setting:sub(2, 5)
    local resourceName = getResourceName(resource)
	if resourceSetting ~= resourceName then
		return false
	end

    value = fromJSON(value)
    setting = setting:gsub("*"..resourceName..".", "")

    if value == "true" then
        value = true
    elseif value == "false" then
        value = false
    end

    if setting == "autoreload" then
        sendSetting(value)
        return true
    end

    if setting == "autocbug" then
        toggleAutoCbug(value)
        return true
    end
end)
