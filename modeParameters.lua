local modeParameters = {}

modeParameters.raw = {}
modeParameters.converted = {}

function modeParameters:addIntegerNumberbox(parentElement, name, internalName, minValue, maxValue, step, defaultValue)
    local nameText = gui.Create("text")
    nameText:SetText(name)
    parentElement:AddItem(nameText)

    local numberbox = gui.Create("numberbox")
    parentElement:AddItem(numberbox)
    numberbox:SetIncreaseAmount(step)
    numberbox:SetDecreaseAmount(step)
    numberbox:SetValue(defaultValue)
    numberbox:SetMinMax(minValue, maxValue)
    
    modeParameters[internalName] = {}
    modeParameters[internalName].element = numberbox
    modeParameters[internalName].valueType = "integer"

    currentElements[internalName .. "Numberbox"] = numberbox
end

function modeParameters:convert()
    modeParameters.converted = {}
    for parameterInternalName, parameter in pairs(modeParameters) do
        if parameter.valueType == "integer" then
            modeParameters.converted[parameterInternalName] = tonumber(parameter.element:GetText())
            if modeParameters.converted[parameterInternalName] == nil then
                return false
            end
        elseif parameter.valueType == "string" then
            modeParameters.converted[parameterInternalName] = parameter.element:GetText()
        end
    end
    return true
end

return modeParameters