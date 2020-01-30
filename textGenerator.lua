local textGenerator = {}

textGenerator.englishLetters = "qwertyuiopasdfghjklzxcvbnm "

function getCharByIndex(someString, charIndex)
    return string.char(string.byte(someString, charIndex))
end

function textGenerator:randomSymbols(numberOfSymbols, possibleSymbols)
    local numberOfPossibleSymbols = #possibleSymbols

    local result = {string = "", array = {}}
    for symbolNumber = 1, numberOfSymbols do
        local newSymbol = getCharByIndex(possibleSymbols, math.random(numberOfPossibleSymbols))
        result.string = result.string .. newSymbol
        result.array[symbolNumber] = newSymbol
    end

    return result
end

return textGenerator