local selectModeScreen = {defaultFontFileName = "font.otf"}

function selectModeScreen:updateElementsPositionAndSize()
    currentElements.selectModeList:SetPos(windowWidth / 32, windowHeight / 32)
    currentElements.selectModeList:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 24)
    currentElements.selectModeList:SetPadding(windowWidth / 64)
    currentElements.selectModeList:SetSpacing(windowHeight / 64)

    currentElements.createModeButton:SetPos(windowWidth / 32, windowHeight / 32 * 26)
    currentElements.createModeButton:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 4)
    currentElements.createModeButton:setProperFontSize(selectModeScreen.defaultFontFileName)

    currentElements.selectModeList:SetChildrenHeight(windowHeight / 10)
    currentElements.selectModeList:SetEqualChildrenFontSize(selectModeScreen.defaultFontFileName)
end

function selectModeScreen:addModeButtons(modeName)
    local newButton = complexGui:Create("modeButtons", modeName)
    currentElements.selectModeList:AddItem(newButton)
    currentElements[modeName .. "ModeButton"] = newButton
end

function selectModeScreen:enter()
    currentElements.selectModeList = gui.Create("list")

    currentElements.createModeButton = gui.Create("button")
    currentElements.createModeButton:SetText("Create mode")
    currentElements.createModeButton.OnClick = function(this) editing = false switchToState("createModeScreen") end

    if not userProfiles[currentUserProfileName].modes then
        userProfiles[currentUserProfileName].modes = {}
    end
    for modeName, mode in next, userProfiles[currentUserProfileName].modes, nil do
        selectModeScreen:addModeButtons(modeName)
    end
end

return selectModeScreen