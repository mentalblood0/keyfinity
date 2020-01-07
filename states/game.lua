local game = {resourcesDir = "game"}

currentTextLine = ""
currentSymbolNumber = 1

function alignTextSymbolToCenter(text, symbolNumber, x, y)
    textLengthInPixels = text.style.font:getWidth(string.sub(text.label .. " ", 1, symbolNumber)) - text.style.font:getWidth(string.sub(text.label .. " ", symbolNumber, symbolNumber)) / 2
    textHeightInPixels = text.style.font:getHeight()
    text.pos.x = x - textLengthInPixels
    text.pos.y = y - textHeightInPixels / 2
end

function game:updateElementsPositionAndSize()
    local exitGameButtonSize = math.min(windowWidth, windowHeight) / 32
    currentElements[1].pos = {x=0, y=0, w=exitGameButtonSize, h=exitGameButtonSize}

    currentElements[2].pos = {w=windowWidth, h=windowHeight/16}
    currentElements[2]:updateFontSize()
    alignTextSymbolToCenter(currentElements[2], currentSymbolNumber, windowWidth / 2, windowHeight / 2)

    currentElements[3].pos = {x = windowWidth / 2 - 1, y = currentElements[2].pos.y - currentElements[2].pos.h / 2, w = 2, h = currentElements[2].pos.h / 2}
    currentElements[4].pos = {x = windowWidth / 2 - 1, y = currentElements[2].pos.y + currentElements[2].pos.h, w = 2, h = currentElements[2].pos.h / 2}
end

function game:enter()
    print("user:", currentUserProfileName, "mode:", currentModeName)
    currentTextLine = textGenerator:randomSymbols(userProfiles[currentUserProfileName]["modes"][currentModeName]["textLineLength"])
    currentSymbolNumber = 1

    currentElements[1] = gui:button("x")
    currentElements[1].click = function(this) switchToState("mainMenu") end

    currentElements[2] = gui:text(currentTextLine, {}, nil)

    currentElements[3] = gui:button("")
    currentElements[3].style.default = {0.2, 0.6, 0.3, 1}
    currentElements[3].style.hilite = {0.2, 0.6, 0.3, 1}
    currentElements[4] = gui:button("")
    currentElements[4].style.default = {0.2, 0.6, 0.3, 1}
    currentElements[4].style.hilite = {0.2, 0.6, 0.3, 1}

    setElements()
end

function game:draw()
    TLfres.beginRendering(windowWidth, windowHeight)
    gui:draw()
    TLfres.endRendering()
end

function game:update(dt)
    gui:update(dt)
end

function game:textInput(text)
    if currentSymbolNumber <= #currentTextLine then
        if text == getCharByIndex(currentTextLine, currentSymbolNumber) then
            currentSymbolNumber = currentSymbolNumber + 1
            alignTextSymbolToCenter(currentElements[2], currentSymbolNumber, windowWidth / 2, windowHeight / 2)
        end
    end
end

function game:keypressed(key, scancode, isrepeat)
    if key == "return" then
        if currentSymbolNumber > #currentTextLine then
            currentTextLine = textGenerator:randomSymbols(userProfiles[currentUserProfileName]["modes"][currentModeName]["textLineLength"])
            currentSymbolNumber = 1
            currentElements[2].label = currentTextLine
            alignTextSymbolToCenter(currentElements[2], currentSymbolNumber, windowWidth / 2, windowHeight / 2)
        end
    end
end

return game