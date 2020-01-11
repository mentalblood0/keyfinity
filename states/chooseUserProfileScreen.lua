local chooseUserProfileScreen = {resourcesDir = "chooseUserProfileScreen"}

function chooseUserProfileScreen:enter()
    currentElements.chooseUserScrollgroup = gui.Create("list")
    currentElements.chooseUserScrollgroup:SetPos(windowWidth / 32, windowHeight / 32)
    currentElements.chooseUserScrollgroup:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 24)
    currentElements.chooseUserScrollgroup:SetPadding(10)
    currentElements.chooseUserScrollgroup:SetSpacing(10)

    currentElements.addUserButton = gui.Create("button")
    currentElements.addUserButton:SetPos(windowWidth / 32, windowHeight / 32 * 26)
    currentElements.addUserButton:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 4)
    currentElements.addUserButton:SetText("Add user")
    currentElements.addUserButton:SetProperFontSize("font.ttf")
    currentElements.addUserButton.OnClick = function(this) switchToState("createUserScreen") end

    loadSavedUserProfiles()
    for userName,userProfile in next,userProfiles,nil do
        local newButton = gui.Create("button")
        newButton:SetHeight(100)
        newButton:SetText(userName)
        newButton:SetFont(love.graphics.newFont(40))
        newButton:SetProperFontSize("font.ttf")
        newButton.OnClick = function(this) currentUserProfileName = this.label; switchToState("selectModeScreen") end

        currentElements.chooseUserScrollgroup:AddItem(newButton)
    end
end

return chooseUserProfileScreen