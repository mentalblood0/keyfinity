local screenElementsEditor = {}

function makeDraggable(element, boundingElement)
    local getBoundingElement
    if boundingElement then
        getBoundingElement = function(this) return boundingElement end
    else
        getBoundingElement = function(this) return this.parent end
    end

    element.dragging = false

    element.Mousepressed = function(this, x, y, button)
        if mouseOnElement(this) then
            this.dragging = {dx = x - this.x, dy = y - this.y}
            return
        end
    end

    element.Mousereleased = function(this, x, y, button)
        if this.dragging then
            this:updateRelativePositionAndSize()
            this.dragging = false
        end
    end

    element.Update = function(this, dt)
        if this.dragging then
            local mouseX = love.mouse.getX()
            local mouseY = love.mouse.getY()
            local dx = this.dragging.dx
            local dy = this.dragging.dy
            local boundingElement = getBoundingElement(this)
            local newPosition = {x = mouseX - dx, y = mouseY - dy}
            if newPosition.x < boundingElement.x then
                this:SetX(boundingElement.x - this.parent.x)
            elseif (newPosition.x + this.width) > (boundingElement.x + boundingElement.width) then
                this:SetX(boundingElement.x + boundingElement.width - this.width - this.parent.x)
            else
                this:SetX(newPosition.x - this.parent.x)
            end
            
            if newPosition.y < boundingElement.y then
                this:SetY(boundingElement.y - this.parent.y)
            elseif (newPosition.y + this.height) > (boundingElement.y + boundingElement.height) then
                this:SetY(boundingElement.y + boundingElement.height - this.height - this.parent.y)
            else
                this:SetY(newPosition.y - this.parent.y)
            end

            if this.onDragging then
                this:onDragging()
            end
        end
    end
end

function makeResizeble(element)
    if not element.complex then
        complexGui:makeComplex(element, "resizeble")
    end

    local resizeButton = gui.Create("panel", element)
    resizeButton.isResizeButton = true
    resizeButton.color = {fill = {0.9, 0.9, 0.9, 0.5}, outline = {1, 1, 1, 1}}
    resizeButton.sidesAreEqual = true
    resizeButton.center = true
    resizeButton.RelativeX = 1
    resizeButton.RelativeY = 1
    resizeButton.RelativeWidth = 0.5
    resizeButton.RelativeHeight = 0.5
    makeDraggable(resizeButton, element.parent)
    resizeButton.onDragging = function(this)
        this.parent:SetWidth(this.x + this.width / 2 - this.parent.x)
        this.parent:SetHeight(this.y + this.height / 2 - this.parent.y)
        this:updateRelativePositionAndSize()
        this.parent:updateRelativePositionAndSize()
        this.parent:updateChildrenPositionAndSize()
    end
end

function screenElementsEditor:Create(args)
    local panel = gui.Create("panel")
    if args then
        panel.color = args.color
    end
    panel.elements = {}
    
    panel.addElement = function(this, label, relativeX, relativeY, relativeWidth, relativeHeight, color)
        local newElement = complexGui:Create("labeledPanel", {label = label or "label"})
        newElement.RelativeX = relativeX or math.random() * 0.7
        newElement.RelativeY = relativeY or math.random() * 0.7
        newElement.RelativeWidth = relativeWidth or 0.3
        newElement.RelativeHeight = relativeHeight or 0.3
        newElement.color = color or {fill = {0.9, 0.9, 0.9, 0.5}, outline = {1, 1, 1, 1}}
        newElement:SetParent(this)
        makeDraggable(newElement)
        makeResizeble(newElement)

        table.insert(this.elements, newElement)
    end

    return panel
end

return screenElementsEditor