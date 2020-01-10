local createUserScreen = {resourcesDir = "createUserScreen"}

function createUserButtonClick()
    local userName = currentElements.nameInput.value
    if userProfiles[userName] == nil then
        userProfiles[userName] = {}
        IPL.store(userProfilesFileName, userProfiles)
    end

    switchToState("chooseUserProfileScreen")
end

function createUserScreen:enter()
    currentElements.newUserGroup = gui.Create("list")
    currentElements.newUserGroup:SetPos(windowWidth / 32, windowHeight / 32)
    currentElements.newUserGroup:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 30)

    currentElements.nameInput = gui.Create("textinput")
    currentElements.newUserGroup:AddItem(currentElements.nameInput)
    
    currentElements.addButton = gui.Create("button")
    currentElements.addButton:SetText("Create")
    currentElements.addButton.OnClick = function(this) createUserButtonClick() end
    currentElements.newUserGroup:AddItem(currentElements.addButton)

    currentElements.cancelButton = gui.Create("button")
    currentElements.cancelButton:SetText("Cancel")
    currentElements.cancelButton.OnClick = function(this) switchToState("chooseUserProfileScreen") end
    currentElements.newUserGroup:AddItem(currentElements.cancelButton)
end

return createUserScreen