local game = {defaultFontFileName = "font.ttf"}

function getParameter(parameterName)
    return userProfiles[currentUserProfileName].modes[currentModeName][parameterName]
end

function game:updateElementsPositionAndSize()
    currentElements.exitButton:SetPos(0, 0)
    currentElements.exitButton:SetSize(windowWidth / 64, windowWidth / 64)
    currentElements.exitButton:SetProperFontSize(game.defaultFontFileName)

    currentElements.textToType:SetSize(windowWidth * 2, getParameter("maxTextHeight"))
    currentElements.textToType:SetProperFontSize(game.defaultFontFileName)
    currentElements.textToType:SetPos(windowWidth / 2, windowHeight / 2 - currentElements.textToType:GetHeight() / 2)
end

function game:enter()
    currentElements.exitButton = gui.Create("button")
    currentElements.exitButton:SetText("x")
    currentElements.exitButton.OnClick = function(this) switchToState("mainMenu") end

    currentElements.textToType = gui.Create("text")
    currentElements.textToType:SetText(textGenerator:randomSymbols(16))
end

return game