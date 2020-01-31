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
    currentElements.newModeParameters:setChildrenSize(windowWidth / 32 * 30, windowHeight / 32 * 24 - currentElements.newModeParameters:GetHeightOfButtons())
    currentElements.newModeParameters:setProperTabsFontSize(createModeScreen.defaultFontFileName)

    currentElements.newModeParameters:setChildrenPaddingSpacingEtc(windowWidth / 64, windowHeight / 64, windowHeight / 10, createModeScreen.defaultFontFileName)

    currentElements.addButton:SetPos(windowWidth / 32, windowHeight / 32 * 26)
    currentElements.addButton:SetSize(windowWidth / 32 * 14, windowHeight / 32 * 4)
    currentElements.addButton:setProperFontSize(createModeScreen.defaultFontFileName)

    currentElements.cancelButton:SetPos(windowWidth / 32 * 17, windowHeight / 32 * 26)
    currentElements.cancelButton:SetSize(windowWidth / 32 * 14, windowHeight / 32 * 4)
    currentElements.cancelButton:setProperFontSize(createModeScreen.defaultFontFileName)
end

function createModeScreen:enter()
    currentElements.newModeParameters = gui.Create("tabs")
    currentElements.newModeParameters:SetPos(windowWidth / 32, windowHeight / 32)
    currentElements.newModeParameters:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 24)

    currentElements.basicParametersListTab = gui.Create("list")
    currentElements.newModeParameters:AddTab("Basic", currentElements.basicParametersListTab, "Basic mode parameters")

    modeParameters:addText(currentElements.basicParametersListTab, "Mode name")
    currentElements.nameInput = gui.Create("textinput")
    currentElements.basicParametersListTab:AddItem(currentElements.nameInput)

    currentElements.fontParametersListTab = gui.Create("list")
    currentElements.newModeParameters:AddTab("Font", currentElements.fontParametersListTab, "Font parameters")
    modeParameters:addIntegerNumberbox(currentElements.fontParametersListTab, "Printed symbols maximum height", "printedSymbolsMaxHeight", 10, 1000, 1, 100)
    modeParameters:addIntegerNumberbox(currentElements.fontParametersListTab, "Current symbol maximum height", "currentSymbolsMaxHeight", 10, 1000, 1, 100)
    modeParameters:addIntegerNumberbox(currentElements.fontParametersListTab, "Unprinted symbols maximum height", "unprintedSymbolsMaxHeight", 10, 1000, 1, 100)
    modeParameters:addTextInput(currentElements.fontParametersListTab, "Printed symbols font", "printedSymbolsFontFileName", "font.ttf", "ttf")
    modeParameters:addTextInput(currentElements.fontParametersListTab, "Current symbol font", "currentSymbolsFontFileName", "font.ttf", "ttf")
    modeParameters:addTextInput(currentElements.fontParametersListTab, "Unprinted symbols font", "unprintedSymbolsFontFileName", "font.ttf", "ttf")
    modeParameters:addColorChanger(currentElements.fontParametersListTab, "Printed symbols color", "printedSymbolsColor", {0.5, 0.5, 0.5, 1})
    modeParameters:addColorChanger(currentElements.fontParametersListTab, "Current symbol color", "currentSymbolColor", {0.5, 0.5, 0.5, 1})
    modeParameters:addColorChanger(currentElements.fontParametersListTab, "Unprinted symbols color", "unprintedSymbolsColor", {0.5, 0.5, 0.5, 1})

    currentElements.textParametersListTab = gui.Create("list")
    currentElements.newModeParameters:AddTab("Text", currentElements.textParametersListTab, "Text parameters")
    modeParameters:addIntegerNumberbox(currentElements.textParametersListTab, "Text line length", "textLineLength", 1, 1000, 1)
    modeParameters:addMultichoice(currentElements.textParametersListTab, "Content type", "contentType")
    modeParameters:addTextInput(currentElements.textParametersListTab, "Allowed symbols", "allowedSymbols", textGenerator.englishLetters)
    modeParameters:addTextInput(currentElements.textParametersListTab, "Text file name", "textFileName", "", "txt")
    currentElements.contentTypeMultichoice:AddChoice("random characters from the set")
    currentElements.contentTypeMultichoice:AddChoice("text from the file")
    currentElements.contentTypeMultichoice:showElementOnChoice(currentElements.allowedSymbolsTextInput, "random characters from the set")
    currentElements.contentTypeMultichoice:hideElementOnChoice(currentElements.textFileNameTextInput, "random characters from the set")
    currentElements.contentTypeMultichoice:showElementOnChoice(currentElements.textFileNameTextInput, "text from the file")
    currentElements.contentTypeMultichoice:hideElementOnChoice(currentElements.allowedSymbolsTextInput, "text from the file")
    for choice, content in pairs(currentElements.contentTypeMultichoice.choices) do
        print(choice)
    end
    
    currentElements.addButton = gui.Create("button")
    currentElements.addButton:SetText("Create")
    currentElements.addButton.OnClick = function(this) createModeScreen:addButtonClick() end

    currentElements.cancelButton = gui.Create("button")
    currentElements.cancelButton:SetText("Cancel")
    currentElements.cancelButton.OnClick = function(this) switchToState("selectModeScreen") end
end

function createModeScreen:filedropped(file)
    for name, parameter in pairs(modeParameters.raw) do
        if parameter.valueType == "string" then
            if parameter.element:GetParent().visible then
                if mouseOnElement(parameter.element) then
                    if parameter.fileExtension then
                        if parameter.fileExtension == extensionOf(file) then
                            local fileName = createFileCopy(file)
                            parameter.element:SetText(fileName)
                        end
                    end
                end
            end
        end
    end
end

return createModeScreen