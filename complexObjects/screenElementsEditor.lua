local screenElementsEditor = {}

function screenElementsEditor:Create(args)
    local panel = gui.Create("panel")
    if args then
        panel.color = args.color
    end
    panel.elements = {}
    
    panel.addElement = function(this, relativeX, relativeY, relativeWidth, relativeHeight, color)
        local newElement = gui.Create("panel")
        newElement.RelativeX = relativeX or 0.3
        newElement.RelativeY = relativeY or 0.3
        newElement.RelativeWidth = relativeWidth or 0.3
        newElement.RelativeHeight = relativeHeight or 0.3
        newElement.color = color or {fill = {0.9, 0.9, 0.9, 0.5}, outline = {1, 1, 1, 1}}
        newElement.dragging = false
        newElement:SetParent(this)
        table.insert(this.elements, newElement)
    end

    panel.mousepressed = function(this, x, y, button)
        for key, element in pairs(this.elements) do
            if mouseOnElement(element) then
                print(x, y, element:GetX(), element:GetY())
                element.dragging = {dx = x - element:GetX(), dy = y - element:GetY()}
                return
            end
        end
    end

    panel.mousereleased = function(this, x, y, button)
        for key, element in pairs(this.elements) do
            element.dragging = false
        end
    end

    panel.Update = function(this, dt)
        for key, element in pairs(this.elements) do
            if element.dragging then
                local mouseX = love.mouse.getX()
                local mouseY = love.mouse.getY()
                local dx = element.dragging.dx
                local dy = element.dragging.dy
                local newPosition = {x = mouseX - dx - this:GetX(), y = mouseY - dy - this:GetY(), width = element.width, height = element.height}
                if newPosition.x < 0 then
                    element:SetX(0)
                elseif (newPosition.x + newPosition.width) > this.width then
                    element:SetX(this.width - element.width)
                else
                    element:SetX(newPosition.x)
                end
                
                if newPosition.y < 0 then
                    element:SetY(0)
                elseif (newPosition.y + newPosition.height) > this.height then
                    element:SetY(this.height - element.height)
                else
                    element:SetY(newPosition.y)
                end
            end
        end
    end

    return panel
end

return screenElementsEditor