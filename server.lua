local SETTINGS = {}
local LISTENERS = {}
local DEFAULT_SETTINGS = {
    {"autocbug"},
    {"autoreload"},
    {"Crouch Bug", "crouchbug"},
    {"Fast Fire", "fastfire"},
    {"Fast Move", "fastmove"},
    {"Fast Sprint", "fastsprint"},
    {"Quick Fire", "quickfire"},
    {"Quick Reload", "quickreload"},
    {"Quick Stand", "quickstand"}
}

local AUTO_CBUG_WEAPONS = {
    [23] = true,
    [24] = true
}

local function GET_LISTENERS(tbl)
	local array = {}
	local indexID = 0

	for element, _ in pairs(tbl) do
		local validElement = isElement(element)

		if (validElement) then
			local newIndexID = (indexID + 1)

			array[indexID] = element
			indexID = newIndexID
		end
	end

	return array
end

local function SEND_SETTING(value, player)
    triggerClientEvent(player, "onClientSettingReceive", resourceRoot, value)
end

local function TOGGLE_AUTO_CBUG(value)
    local ANIM_BREAKOUT_TIME = "anim_breakout_time"
    local skills = {"poor", "std", "pro"}

    for weaponID, _ in pairs(AUTO_CBUG_WEAPONS) do
        local breakoutTime = value and 0 or getOriginalWeaponProperty(weaponID, "pro", ANIM_BREAKOUT_TIME)

        for _, skill in ipairs(skills) do
            setWeaponProperty(weaponID, skill, ANIM_BREAKOUT_TIME, breakoutTime)
        end
    end
end

local function SETTING_BOOLEANIZE(value)
    if type(value) == "boolean" then
        return value
    end

    if type(value) == "string" then
        return value == '[true]' or value == '["true"]' or value == 'true'
    end
end

local function SETTING_GET(setting)
    if not setting or type(setting) ~= "string" then
        return
    end

    return SETTINGS[setting]
end

local function SETTING_SET(setting, value)
    if not setting or type(setting) ~= "string" then
        return
    end
    local dot = setting:find("%.")

    if dot and type(dot) == "number" then
        setting = setting:sub(dot + 1)
    end

    local foundSetting

    for _, entry in ipairs(DEFAULT_SETTINGS) do
        if entry[1] == setting then
            foundSetting = entry
            break
        end
    end

    if not foundSetting then
        return
    end

    local glitch = foundSetting[2]
    
    value = SETTING_BOOLEANIZE(value)
    SETTINGS[setting] = value

    if setting == "autocbug" then
        TOGGLE_AUTO_CBUG(value)
        return
    end

    if glitch then
        setGlitchEnabled(glitch, value)
    end

    if setting == "autoreload" or setting == "Quick Reload" then
        setGlitchEnabled("quickreload", value)
        SEND_SETTING(value, GET_LISTENERS(LISTENERS))
        SETTINGS["autoreload"] = value
    end
end

addEventHandler("onPlayerResourceStart", root, function(startedResource)
    if startedResource ~= resource then
        return false
    end
    LISTENERS[source] = true
    local quickreload = get("Quick Reload")
    local autoreload = get("autoreload")
    local value = SETTING_BOOLEANIZE(quickreload) == true and SETTING_BOOLEANIZE(autoreload) == true
    triggerClientEvent(source, "onClientSettingReceive", resourceRoot, value)
end)

addEventHandler("onResourceStart", resourceRoot,
    function()
        for _, entry in ipairs(DEFAULT_SETTINGS) do
            local setting = entry[1]
            local value = get(setting)

            SETTING_SET(setting, value)
        end
    end
)

addEventHandler("onResourceStop", resourceRoot,
    function()
        for _, entry in ipairs(DEFAULT_SETTINGS) do
            local glitch = entry[2]
            if glitch then
                setGlitchEnabled(glitch, false)
            end
        end
    end
)

addEventHandler("onSettingChange", root,
    function(setting, _, value)
        SETTING_SET(setting, value)
    end
)