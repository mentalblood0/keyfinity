local textGenerator = {}

englishLetters = "qwertyuiopasdfghjklzxcvbnm        "

function getCharByIndex(someString, charIndex)
    return string.char(string.byte(someString, charIndex))
end

function textGenerator:randomSymbols(numberOfSymbols)
    local possibleSymbols = englishLetters
    local numberOfPossibleSymbols = #possibleSymbols

    local result = {text = "", array = {}}
    for symbolNumber = 1, numberOfSymbols do
        local newSymbol = getCharByIndex(possibleSymbols, math.random(numberOfPossibleSymbols))
        result.text = result.text .. newSymbol
        result.array[symbolNumber] = newSymbol
    end

    return result
end

return textGenerator