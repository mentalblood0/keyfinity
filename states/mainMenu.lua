local mainMenu = {resourcesDir = "mainMenu"}

function mainMenu:updateElementsPositionAndSize()
    local buttonsWidth = windowWidth/4
    local buttonsHeight = windowHeight/8

    local firstEntityPositionX = buttonsWidth/2
    local firstEntityPositionY = buttonsHeight
    for key,entity in ipairs(currentElements) do
        if entity.label == currentUserProfileName then
            break
        end
        entity.pos = {x=firstEntityPositionX, y=firstEntityPositionY + buttonsHeight*1.6*(key - 1), w=buttonsWidth, h=buttonsHeight}
    end

    currentElements[3].pos = {x=0, y=0, w=windowWidth, h=buttonsHeight/2}
end

function mainMenu:enter()
    currentElements[1] = gui:button("start")
    currentElements[1].click = function(this) switchToState("game") end

    currentElements[2] = gui:button("exit")
    currentElements[2].click = function(this) switchToState("chooseUserProfileScreen") end

    currentElements[3] = gui:button("Hello, " .. currentUserProfileName .. "!")

    currentElements[4] = gui:button("Select mode")
    currentElements[4].click = function(this) switchToState("selectModeScreen") end

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