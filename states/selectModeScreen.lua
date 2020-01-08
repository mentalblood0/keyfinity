local selectModeScreen = {resourcesDir = "selectModeScreen"}

currentModeName = nil

function selectModeScreen:updateElementsPositionAndSize()
    local scrollgroupWidth = windowWidth / 1.5
    local scrollgroupHeight = windowHeight / 8 * 5
    currentElements.modesScrollgroup.pos = {x=windowWidth / 6, y=windowHeight / 8, w=scrollgroupWidth, h=scrollgroupHeight}
    autostack:stackChildren(currentElements.modesScrollgroup, scrollgroupHeight / 8, 0.1, 0.1, 0.5)

    currentElements["createModeButton"].pos = {x=windowWidth / 6, y=windowHeight / 8 * 6 + scrollgroupHeight / 8, w=scrollgroupWidth, h=scrollgroupHeight / 8}
end

function selectModeScreen:enter()
    currentElements.modesScrollgroup = gui:scrollgroup("Select mode", {}, 1 / 10, 1 / 8 / 2, {0.35, 0.3, 0.55, 1}, nil, "vertical")
    currentElements.modesScrollgroup.style.bg = {0.2, 0.3, 0.5, 1}
    
    currentElements.createModeButton = gui:button("Create mode", {})
    currentElements.createModeButton.style.default = {0.2, 0.6, 0.3, 1}
    currentElements.createModeButton.style.hilite = {0.2, 0.7, 0.2}
    currentElements.createModeButton.click = function(this) switchToState("createModeScreen") end
    
    if userProfiles[currentUserProfileName]["modes"] then
        for modeName,mode in next,userProfiles[currentUserProfileName]["modes"],nil do
            currentElements[modeName .. "ModeButton"] = gui:button(modeName, {}, currentElements["modesScrollgroup"])
            currentElements[modeName .. "ModeButton"].style.hilite = {0.65, 0.65, 0.2, 1}
            currentElements[modeName .. "ModeButton"].style.focus = {0.75, 0.75, 0.2, 1}
            currentElements[modeName .. "ModeButton"].click = function(this) currentModeName = this.label; switchToState("game") end
        end
    end
    
    setElements()
end

function selectModeScreen:draw()
    TLfres.beginRendering(windowWidth, windowHeight)
    gui:draw()
    TLfres.endRendering()
end

function selectModeScreen:update(dt)
    gui:update(dt)
end

return selectModeScreen