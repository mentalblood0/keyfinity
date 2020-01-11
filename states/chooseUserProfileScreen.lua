local chooseUserProfileScreen = {resourcesDir = "chooseUserProfileScreen"}

function chooseUserProfileScreen:updateElementsPositionAndSize()
    currentElements.chooseUserScrollgroup:SetPos(windowWidth / 32, windowHeight / 32)
    currentElements.chooseUserScrollgroup:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 24)
    currentElements.chooseUserScrollgroup:SetPadding(windowWidth / 64)
    currentElements.chooseUserScrollgroup:SetSpacing(windowHeight / 64)

    currentElements.addUserButton:SetPos(windowWidth / 32, windowHeight / 32 * 26)
    currentElements.addUserButton:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 4)
    currentElements.addUserButton:SetProperFontSize("font.ttf")

    local userButtons = currentElements.chooseUserScrollgroup:GetChildren()
    for key, userButton in next, userButtons, nil do
        userButton:SetHeight(windowHeight / 10)
    end
    currentElements.chooseUserScrollgroup:SetEqualChildrenFontSize("font.ttf")
end

function chooseUserProfileScreen:enter()
    currentElements.chooseUserScrollgroup = gui.Create("list")

    currentElements.addUserButton = gui.Create("button")
    currentElements.addUserButton:SetText("Add user")
    currentElements.addUserButton.OnClick = function(this) switchToState("createUserScreen") end

    loadSavedUserProfiles()
    for userName,userProfile in next, userProfiles, nil do
        local newButton = gui.Create("button")
        newButton:SetHeight(100)
        newButton:SetText(userName)
        newButton.OnClick = function(this) currentUserProfileName = this.label; switchToState("selectModeScreen") end

        currentElements.chooseUserScrollgroup:AddItem(newButton)
    end
end

return chooseUserProfileScreen