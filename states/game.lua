local game = {defaultFontFileName = "font.otf"}

local currentSymbols = nil
local currentSymbolIndex = nil
local textToTypeLength = nil
local fontParameters = nil
local allowedSymbols = nil
local textFromFile = nil
local symbolsTyped = nil
local functionToGenerateNewText = nil

function game:getParameter(name)
    return userProfiles[currentUserProfileName].modes[currentModeName][name]
end

function game:fontFor(type)
    return love.graphics.newFont(
        game:getParameter(type .. "SymbolsFontFileName"), 
        fonting:fontSizeToFitHeight(game:getParameter(type .. "SymbolsFontFileName"),
        game:getParameter(type .. "SymbolsMaxHeight"),
        game:getParameter("allowedSymbols")
    ))
end

function game:newFontFor(newFontFileName, type)
    return love.graphics.newFont(
        newFontFileName, 
        fonting:fontSizeToFitHeight(game:getParameter(type .. "SymbolsFontFileName"),
            game:getParameter(type .. "SymbolsMaxHeight"),
            game:getParameter("allowedSymbols")
        )
    )
end

function game:loadSymbolsParameters()
    symbolsParameters = {
        printed = {
            other = {
                font = game:fontFor("printed"),
                color = game:getParameter("printedSymbolsColor")
            }
        },
        current = {
            other = {
                font = game:fontFor("current"),
                color = game:getParameter("currentSymbolColor")
            }
        },
        unprinted = {
            other = {
                font = game:fontFor("unprinted"),
                color = game:getParameter("unprintedSymbolsColor")
            }
        }
    }
end

function game:loadTextParameters()
    symbolsTyped = 0
    local contentType = game:getParameter("contentType")
    if contentType == "random characters from the set" then
        functionToGenerateNewText = function() return textGenerator:randomSymbols(textToTypeLength, game:getParameter("allowedSymbols")) end
    elseif contentType == "text from the file" then
        local fileWithText = love.filesystem.newFile(game:getParameter("textFileName"))
        fileWithText:open("r")
        textFromFile = fileWithText:read()
        fileWithText:close()
        functionToGenerateNewText = function()
            local textString = string.sub(textFromFile, symbolsTyped + 1, symbolsTyped + 1 + textToTypeLength - 1)
            local textArray = textGenerator:makeArrayFromString(textString)
            return {string = textString, array = textArray}
        end
    end
end

function game:generateNewText()
    textToTypeLength = game:getParameter("textLineLength")
    local newText = functionToGenerateNewText()
    currentElements.textToType:setComplexText(newText, symbolsParameters)
    currentElements.textToType:setCurrentSymbolIndex(1)
end

function game:refreshTextAlignment()
    currentElements.textToType:alignTextSymbolToCenter(windowWidth / 2, windowHeight / 2)
end

function game:updateElementsPositionAndSize()
    currentElements.exitButton:SetPos(0, 0)
    currentElements.exitButton:SetSize(windowWidth / 64, windowWidth / 64)
    currentElements.exitButton:setProperFontSize(game.defaultFontFileName)

    currentElements.textToType:SetSize(windowWidth * 2, game:getParameter("maxTextHeight"))
    game:refreshTextAlignment()
end

function game:enter()
    game:loadSymbolsParameters()
    game:loadTextParameters()
    currentElements.exitButton = gui.Create("button")
    currentElements.exitButton:SetText("x")
    currentElements.exitButton.OnClick = function(this) switchToState("mainMenu") end

    currentElements.textToType = gui.Create("text")
    game:generateNewText()
end

function game:textinput(text)
    local correctSymbol = currentElements.textToType:getCurrentSymbol()
    if text == correctSymbol then
        symbolsTyped = symbolsTyped + 1
        if not currentElements.textToType:nextSymbol() then
            game:generateNewText()
        end
        game:refreshTextAlignment()
    end
end

return game