local createModeScreen = {resourcesDir = "createModeScreen"}

modeParameters = {}
convertedModeParameters = {}

function addModeParameter(parentElement, name, internalName, valueType, defaultValue)
    if valueType == "boolean" then
        currentElements[internalName .. "Checkbox"] = gui:checkbox(name, {}, parentElement, defaultValue)
    else
        currentElements[internalName .. "Input"] = gui:input(name, {}, parentElement, defaultValue)
    end

    modeParameters[internalName] = {}
    modeParameters[internalName].element = currentElements[#currentElements]
    modeParameters[internalName].valueType = valueType
end

function convertParameters()
    convertedModeParameters = {}
    for parameterInternalName, parameter in pairs(modeParameters) do
        if parameter.valueType == "integer" then
            convertedModeParameters[parameterInternalName] = tonumber(parameter.element.value)
            if convertedModeParameters[parameterInternalName] == nil then
                return false
            end
        elseif parameter.valueType == "string" then
            convertedModeParameters[parameterInternalName] = parameter.element.value
        elseif parameter.valueType == "boolean" then
            convertedModeParameters[parameterInternalName] = parameter.element.value
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

    if userProfiles[currentUserProfileName].modes == nil then
        userProfiles[currentUserProfileName].modes = {}
    end
    if userProfiles[currentUserProfileName].modes[modeName] == nil then
        userProfiles[currentUserProfileName].modes[modeName] = {}
    else
        return
    end

    for parameterName, parameterValue in pairs(convertedModeParameters) do
        userProfiles[currentUserProfileName].modes[modeName][parameterName] = parameterValue
    end

    IPL.store(userProfilesFileName, userProfiles)

    switchToState("selectModeScreen")
end

function createModeScreen:updateElementsPositionAndSize()
    currentElements.modeNameInput.pos = {x = windowWidth / 32, y = windowHeight / 32, w = windowWidth - windowWidth / 32 * 2, h = windowHeight / 32}

    local groupWidth = windowWidth / 3.5
    local groupHeight = windowHeight / 8 * 6
    currentElements.appearanceParametersScrollgroup.pos = {x = windowWidth / 32, y = windowHeight / 8 / 1.5, w = groupWidth, h = groupHeight}
    autostack:stackChildren(currentElements.appearanceParametersScrollgroup, nil, 1 / 32, 1 / 32, 0.5)

    currentElements.addModeButton.pos = {x = windowWidth - windowWidth / 32 - windowWidth / 4 * 1.5, y = windowHeight / 16 * 14, w = windowWidth / 4 * 1.5, h = windowHeight / 16 * 1.5}
    currentElements.cancelCreatingModeButton.pos = {x = windowWidth / 32, y = windowHeight / 16 * 14, w = windowWidth / 4 * 1.5, h = windowHeight / 16 * 1.5}
end

function createModeScreen:enter()
    modeParameters = {}
    convertedModeParameters = {}

    currentElements.modeNameInput = gui:input("Name:", {}, nil, "Sample Mode")

    currentElements.addModeButton = gui:button("Add", {})
    currentElements.addModeButton.click = function(this) createModeButtonClick() end

    currentElements.cancelCreatingModeButton = gui:button("Cancel", {})
    currentElements.cancelCreatingModeButton.click = function(this) switchToState("selectModeScreen") end

    currentElements.appearanceParametersScrollgroup = gui:scrollgroup("Appearance parameters", {}, 1 / 10, 1 / 8 / 2, {0.35, 0.3, 0.55, 1}, nil, "vertical")
    currentElements.appearanceParametersScrollgroup.style.bg = {0.4, 0.4, 0.4, 1}

    addModeParameter(currentElements.appearanceParametersScrollgroup, "Text line length:", "textLineLength", "integer", 50)
    addModeParameter(currentElements.appearanceParametersScrollgroup, "Press Enter at the end of the line", "enterAtTheEndOfTheLine", "boolean", true)

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