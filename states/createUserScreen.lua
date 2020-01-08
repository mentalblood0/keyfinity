local createUserScreen = {resourcesDir = "createUserScreen"}

function createUserButtonClick()
    local userName = currentElements.nameInput.value
    if userProfiles[userName] == nil then
        userProfiles[userName] = {}
        IPL.store(userProfilesFileName, userProfiles)
    end

    switchToState("chooseUserProfileScreen")
end

function createUserScreen:updateElementsPositionAndSize()
    local groupWidth = windowWidth / 1.5
    local groupHeight = windowHeight / 8 * 6
    currentElements.newUserGroup.pos = {x=windowWidth / 6, y=windowHeight / 8, w=groupWidth, h=groupHeight}
    autostack:stackChildren(currentElements.newUserGroup, nil, 0.1, 0.1, 0.5)
end

function createUserScreen:enter()
    currentElements.newUserGroup = gui:group("New User", {}, nil)
    currentElements.newUserGroup.style.bg = {0.4, 0.4, 0.4, 1}

    currentElements.nameInput = gui:input("Name:", {}, currentElements.newUserGroup, "Sample User")
    
    currentElements.addButton = gui:button("Add", {}, currentElements.newUserGroup)
    currentElements.addButton.click = function(this) createUserButtonClick() end

    currentElements.cancelButton = gui:button("Cancel", {}, currentElements.newUserGroup)
    currentElements.cancelButton.click = function(this) switchToState("chooseUserProfileScreen") end

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