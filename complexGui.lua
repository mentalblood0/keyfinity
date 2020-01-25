local complexGui = {objectsDirectory = "complexObjects", objects = {}}

function complexGui:addObject(name)
    complexGui.objects[name] = require(complexGui.objectsDirectory .. "/" .. name)
end

function complexGui:searchAndAddObjects()
    local files = love.filesystem.getDirectoryItems(complexGui.objectsDirectory)

    for fileNumber, fileName in ipairs(files) do
        local fileNameWithoutExtension = string.gsub(fileName, ".lua", "")
        complexGui:addObject(fileNameWithoutExtension)
    end
end

function complexGui:Create(objectName)
    local object = complexGui.objects[objectName]:Create()
    object.complex = objectName
    object.updateChildrenPositionAndSize = function(this)
        for key, child in pairs(this:GetChildren()) do
            child:updatePositionAndSizeRelativeToParent()
            child:setProperFontSize(currentState.defaultFontFileName)
        end
    end

    return object
end

return complexGui