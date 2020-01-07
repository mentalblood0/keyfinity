local createModeScreen = {resourcesDir = "createModeScreen"}

currentModeName = nil

function createModeButtonClick()
    print(currentUserProfileName, userProfiles[currentUserProfileName])
    local modeName = currentElements[4].value
    local textLineLength = tonumber(currentElements[5].value)

    if textLineLength == nil then
        return
    end

    if userProfiles[currentUserProfileName]["modes"] == nil then
        userProfiles[currentUserProfileName]["modes"] = {}
    end
    if userProfiles[currentUserProfileName]["modes"][modeName] == nil then
        userProfiles[currentUserProfileName]["modes"][modeName] = {}
    else
        return
    end
    userProfiles[currentUserProfileName]["modes"][modeName]["textLineLength"] = textLineLength
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
    currentElements[1] = gui:group("New Mode", {}, nil)
    currentElements[1].style.bg = {0.4, 0.4, 0.4, 1}

    currentElements[4] = gui:input("Name:", {}, currentElements[1], "Sample Mode")

    currentElements[5] = gui:input("Text line length:", {}, currentElements[1], "50")
    
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