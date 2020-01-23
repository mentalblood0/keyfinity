local createUserScreen = {defaultFontFileName = "font.ttf"}

function createUserButtonClick()
    local userName = currentElements.nameInput:GetText()
    if userProfiles == nil then
        userProfiles = {}
    end
    if userProfiles[userName] == nil then
        userProfiles[userName] = {}
        IPL.store(userProfilesFileName, userProfiles)
    end

    switchToState("chooseUserProfileScreen")
end

function createUserScreen:updateElementsPositionAndSize()
    currentElements.newUserList:SetPos(windowWidth / 32, windowHeight / 32)
    currentElements.newUserList:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 30)
    currentElements.newUserList:SetPadding(windowWidth / 64)
    currentElements.newUserList:SetSpacing(windowHeight / 64)

    currentElements.newUserList:SetChildrenHeight(windowHeight / 10)
    currentElements.newUserList:SetEqualChildrenFontSize(createUserScreen.defaultFontFileName)
end

function createUserScreen:enter()
    currentElements.newUserList = gui.Create("list")

    currentElements.nameText = gui.Create("text")
    currentElements.nameText:SetText("User Name:")
    currentElements.newUserList:AddItem(currentElements.nameText)

    currentElements.nameInput = gui.Create("textinput")
    currentElements.newUserList:AddItem(currentElements.nameInput)
    
    currentElements.addButton = gui.Create("button")
    currentElements.addButton:SetText("Create")
    currentElements.addButton.OnClick = function(this) createUserButtonClick() end
    currentElements.newUserList:AddItem(currentElements.addButton)

    currentElements.cancelButton = gui.Create("button")
    currentElements.cancelButton:SetText("Cancel")
    currentElements.cancelButton.OnClick = function(this) switchToState("chooseUserProfileScreen") end
    currentElements.newUserList:AddItem(currentElements.cancelButton)
end

return createUserScreen