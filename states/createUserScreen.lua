local createUserScreen = {resourcesDir = "createUserScreen"}

function createUserButtonClick()
    local userName = currentElements[4].value
    if userProfiles[userName] == nil then
        userProfiles[userName] = {}
        IPL.store(userProfilesFileName, userProfiles)
    end

    switchToState("chooseUserProfileScreen")
end

function createUserScreen:updateElementsPositionAndSize()
    local groupWidth = windowWidth / 1.5
    local groupHeight = windowHeight / 8 * 6
    currentElements[1].pos = {x=windowWidth / 6, y=windowHeight / 8, w=groupWidth, h=groupHeight}
    autostack:stackChildren(currentElements[1], nil, 0.1, 0.1, 0.5)
end

function createUserScreen:enter()
    currentElements[1] = gui:group("New User", {}, nil)
    currentElements[1].style.bg = {0.4, 0.4, 0.4, 1}

    currentElements[4] = gui:input("Name:", {}, currentElements[1], "Sample User")
    
    currentElements[5] = gui:button("Add", {}, currentElements[1])
    currentElements[5].click = function(this) createUserButtonClick() end

    currentElements[6] = gui:button("Cancel", {}, currentElements[1])
    currentElements[6].click = function(this) switchToState("chooseUserProfileScreen") end

    setElements()
end

function createUserScreen:draw()
    TLfres.beginRendering(windowWidth, windowHeight)
    gui:draw()
    TLfres.endRendering()
end
  
function createUserScreen:update(dt)
    gui:update(dt)
end

return createUserScreen