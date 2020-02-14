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

function complexGui:Create(objectName, args)
    local object = complexGui.objects[objectName]:Create(args)
    object.complex = objectName
    object.type = objectName
    object.updateChildrenPositionAndSize = function(this)
        local children = this:GetChildren()
        if not children then
            return
        end
		for key, child in pairs(this:GetChildren()) do
            child:updatePositionAndSizeRelativeToParent()
            child:setProperFontSize(currentState.defaultFontFileName)
        end
    end

    return object
end

return complexGui