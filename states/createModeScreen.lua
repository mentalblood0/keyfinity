local createModeScreen = {defaultFontFileName = "font.ttf"}

local modeParameters = require "modeParameters"

function createModeScreen:addButtonClick()
    local convertedSuccessfully = modeParameters:convert()
    if not convertedSuccessfully then
        return
    end

    local newModeName = currentElements.nameInput:GetText()
    if userProfiles[currentUserProfileName].modes == nil then
        userProfiles[currentUserProfileName].modes = {}
    end
    userProfiles[currentUserProfileName].modes[newModeName] = {}

    for parameterName, parameterValue in pairs(modeParameters.converted) do
        userProfiles[currentUserProfileName].modes[newModeName][parameterName] = parameterValue
    end

    IPL.store(userProfilesFileName, userProfiles)

    switchToState("selectModeScreen")
end

function createModeScreen:updateElementsPositionAndSize()
    currentElements.newModeParameters:SetPos(windowWidth / 32, windowHeight / 32)
    currentElements.newModeParameters:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 24)
    currentElements.newModeParameters:SetTabHeight(windowHeight / 16)
    currentElements.newModeParameters:setTabsWidth(windowWidth / 8)
    currentElements.newModeParameters:setProperTabsFontSize(createModeScreen.defaultFontFileName)

    currentElements.basicParametersListTab:SetPadding(windowWidth / 64)
    currentElements.basicParametersListTab:SetSpacing(windowHeight / 64)
    currentElements.basicParametersListTab:SetChildrenHeight(windowHeight / 10)
    currentElements.basicParametersListTab:SetEqualChildrenFontSize(createModeScreen.defaultFontFileName)

    currentElements.fontParametersListTab:SetPadding(windowWidth / 64)
    currentElements.fontParametersListTab:SetSpacing(windowHeight / 64)
    currentElements.fontParametersListTab:SetChildrenHeight(windowHeight / 10)
    currentElements.fontParametersListTab:SetEqualChildrenFontSize(createModeScreen.defaultFontFileName)

    currentElements.addButton:SetPos(windowWidth / 32, windowHeight / 32 * 26)
    currentElements.addButton:SetSize(windowWidth / 32 * 14, windowHeight / 32 * 4)
    currentElements.addButton:SetProperFontSize(createModeScreen.defaultFontFileName)

    currentElements.cancelButton:SetPos(windowWidth / 32 * 17, windowHeight / 32 * 26)
    currentElements.cancelButton:SetSize(windowWidth / 32 * 14, windowHeight / 32 * 4)
    currentElements.cancelButton:SetProperFontSize(createModeScreen.defaultFontFileName)
end

function createModeScreen:enter()
    currentElements.newModeParameters = gui.Create("tabs")
    currentElements.newModeParameters:SetPos(windowWidth / 32, windowHeight / 32)
    currentElements.newModeParameters:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 24)

    currentElements.basicParametersListTab = gui.Create("list")
    currentElements.newModeParameters:AddTab("Basic", currentElements.basicParametersListTab, "Basic mode parameters")

    currentElements.nameText = gui.Create("text")
    currentElements.nameText:SetText("Mode Name:")
    currentElements.basicParametersListTab:AddItem(currentElements.nameText)

    currentElements.nameInput = gui.Create("textinput")
    currentElements.basicParametersListTab:AddItem(currentElements.nameInput)

    currentElements.fontParametersListTab = gui.Create("list")
    currentElements.newModeParameters:AddTab("Font", currentElements.fontParametersListTab, "Font parameters")

    modeParameters:addIntegerNumberbox(currentElements.fontParametersListTab, "Maximum text height", "maxTextHeight", 10, 1000, 1, 100)
    
    currentElements.addButton = gui.Create("button")
    currentElements.addButton:SetText("Create")
    currentElements.addButton.OnClick = function(this) createModeScreen:addButtonClick() end

    currentElements.cancelButton = gui.Create("button")
    currentElements.cancelButton:SetText("Cancel")
    currentElements.cancelButton.OnClick = function(this) switchToState("selectModeScreen") end
end

return createModeScreen