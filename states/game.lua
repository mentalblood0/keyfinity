local game = {resourcesDir = "game"}

currentSymbolNumber = 1

function alignTextSymbolToCenter(text, symbolNumber, x, y)
    textLengthInPixels = text.style.font:getWidth(string.sub(text.label .. " ", 1, symbolNumber)) - text.style.font:getWidth(string.sub(text.label .. " ", symbolNumber, symbolNumber)) / 2
    textHeightInPixels = text.style.font:getHeight()
    text.pos.x = x - textLengthInPixels
    text.pos.y = y - textHeightInPixels / 2
end

function game:updateElementsPositionAndSize()
    local exitGameButtonSize = math.min(windowWidth, windowHeight) / 32
    currentElements.exitButton.pos = {x=0, y=0, w=exitGameButtonSize, h=exitGameButtonSize}

    currentElements.currentTextLine.pos = {w=windowWidth, h=windowHeight/16}
    currentElements.currentTextLine:updateFontSize()
    alignTextSymbolToCenter(currentElements.currentTextLine, currentSymbolNumber, windowWidth / 2, windowHeight / 2)

    if #currentElements.currentTextLine.label > 1 then
        currentElements.upperPointerHalf.pos = {x = windowWidth / 2 - 1, y = currentElements.currentTextLine.pos.y - currentElements.currentTextLine.pos.h / 2, w = 2, h = currentElements.currentTextLine.pos.h / 2}
        currentElements.lowerPointerHalf.pos = {x = windowWidth / 2 - 1, y = currentElements.currentTextLine.pos.y + currentElements.currentTextLine.pos.h, w = 2, h = currentElements.currentTextLine.pos.h / 2}
    end
end

function generateNewTextLine()
    currentElements.currentTextLine.label = textGenerator:randomSymbols(userProfiles[currentUserProfileName]["modes"][currentModeName]["textLineLength"])
    currentSymbolNumber = 1
end

function game:enter()
    currentElements.exitButton = gui:button("x")
    currentElements.exitButton.click = function(this) switchToState("mainMenu") end

    currentElements.currentTextLine = gui:text("", {}, nil)
    generateNewTextLine()

    if #currentElements.currentTextLine.label > 1 then
        currentElements.upperPointerHalf = gui:button("")
        currentElements.upperPointerHalf.style.default = {0.2, 0.6, 0.3, 1}
        currentElements.upperPointerHalf.style.hilite = {0.2, 0.6, 0.3, 1}
        currentElements.lowerPointerHalf = gui:button("")
        currentElements.lowerPointerHalf.style.default = {0.2, 0.6, 0.3, 1}
        currentElements.lowerPointerHalf.style.hilite = {0.2, 0.6, 0.3, 1}
    end

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
    if currentSymbolNumber <= #currentElements.currentTextLine.label then
        if text == getCharByIndex(currentElements.currentTextLine.label, currentSymbolNumber) then
            if (currentSymbolNumber == #currentElements.currentTextLine.label) and userProfiles[currentUserProfileName]["modes"][currentModeName]["enterAtTheEndOfTheLine"] == false then
                generateNewTextLine()
                alignTextSymbolToCenter(currentElements.currentTextLine, currentSymbolNumber, windowWidth / 2, windowHeight / 2)
                return
            end
            currentSymbolNumber = currentSymbolNumber + 1
            alignTextSymbolToCenter(currentElements.currentTextLine, currentSymbolNumber, windowWidth / 2, windowHeight / 2)
        end
    end
end

function game:keypressed(key, scancode, isrepeat)
    if key == "return" then
        if currentSymbolNumber > #currentElements.currentTextLine.label then
            generateNewTextLine()
            alignTextSymbolToCenter(currentElements.currentTextLine, currentSymbolNumber, windowWidth / 2, windowHeight / 2)
        end
    end
end

return game