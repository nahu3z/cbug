local SETTINGS = {}
local LISTENERS = {}
local DEFAULT_SETTINGS = {
    ["Auto C-Bug"] = "autocbug",
    ["Auto Reload"] = "autoreload",
    ["Crouch Bug"] = "crouchbug",
    ["Fast Fire"] = "fastfire",
    ["Fast Move"] = "fastmove",
    ["Fast Sprint"] = "fastsprint",
    ["Quick Fire"] = "quickfire",
    ["Quick Reload"] = "quickreload",
    ["Quick Stand"] = "quickstand",
}

local AUTO_CBUG_WEAPONS = {
    [23] = true,
    [24] = true,
}

local BOOLEANS = {
    ['["true"]'] = true,
    ['[true]'] = true,
    ['true'] = true,
}

local function GET_LISTENERS(tbl)
	local array = {}
	local indexID = 0

	for element, _ in pairs(tbl) do
		local newIndexID = (indexID + 1)

        array[newIndexID] = element
		indexID = newIndexID
	end

	return array
end

local function SEND_SETTING(value, player)
    triggerClientEvent(player, "onClientSettingReceive", resourceRoot, value)
end

local function TOGGLE_AUTO_CBUG(value)
    local ANIM_BREAKOUT_TIME = "anim_breakout_time"
    local skills = {"poor", "std", "pro"}

    for _, skill in ipairs(skills) do
        for weaponID, _ in pairs(AUTO_CBUG_WEAPONS) do
            local breakoutTime = value and 0 or getOriginalWeaponProperty(weaponID, skill, ANIM_BREAKOUT_TIME)
            setWeaponProperty(weaponID, skill, ANIM_BREAKOUT_TIME, breakoutTime)
        end
    end
end

local function SETTING_BOOLEANIZE(value)
    if type(value) == "boolean" then
        return value
    end

    if type(value) == "string" then
        return BOOLEANS[value] or false
    end
end

local function SETTING_SET(setting, value)
    if not setting or type(setting) ~= "string" then
        return false
    end

    local dot = setting:find("%.")
    if dot then
        setting = setting:sub(dot + 1)
    end

    local foundSetting = DEFAULT_SETTINGS[setting]

    value = SETTING_BOOLEANIZE(value)
    SETTINGS[foundSetting] = value

    if foundSetting == "autocbug" then
        TOGGLE_AUTO_CBUG(value)
        return true
    end

    local handle = false
    if foundSetting == "autoreload" then
        if value then
            setGlitchEnabled("quickreload", true)
        end
        SEND_SETTING(value, GET_LISTENERS(LISTENERS))
        handle = true
    elseif foundSetting == "quickreload" then
        if SETTINGS["autoreload"] then
            SEND_SETTING(value, GET_LISTENERS(LISTENERS))
        end
        setGlitchEnabled(foundSetting, value)
        handle = true
    end

    if not handle then
        setGlitchEnabled(foundSetting, value)
    end
end

addEventHandler("onPlayerResourceStart", root, function(startedResource)
    if startedResource ~= resource then
        return false
    end
    LISTENERS[source] = true
    local value = SETTINGS["quickreload"] and SETTINGS["autoreload"]
    triggerClientEvent(source, "onClientSettingReceive", resourceRoot, value)
end)

addEventHandler("onResourceStart", resourceRoot, function()
    for setting, glitch in pairs(DEFAULT_SETTINGS) do
        local value = get(setting)
        SETTING_SET(setting, value)
    end
end)

addEventHandler("onPlayerQuit", root, function()
    LISTENERS[source] = nil
end)

addEventHandler("onResourceStop", resourceRoot, function()
    for setting, glitch in pairs(DEFAULT_SETTINGS) do
        setGlitchEnabled(glitch, false)
    end
end)

addEventHandler("onSettingChange", resourceRoot, function(setting, _, value)
    SETTING_SET(setting, value)
end)