local defaultSettings = {
    ["crouchbug"] = true,
    ["fastfire"] = true,
    ["fastmove"] = true,
    ["fastsprint"] = true,
    ["quickreload"] = true,
    ["quickstand"] = true,
}

addEventHandler("onResourceStart", resourceRoot, function()
    for glitch, isEnabled in pairs(defaultSettings) do
        setGlitchEnabled(glitch, isEnabled)
    end
end)

addEventHandler("onResourceStop", resourceRoot, function()
    for glitch, isEnabled in pairs(defaultSettings) do
        setGlitchEnabled(glitch, false)
    end
end)
