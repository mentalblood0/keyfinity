local chooseUserProfileScreen = {resourcesDir = "chooseUserProfileScreen"}

userProfiles = {}
userProfilesFileName = "userProfiless.txt"
currentUserProfileName = nil

function loadSavedUserProfiles()
    info = love.filesystem.getInfo(userProfilesFileName)
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
    currentElements[1].pos = {x=windowWidth / 6, y=windowHeight / 8, w=scrollgroupWidth, h=scrollgroupHeight}

    currentElements[2].pos = {x=windowWidth / 6, y=windowHeight / 8 * 6 + scrollgroupHeight / 8, w=scrollgroupWidth, h=scrollgroupHeight / 8}

    autostack:stackChildren(currentElements[1], scrollgroupHeight / 8, 0.1, 0.1, 0.5)
end

function chooseUserProfileScreen:enter()
    currentElements[1] = gui:scrollgroup("Choose User", {}, 1 / 10, 1 / 8 / 2, {0.35, 0.3, 0.55, 1}, nil, "vertical")
    currentElements[1].style.bg = {0.2, 0.3, 0.5, 1}
    
    currentElements[2] = gui:button("Add user", {})
    currentElements[2].style.default = {0.2, 0.6, 0.3, 1}
    currentElements[2].style.hilite = {0.2, 0.7, 0.2}
    currentElements[2].click = function(this) switchToState("createUserScreen") end
    
    loadSavedUserProfiles()
    print(#userProfiles)
    currentElementNumber = 3
    for userName,userProfile in next,userProfiles,nil do
        currentElements[currentElementNumber] = gui:button(userName, {}, currentElements[1])
        currentElements[currentElementNumber].style.hilite = {0.65, 0.65, 0.2, 1}
        currentElements[currentElementNumber].style.focus = {0.75, 0.75, 0.2, 1}
        currentElements[currentElementNumber].click = function(this) currentUserProfileName = this.label; switchToState("mainMenu") end
        currentElementNumber = currentElementNumber + 1
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