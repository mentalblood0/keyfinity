local createModeScreen = {resourcesDir = "createModeScreen"}

modeParameters = {}
convertedModeParameters = {}

function addModeParameter(name, internalName, valueType, defaultValue)
    currentElements[#currentElements + 1] = gui:input(name, {}, currentElements[1], defaultValue)
    modeParameters[internalName] = {}
    modeParameters[internalName]["element"] = currentElements[#currentElements]
    modeParameters[internalName]["valueType"] = valueType
end

function convertParameters()
    convertedModeParameters = {}
    for parameterInternalName, parameter in pairs(modeParameters) do
        if parameter["valueType"] == "integer" then
            convertedModeParameters[parameterInternalName] = tonumber(parameter["element"].value)
            if convertedModeParameters[parameterInternalName] == nil then
                return false
            end
        elseif parameter["valueType" == "string"] then
            convertedModeParameters[parameterInternalName] = parameter["element"].value
        end
    end
    return true
end

function createModeButtonClick()
    local convertedSuccessfully = convertParameters()
    if not convertedSuccessfully then
        return
    end

    local modeName = currentElements[4].value

    if userProfiles[currentUserProfileName]["modes"] == nil then
        userProfiles[currentUserProfileName]["modes"] = {}
    end
    if userProfiles[currentUserProfileName]["modes"][modeName] == nil then
        userProfiles[currentUserProfileName]["modes"][modeName] = {}
    else
        return
    end

    for parameterName, parameterValue in pairs(convertedModeParameters) do
        userProfiles[currentUserProfileName]["modes"][modeName][parameterName] = parameterValue
    end

    IPL.store(userProfilesFileName, userProfiles)

    switchToState("selectModeScreen")
end

function createModeScreen:updateElementsPositionAndSize()
    local groupWidth = windowWidth / 1.5
    local groupHeight = windowHeight / 8 * 6
    currentElements[1].pos = {x=windowWidth / 6, y=windowHeight / 8, w=groupWidth, h=groupHeight}
    autostack:stackChildren(currentElements[1], nil, 0.1, 0.1, 0.5)
end

function createModeScreen:enter()
    modeParameters = {}
    convertedModeParameters = {}

    currentElements[1] = gui:group("New Mode", {}, nil)
    currentElements[1].style.bg = {0.4, 0.4, 0.4, 1}

    currentElements[4] = gui:input("Name:", {}, currentElements[1], "Sample Mode")

    addModeParameter("Text line length:", "textLineLength", "integer", 50)
    
    currentElements[6] = gui:button("Add", {}, currentElements[1])
    currentElements[6].click = function(this) createModeButtonClick() end

    currentElements[7] = gui:button("Cancel", {}, currentElements[1])
    currentElements[7].click = function(this) switchToState("selectModeScreen") end

    setElements()
end

function createModeScreen:draw()
    TLfres.beginRendering(windowWidth, windowHeight)
    gui:draw()
    TLfres.endRendering()
end
  
function createModeScreen:update(dt)
    gui:update(dt)
end

return createModeScreen