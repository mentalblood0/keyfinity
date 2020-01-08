local chooseUserProfileScreen = {resourcesDir = "chooseUserProfileScreen"}

userProfiles = {}
userProfilesFileName = "userProfiless.txt"
currentUserProfileName = nil

function loadSavedUserProfiles()
    local info = love.filesystem.getInfo(userProfilesFileName)
    if info ~= nil then
        userProfiles = IPL.load(userProfilesFileName)
    else
        if userProfiles ~= {} then
            IPL.store(userProfilesFileName, userProfiles)
        end
    end
end

function chooseUserProfileScreen:updateElementsPositionAndSize()
    local scrollgroupWidth = windowWidth / 1.5
    local scrollgroupHeight = windowHeight / 8 * 5
    currentElements.chooseUserScrollgroup.pos = {x=windowWidth / 6, y=windowHeight / 8, w=scrollgroupWidth, h=scrollgroupHeight}

    currentElements.addUserButton.pos = {x=windowWidth / 6, y=windowHeight / 8 * 6 + scrollgroupHeight / 8, w=scrollgroupWidth, h=scrollgroupHeight / 8}

    autostack:stackChildren(currentElements.chooseUserScrollgroup, scrollgroupHeight / 8, 0.1, 0.1, 0.5)
end

function chooseUserProfileScreen:enter()
    currentElements.chooseUserScrollgroup = gui:scrollgroup("Choose User", {}, 1 / 10, 1 / 8 / 2, {0.35, 0.3, 0.55, 1}, nil, "vertical")
    currentElements.chooseUserScrollgroup.style.bg = {0.2, 0.3, 0.5, 1}
    
    currentElements.addUserButton = gui:button("Add user", {})
    currentElements.addUserButton.style.default = {0.2, 0.6, 0.3, 1}
    currentElements.addUserButton.style.hilite = {0.2, 0.7, 0.2}
    currentElements.addUserButton.click = function(this) switchToState("createUserScreen") end
    
    loadSavedUserProfiles()
    for userName,userProfile in next,userProfiles,nil do
        currentElements[userName .. "UserButton"] = gui:button(userName, {}, currentElements.chooseUserScrollgroup)
        currentElements[userName .. "UserButton"].style.hilite = {0.65, 0.65, 0.2, 1}
        currentElements[userName .. "UserButton"].style.focus = {0.75, 0.75, 0.2, 1}
        currentElements[userName .. "UserButton"].click = function(this) currentUserProfileName = this.label; switchToState("selectModeScreen") end
    end
    
    setElements()
end

function chooseUserProfileScreen:draw()
    TLfres.beginRendering(windowWidth, windowHeight)
    gui:draw()
    TLfres.endRendering()
end

function chooseUserProfileScreen:update(dt)
    gui:update(dt)
end

return chooseUserProfileScreen