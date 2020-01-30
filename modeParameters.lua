local modeParameters = {}

modeParameters.raw = {}
modeParameters.converted = {}

function modeParameters:addText(parentElement, text)
    local textElement = gui.Create("text")
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
    modeParameters:addText(parentElement, name)

    local numberbox = gui.Create("numberbox")
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
    modeParameters:addText(parentElement, name)

    local colorChanger = complexGui:Create("colorChanger")
    colorChanger:setColor(defaultColor)
    parentElement:AddItem(colorChanger)

    modeParameters:registerModeParameter(internalName, colorChanger, "color")

    currentElements[internalName .. "ColorChanger"] = colorChanger
end

function modeParameters:addTextInput(parentElement, name, internalName, defaultValue, fileExtension)
    modeParameters:addText(parentElement, name)

    local textInput = gui.Create("textinput")
    parentElement:AddItem(textInput)
    textInput:setProperFontSize(currentState.defaultFontFileName)
    textInput:SetText(defaultValue)

    modeParameters:registerModeParameter(internalName, textInput, "string", fileExtension)

    currentElements[internalName .. "TextInput"] = textInput
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
        end

    end
    return true
end

return modeParameters