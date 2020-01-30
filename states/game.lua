local game = {defaultFontFileName = "font.ttf"}

local currentSymbols = nil
local currentSymbolIndex = nil
local textToTypeLength = nil
local fontParameters = nil
local allowedSymbols = nil

function game:getParameter(parameterName)
    return userProfiles[currentUserProfileName].modes[currentModeName][parameterName]
end

function game:fontFor(type)
    return love.graphics.newFont(
        game:getParameter(type .. "SymbolsFontFileName"), 
        fonting:fontSizeToFitHeight(game:getParameter(type .. "SymbolsFontFileName"),
        game:getParameter(type .. "SymbolsMaxHeight"),
        game:getParameter("allowedSymbols")
    ))
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
    allowedSymbols = game:getParameter("allowedSymbols")
end

function game:generateNewText()
    textToTypeLength = game:getParameter("textLineLength")
    local newText = textGenerator:randomSymbols(textToTypeLength, game:getParameter("allowedSymbols"))
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
    currentElements.exitButton = gui.Create("button")
    currentElements.exitButton:SetText("x")
    currentElements.exitButton.OnClick = function(this) switchToState("mainMenu") end

    currentElements.textToType = gui.Create("text")
    game:generateNewText()
end

function game:textinput(text)
    local correctSymbol = currentElements.textToType:getCurrentSymbol()
    if text == correctSymbol then
        if not currentElements.textToType:nextSymbol() then
            game:generateNewText()
        end
        game:refreshTextAlignment()
    end
end

return game