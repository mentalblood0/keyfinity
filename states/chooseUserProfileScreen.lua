local chooseUserProfileScreen = {defaultFontFileName = "font.ttf"}

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

function chooseUserProfileScreen:enter()
    currentElements.chooseUserList = gui.Create("list")

    currentElements.addUserButton = gui.Create("button")
    currentElements.addUserButton:SetText("Add user")
    currentElements.addUserButton.OnClick = function(this) switchToState("createUserScreen") end

    for userName, userProfile in next, userProfiles, nil do
        local newButton = gui.Create("button")
        newButton:SetHeight(100)
        newButton:SetText(userName)
        newButton.OnClick = function(this) currentUserProfileName = this.text; switchToState("selectModeScreen") end

        currentElements.chooseUserList:AddItem(newButton)
    end
end

return chooseUserProfileScreen