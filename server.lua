local SETTINGS = {}
local LISTENERS = {}
local GLITCH_MAP = {
    ["Auto C-Bug"] = "autocbug",
    ["Auto Reload"] = "autoreload",
    ["Crouch Bug"] = "crouchbug",
    ["Fast Fire"] = "fastfire",
    ["Fast Move"] = "fastmove",
    ["Fast Sprint"] = "fastsprint",
    ["High Close Range Damage"] = "highcloserangedamage",
    ["Hit Anim"] = "hitanim",
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

local function settingToBoolean(value)
    if type(value) == "boolean" then
        return value
    end
    local s = tostring(value):lower()
    return BOOLEANS[s] or false
end

local function sendClientSetting(target, value)
    triggerClientEvent(target, "onClientSettingReceive", resourceRoot, value)
end

local function broadcastSetting(value)
    for player in pairs(LISTENERS) do
        if isElement(player) then
            sendClientSetting(player, value)
        end
    end
end

local function toggleAutoCBug(value)
    local ANIM_BREAKOUT_TIME = "anim_breakout_time"
    local breakout = value and 0 or false
    local skills = {"poor", "std", "pro"}

    for _, skill in ipairs(skills) do
        for weaponID in pairs(AUTO_CBUG_WEAPONS) do
            local breakoutTime = breakout or getOriginalWeaponProperty(weaponID, skill, ANIM_BREAKOUT_TIME)
            setWeaponProperty(weaponID, skill, ANIM_BREAKOUT_TIME, breakoutTime)
        end
    end
end

local function setSetting(setting, value)
    if not setting or type(setting) ~= "string" then
        return false
    end

    local foundSetting = GLITCH_MAP[setting:match("([^%.]+)$")]
    if not foundSetting then
        return false
    end

    value = settingToBoolean(value)
    SETTINGS[foundSetting] = value

    if foundSetting == "autocbug" then
        toggleAutoCBug(value)
    elseif foundSetting == "autoreload" then
        broadcastSetting(value)
        if value then
            setGlitchEnabled("quickreload", true)
        end
    elseif foundSetting == "quickreload" then
        setGlitchEnabled(foundSetting, value)
        if SETTINGS["autoreload"] then
            broadcastSetting(value)
        end
    else
        setGlitchEnabled(foundSetting, value)
    end
end

addEventHandler("onPlayerResourceStart", root, function(res)
    if res == resource then
        local value = SETTINGS["quickreload"] and SETTINGS["autoreload"] or false
        sendClientSetting(source, value)
        LISTENERS[source] = true
    end
end)

addEventHandler("onResourceStart", resourceRoot, function()
    for setting in pairs(GLITCH_MAP) do
        setSetting(setting, get(setting))
    end
end)

addEventHandler("onPlayerQuit", root, function()
    LISTENERS[source] = nil
end)

addEventHandler("onResourceStop", resourceRoot, function()
    for setting, glitch in pairs(GLITCH_MAP) do
        setGlitchEnabled(glitch, false)
    end
end)

addEventHandler("onSettingChange", resourceRoot, function(setting, _, value)
    setSetting(setting, value)
end)
