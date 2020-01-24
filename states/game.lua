local game = {defaultFontFileName = "font.ttf"}

local currentSymbolIndex = nil
local textToTypeLength = nil

function getParameter(parameterName)
    return userProfiles[currentUserProfileName].modes[currentModeName][parameterName]
end

function generateNewText()
    textToTypeLength = 16
    currentElements.textToType:SetText(textGenerator:randomSymbols(textToTypeLength))
    currentSymbolIndex = 1
end

function alignTextSymbolToCenter(element, symbolNumber, x, y)
    local text = element:GetText()
    textLengthInPixels = element.font:getWidth(string.sub(text .. " ", 1, symbolNumber)) - element.font:getWidth(string.sub(text .. " ", symbolNumber, symbolNumber)) / 2
    textHeightInPixels = element.font:getHeight()
    element:SetPos(x - textLengthInPixels, y - textHeightInPixels / 2)
end

function refreshTextAlignment()
    alignTextSymbolToCenter(currentElements.textToType, currentSymbolIndex, windowWidth / 2, windowHeight / 2)
end

function game:updateElementsPositionAndSize()
    currentElements.exitButton:SetPos(0, 0)
    currentElements.exitButton:SetSize(windowWidth / 64, windowWidth / 64)
    currentElements.exitButton:SetProperFontSize(game.defaultFontFileName)

    currentElements.textToType:SetSize(windowWidth * 2, getParameter("maxTextHeight"))
    currentElements.textToType:SetProperFontSize(game.defaultFontFileName)
    refreshTextAlignment()
end

function game:enter()
    currentElements.exitButton = gui.Create("button")
    currentElements.exitButton:SetText("x")
    currentElements.exitButton.OnClick = function(this) switchToState("mainMenu") end

    currentElements.textToType = gui.Create("text")
    generateNewText()
end

function game:textinput(text)
    if text == getCharByIndex(currentElements.textToType:GetText(), currentSymbolIndex) then
        currentSymbolIndex = currentSymbolIndex + 1
        if currentSymbolIndex > textToTypeLength then
            generateNewText()
        end
        refreshTextAlignment()
    end
end

return game