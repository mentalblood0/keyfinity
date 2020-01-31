local modeParameters = {}

modeParameters.raw = {}
modeParameters.converted = {}

function modeParameters:addText(parentElement, text, elementTextReferTo)
    local textElement = gui.Create("text")
    if elementTextReferTo then
        elementTextReferTo.nameText = textElement
    end
    textElement:SetText(text)
    parentElement:AddItem(textElement)

    table.insert(currentElements, textElement)
end

function modeParameters:registerModeParameter(internalName, element, valueType, fileExtension)
    modeParameters.raw[internalName] = {}
    modeParameters.raw[internalName].element = element
    modeParameters.raw[internalName].valueType = valueType
    modeParameters.raw[internalName].fileExtension = fileExtension
end

function modeParameters:addIntegerNumberbox(parentElement, name, internalName, minValue, maxValue, step, defaultValue)
    local numberbox = gui.Create("numberbox")
    modeParameters:addText(parentElement, name, numberbox)
    parentElement:AddItem(numberbox)
    numberbox:SetIncreaseAmount(step)
    numberbox:SetDecreaseAmount(step)
    numberbox:SetValue(defaultValue)
    numberbox:SetMinMax(minValue, maxValue)
    numberbox:setProperFontSize(currentState.defaultFontFileName)
    
    modeParameters:registerModeParameter(internalName, numberbox, "integer")

    currentElements[internalName .. "Numberbox"] = numberbox
end

function modeParameters:addColorChanger(parentElement, name, internalName, defaultColor)
    local colorChanger = complexGui:Create("colorChanger")
    modeParameters:addText(parentElement, name, colorChanger)
    colorChanger:setColor(defaultColor)
    parentElement:AddItem(colorChanger)

    modeParameters:registerModeParameter(internalName, colorChanger, "color")

    currentElements[internalName .. "ColorChanger"] = colorChanger
end

function modeParameters:addTextInput(parentElement, name, internalName, defaultValue, fileExtension)
    local textInput = gui.Create("textinput")
    modeParameters:addText(parentElement, name, textInput)
    parentElement:AddItem(textInput)
    textInput:setProperFontSize(currentState.defaultFontFileName)
    textInput:SetText(defaultValue)

    modeParameters:registerModeParameter(internalName, textInput, "string", fileExtension)

    currentElements[internalName .. "TextInput"] = textInput
end

function modeParameters:addMultichoice(parentElement, name, internalName)
    local multichoice = gui.Create("multichoice")
    modeParameters:addText(parentElement, name, multichoice)
    parentElement:AddItem(multichoice)

    modeParameters:registerModeParameter(internalName, multichoice, "choice")

    currentElements[internalName .. "Multichoice"] = multichoice
end

function modeParameters:convert()
    modeParameters.converted = {}
    for parameterInternalName, parameter in pairs(modeParameters.raw) do
        if parameter.valueType == "integer" then
            modeParameters.converted[parameterInternalName] = tonumber(parameter.element:GetValue())
            if modeParameters.converted[parameterInternalName] == nil then
                return false
            end
        elseif parameter.valueType == "string" then
            modeParameters.converted[parameterInternalName] = parameter.element:GetText()
        elseif parameter.valueType == "color" then
            modeParameters.converted[parameterInternalName] = parameter.element:getColor()
        elseif parameter.valueType == "choice" then
            modeParameters.converted[parameterInternalName] = parameter.element:GetChoice()
        end

    end
    return true
end

return modeParameters