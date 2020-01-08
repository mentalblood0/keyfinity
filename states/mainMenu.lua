local mainMenu = {resourcesDir = "mainMenu"}

function mainMenu:updateElementsPositionAndSize()
    local menuGroupWidth = windowWidth / 1.5
    local menuGroupHeight = windowHeight / 8 * 5
    currentElements.menuGroup.pos = {x = windowWidth / 6, y = windowHeight / 8, w = menuGroupWidth, h = menuGroupHeight}
    autostack:stackChildren(currentElements.menuGroup, nil, 0.1, 0.1, 0.5)
end

function mainMenu:enter()
    currentElements.menuGroup = gui:group("Hello, " .. currentUserProfileName .. "!", {}, 1 / 8)

    currentElements.startButton = gui:button("Start", {}, currentElements.menuGroup)
    currentElements.startButton.click = function(this) switchToState("game") end

    currentElements.selectModeButton = gui:button("Select mode", {}, currentElements.menuGroup)
    currentElements.selectModeButton.click = function(this) switchToState("selectModeScreen") end

    currentElements.exitButton = gui:button("Exit", {}, currentElements.menuGroup)
    currentElements.exitButton.click = function(this) switchToState("chooseUserProfileScreen") end

    setElements()
end

function mainMenu:draw()
    TLfres.beginRendering(windowWidth, windowHeight)
    gui:draw()
    TLfres.endRendering()
end

function mainMenu:update(dt)
    gui:update(dt)
end

return mainMenu