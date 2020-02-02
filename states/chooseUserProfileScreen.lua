local chooseUserProfileScreen = {defaultFontFileName = "font.otf"}

function chooseUserProfileScreen:updateElementsPositionAndSize()
    currentElements.chooseUserList:SetPos(windowWidth / 32, windowHeight / 32)
    currentElements.chooseUserList:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 24)
    currentElements.chooseUserList:SetPadding(windowWidth / 64)
    currentElements.chooseUserList:SetSpacing(windowHeight / 64)

    currentElements.addUserButton:SetPos(windowWidth / 32, windowHeight / 32 * 26)
    currentElements.addUserButton:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 4)
    currentElements.addUserButton:setProperFontSize(chooseUserProfileScreen.defaultFontFileName)

    currentElements.chooseUserList:SetChildrenHeight(windowHeight / 10)
    currentElements.chooseUserList:SetEqualChildrenFontSize(currentState.defaultFontFileName)
end

function chooseUserProfileScreen:addUserButtons(userName)
    local newButton = complexGui:Create("userButtons", userName)
    currentElements.chooseUserList:AddItem(newButton)
    currentElements[userName .. "UserButton"] = newButton
end

function chooseUserProfileScreen:enter()
    currentElements.chooseUserList = gui.Create("list")

    currentElements.addUserButton = gui.Create("button")
    currentElements.addUserButton:SetText("Add user")
    currentElements.addUserButton.OnClick = function(this) editing = false switchToState("createUserScreen") end

    for userName, userProfile in next, userProfiles, nil do
        chooseUserProfileScreen:addUserButtons(userName)
    end
end

return chooseUserProfileScreen