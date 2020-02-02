local parameters = {}

parameters.groups = {}

function parameters:newGroup(groupName)
    parameters.groups[groupName] = {raw = {}, converted = {}}
end

function parameters:getValue(groupName, key)
    return parameters.groups[groupName][key]
end

function parameters:addText(parentElement, text, elementTextReferTo)
    local textElement = gui.Create("text")
    if elementTextReferTo then
        elementTextReferTo.nameText = textElement
    end
    textElement:SetText(text)
    parentElement:AddItem(textElement)

    table.insert(currentElements, textElement)
end

function parameters:registerModeParameter(groupName, internalName, element, valueType, fileExtension)
    parameters.groups[groupName].raw[internalName] = {}
    parameters.groups[groupName].raw[internalName].element = element
    parameters.groups[groupName].raw[internalName].valueType = valueType
    parameters.groups[groupName].raw[internalName].fileExtension = fileExtension
end

function parameters:loadDefaultValueFromTable(internalName, table)
    return table[internalName]
end

function parameters:addIntegerNumberbox(groupName, parentElement, name, internalName, minValue, maxValue, step, defaultValue, tableToLoadDefaultValueFrom)
    if tableToLoadDefaultValueFrom then
        print("loading default value for numberbox")
        defaultValue = parameters:loadDefaultValueFromTable(internalName, tableToLoadDefaultValueFrom)
    end
    print("default value is", defaultValue)

    local numberbox = gui.Create("numberbox")
    parameters:addText(parentElement, name, numberbox)
    parentElement:AddItem(numberbox)
    numberbox:SetIncreaseAmount(step)
    numberbox:SetDecreaseAmount(step)
    numberbox:SetValue(defaultValue)
    numberbox:SetMinMax(minValue, maxValue)
    numberbox:setProperFontSize(currentState.defaultFontFileName)
    
    parameters:registerModeParameter(groupName, internalName, numberbox, "integer")

    currentElements[internalName .. "Numberbox"] = numberbox
end

function parameters:addColorChanger(groupName, parentElement, name, internalName, defaultColor, tableToLoadDefaultValueFrom)
    if tableToLoadDefaultValueFrom then
        defaultColor = parameters:loadDefaultValueFromTable(internalName, tableToLoadDefaultValueFrom)
    end

    local colorChanger = complexGui:Create("colorChanger")
    parameters:addText(parentElement, name, colorChanger)
    colorChanger:setColor(defaultColor)
    parentElement:AddItem(colorChanger)

    parameters:registerModeParameter(groupName, internalName, colorChanger, "color")

    currentElements[internalName .. "ColorChanger"] = colorChanger
end

function parameters:addTextInput(groupName, parentElement, name, internalName, defaultValue, fileExtension, tableToLoadDefaultValueFrom)
    if tableToLoadDefaultValueFrom then
        defaultValue = parameters:loadDefaultValueFromTable(internalName, tableToLoadDefaultValueFrom)
    end

    local textInput = gui.Create("textinput")
    parameters:addText(parentElement, name, textInput)
    parentElement:AddItem(textInput)
    textInput:setProperFontSize(currentState.defaultFontFileName)
    textInput:SetText(defaultValue)

    parameters:registerModeParameter(groupName, internalName, textInput, "string", fileExtension)

    currentElements[internalName .. "TextInput"] = textInput
end

function parameters:addMultichoice(groupName, parentElement, name, internalName, defaultValue, choices, tableToLoadDefaultValueFrom)
    if tableToLoadDefaultValueFrom then
        defaultValue = parameters:loadDefaultValueFromTable(internalName, tableToLoadDefaultValueFrom)
    end

    local multichoice = gui.Create("multichoice")
    parameters:addText(parentElement, name, multichoice)
    for key, choice in pairs(choices) do
        multichoice:AddChoice(choice)
    end
    multichoice:SetChoice(defaultValue)
    parentElement:AddItem(multichoice)

    parameters:registerModeParameter(groupName, internalName, multichoice, "choice")

    currentElements[internalName .. "Multichoice"] = multichoice
end

function parameters:convert(groupName)
    parameters.groups[groupName].converted = {}
    for parameterInternalName, parameter in pairs(parameters.groups[groupName].raw) do
        if parameter.valueType == "integer" then
            parameters.groups[groupName].converted[parameterInternalName] = tonumber(parameter.element:GetValue())
            if parameters.groups[groupName].converted[parameterInternalName] == nil then
                return false
            end
        elseif parameter.valueType == "string" then
            parameters.groups[groupName].converted[parameterInternalName] = parameter.element:GetText()
        elseif parameter.valueType == "color" then
            parameters.groups[groupName].converted[parameterInternalName] = parameter.element:getColor()
        elseif parameter.valueType == "choice" then
            parameters.groups[groupName].converted[parameterInternalName] = parameter.element:GetChoice()
        end

    end
    return true
end

function parameters:writeToTable(groupName, table)
    for parameterName, parameterValue in pairs(parameters.groups[groupName].converted) do
        table[parameterName] = parameterValue
    end
end

function parameters:convertAndWriteToTable(groupName, table)
    parameters:convert(groupName)
    parameters:writeToTable(groupName, table)
end

return parameters