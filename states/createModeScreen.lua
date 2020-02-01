local createModeScreen = {defaultFontFileName = "font.otf"}

function createModeScreen:addButtonClick()
    local newModeName = currentElements.nameInput:GetText()
    if userProfiles[currentUserProfileName].modes == nil then
        userProfiles[currentUserProfileName].modes = {}
    end
    userProfiles[currentUserProfileName].modes[newModeName] = {}

    parameters:convertAndWriteToTable("mode", userProfiles[currentUserProfileName].modes[newModeName])

    save()

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
    parameters:newGroup("mode")

    currentElements.newModeParameters = gui.Create("tabs")
    currentElements.newModeParameters:SetPos(windowWidth / 32, windowHeight / 32)
    currentElements.newModeParameters:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 24)

    currentElements.basicParametersListTab = gui.Create("list")
    currentElements.newModeParameters:AddTab("Basic", currentElements.basicParametersListTab, "Basic mode parameters")

    parameters:addText(currentElements.basicParametersListTab, "Mode name")
    currentElements.nameInput = gui.Create("textinput")
    currentElements.basicParametersListTab:AddItem(currentElements.nameInput)

    currentElements.fontParametersListTab = gui.Create("list")
    currentElements.newModeParameters:AddTab("Font", currentElements.fontParametersListTab, "Font parameters")
    parameters:addIntegerNumberbox("mode", currentElements.fontParametersListTab, "Printed symbols maximum height", "printedSymbolsMaxHeight", 10, 1000, 1, 100)
    parameters:addIntegerNumberbox("mode", currentElements.fontParametersListTab, "Current symbol maximum height", "currentSymbolsMaxHeight", 10, 1000, 1, 100)
    parameters:addIntegerNumberbox("mode", currentElements.fontParametersListTab, "Unprinted symbols maximum height", "unprintedSymbolsMaxHeight", 10, 1000, 1, 100)
    parameters:addTextInput("mode", currentElements.fontParametersListTab, "Printed symbols font", "printedSymbolsFontFileName", "font.otf", "ttf")
    parameters:addTextInput("mode", currentElements.fontParametersListTab, "Current symbol font", "currentSymbolsFontFileName", "font.otf", "ttf")
    parameters:addTextInput("mode", currentElements.fontParametersListTab, "Unprinted symbols font", "unprintedSymbolsFontFileName", "font.otf", "ttf")
    parameters:addColorChanger("mode", currentElements.fontParametersListTab, "Printed symbols color", "printedSymbolsColor", {0.5, 0.5, 0.5, 1})
    parameters:addColorChanger("mode", currentElements.fontParametersListTab, "Current symbol color", "currentSymbolColor", {0.5, 0.5, 0.5, 1})
    parameters:addColorChanger("mode", currentElements.fontParametersListTab, "Unprinted symbols color", "unprintedSymbolsColor", {0.5, 0.5, 0.5, 1})

    currentElements.textParametersListTab = gui.Create("list")
    currentElements.newModeParameters:AddTab("Text", currentElements.textParametersListTab, "Text parameters")
    parameters:addIntegerNumberbox("mode", currentElements.textParametersListTab, "Text line length", "textLineLength", 1, 1000, 1)
    parameters:addMultichoice("mode", currentElements.textParametersListTab, "Content type", "contentType")
    parameters:addTextInput("mode", currentElements.textParametersListTab, "Allowed symbols", "allowedSymbols", textGenerator.englishLetters)
    parameters:addTextInput("mode", currentElements.textParametersListTab, "Text file name", "textFileName", "", "txt")
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
    for name, parameter in pairs(parameters.groups["mode"].raw) do
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