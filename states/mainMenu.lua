local mainMenu = {defaultFontFileName = "font.ttf"}

function mainMenu:updateElementsPositionAndSize()
    currentElements.mainMenuList:SetPos(windowWidth / 32, windowHeight / 32)
    currentElements.mainMenuList:SetSize(windowWidth / 32 * 30, windowHeight / 32 * 24)
    currentElements.mainMenuList:SetPadding(windowWidth / 64)
    currentElements.mainMenuList:SetSpacing(windowHeight / 64)

    currentElements.mainMenuList:SetChildrenHeight(windowHeight / 10)
    currentElements.mainMenuList:SetEqualChildrenFontSize(mainMenu.defaultFontFileName)
end

function mainMenu:enter()
    currentElements.mainMenuList = gui.Create("list")

    currentElements.startButton = gui.Create("button")
    currentElements.startButton:SetHeight(100)
    currentElements.startButton:SetText("Start")
    currentElements.startButton.OnClick = function(this) switchToState("game") end
    currentElements.mainMenuList:AddItem(currentElements.startButton)

    currentElements.selectModeButton = gui.Create("button")
    currentElements.selectModeButton:SetHeight(100)
    currentElements.selectModeButton:SetText("Select mode")
    currentElements.selectModeButton.OnClick = function(this) switchToState("selectModeScreen") end
    currentElements.mainMenuList:AddItem(currentElements.selectModeButton)
end

return mainMenu