local modeButtons = {}

editing = false

function editMode(modeName)
    currentModeName = modeName
    editing = true
    switchToState("createModeScreen")
end

function deleteMode(modeName)
    userProfiles[currentUserProfileName].modes[modeName] = nil
    save()
    switchToState("selectModeScreen")
end

function modeButtons:Create(args)
    local panel = gui.Create("panel")
    
    local activateButton = gui.Create("button", panel)
    activateButton.RelativeWidth = 0.6
    activateButton.RelativeHeight = 1
    activateButton.RelativeX = 0
    activateButton.RelativeY = 0
    activateButton:SetText(args)
    activateButton.OnClick = function(this) currentModeName = this.text; switchToState("mainMenu") end

    local editButton = gui.Create("button", panel)
    editButton.RelativeWidth = 0.2
    editButton.RelativeHeight = 1
    editButton.RelativeX = 0.6
    editButton.RelativeY = 0
    editButton:SetText("edit")
    editButton.OnClick = function(this) editMode(this.parent.children[1].text) end

    local deleteButton = gui.Create("button", panel)
    deleteButton.RelativeWidth = 0.2
    deleteButton.RelativeHeight = 1
    deleteButton.RelativeX = 0.8
    deleteButton.RelativeY = 0
    deleteButton:SetText("delete")
    deleteButton.OnClick = function(this) deleteMode(this.parent.children[1].text) end

    return panel
end

return modeButtons