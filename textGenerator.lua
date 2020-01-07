local textGenerator = {}

englishLetters = "qwertyuiopasdfghjklzxcvbnm        "

function getCharByIndex(someString, charIndex)
    return string.char(string.byte(someString, charIndex))
end

function textGenerator:randomSymbols(numberOfSymbols)
    local possibleSymbols = englishLetters
    local numberOfPossibleSymbols = #possibleSymbols

    local text = ""
    for symbolNumber = 1, numberOfSymbols do
        local newSymbol = getCharByIndex(possibleSymbols, math.random(numberOfPossibleSymbols))
        text = text .. newSymbol
    end

    return text
end

return textGenerator