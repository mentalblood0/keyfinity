local labeledPanel = {}

function labeledPanel:Create(args)
    local panel = gui.Create("panel")
    panel.color = args.color or panel.color
    
    local label = gui.Create("text", panel)
    label:SetText(args.label)
    label.RelativeX = relativeX or 0.5
    label.RelativeY = relativeY or 0.5
    label.RelativeWidth = relativeWidth or 0.6
    label.RelativeHeight = relativeHeight or 0.8
    label.center = true

    return panel
end

return labeledPanel