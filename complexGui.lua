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

function complexGui:makeComplex(object, objectName)
    object.complex = objectName
    object.type = objectName
    object.updateChildrenPositionAndSize = function(this)
        local children = this:GetChildren()
        if not children then
            return
        end
        for key, child in pairs(this:GetChildren()) do
            if not (child.isResizeButton and child.dragging) then
                child:updatePositionAndSizeRelativeToParent()
            end
            child:setProperFontSize(currentState.defaultFontFileName)
            if child.complex then
                child:updateChildrenPositionAndSize()
            end
        end
    end
end

function complexGui:Create(objectName, args)
    local object = complexGui.objects[objectName]:Create(args)
    complexGui:makeComplex(object, objectName)

    return object
end

return complexGui