local glitches = {
    ["quickreload"] = true,
    ["fastmove"] = true,
    ["fastfire"] = true,
    ["crouchbug"] = true,
    ["fastsprint"] = true,
    ["quickstand"] = true,
}

addEventHandler("onResourceStart", resourceRoot, function()
    for glitch, isEnabled in pairs(glitches) do
        setGlitchEnabled(glitch, isEnabled)
    end
end)

addEventHandler("onResourceStop", resourceRoot, function()
    for glitch, isEnabled in pairs(glitches) do
        setGlitchEnabled(glitch, not isEnabled)
    end
end)