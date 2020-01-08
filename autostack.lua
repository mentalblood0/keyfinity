local autostack = {}

function autostack:stackChildren(element, childHeight, spaceLeft, spaceRight, spaceBetween)
    local childrenNumber = #element.children
    if childHeight == nil then
        childHeight = element.pos.h / (childrenNumber + spaceBetween * childrenNumber + 2 * spaceBetween + 1)
    end

    local nextElementPosition = {x = element.pos.w * spaceLeft, y = childHeight * spaceBetween, w = element.pos.w * (1 - spaceLeft - spaceRight), h = childHeight}
    if element.elementtype == "group" then
        nextElementPosition.y = childHeight * spaceBetween + childHeight
    end

    local firstChild
    if element.elementtype == "scrollgroup" then
        nextElementPosition.y = (element.headerHeight + element.bottomEdgeOffset) * element.pos.h
        firstChild = 2
    else
        firstChild = 1
    end
    for i = firstChild, childrenNumber do
        element.children[i].pos = {x = nextElementPosition.x, y = nextElementPosition.y, w = nextElementPosition.w, h = nextElementPosition.h}
        nextElementPosition.y = nextElementPosition.y + childHeight * (1 + spaceBetween)
    end

    if element.elementtype == "scrollgroup" then
        element:updateScrollEdges()
    end

    local minFontSize = 256
    for i = firstChild, childrenNumber do
        local currentChildProperFontSize = element.children[i]:getProperFontSize()
        if minFontSize > currentChildProperFontSize then
            minFontSize = currentChildProperFontSize
        end
    end
    for i = firstChild, childrenNumber do
        element.children[i]:setfont(minFontSize)
        element.children[i].fixedFontSize = true
    end
end

return autostack