local modeParameters = {}

modeParameters.raw = {}
modeParameters.converted = {}

function modeParameters:addText(parentElement, text)
    local textElement = gui.Create("text")
    textElement:SetText(text)
    parentElement:AddItem(textElement)
end

function modeParameters:addIntegerNumberbox(parentElement, name, internalName, minValue, maxValue, step, defaultValue)
    modeParameters:addText(parentElement, name)

    local numberbox = gui.Create("numberbox")
    parentElement:AddItem(numberbox)
    numberbox:SetIncreaseAmount(step)
    numberbox:SetDecreaseAmount(step)
    numberbox:SetValue(defaultValue)
    numberbox:SetMinMax(minValue, maxValue)
    
    modeParameters.raw[internalName] = {}
    modeParameters.raw[internalName].element = numberbox
    modeParameters.raw[internalName].valueType = "integer"

    currentElements[internalName .. "Numberbox"] = numberbox
end

function modeParameters:addColorChanger(parentElement, name, internalName, defaultColor)
    modeParameters:addText(parentElement, name)
    local colorChanger = complexGui:Create("colorChanger")
    colorChanger:setColor(defaultColor)
    parentElement:AddItem(colorChanger)

    modeParameters.raw[internalName] = {}
    modeParameters.raw[internalName].element = colorChanger
    modeParameters.raw[internalName].valueType = "color"

    currentElements[internalName .. "colorChanger"] = colorChanger
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