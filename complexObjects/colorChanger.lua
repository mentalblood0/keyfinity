local colorChanger = {}

function colorChanger:Create(tableWhereToAddElements, parent, width, height)
	local panel = gui.Create("panel")
	panel.color = {0, 0, 0, 1}
	
	local colorbox = gui.Create("panel", panel)
	colorbox.RelativeWidth = 0.3
	colorbox.RelativeHeight = 1
	colorbox.RelativeX = 0
	colorbox.RelativeY = 0
	colorbox.Draw = function(object)
		love.graphics.setColor(object:GetParent().color)
		love.graphics.rectangle("fill", object:GetX(), object:GetY(), object:GetWidth(), object:GetHeight())
		love.graphics.setColor(.6, .6, .6, 1)
		love.graphics.setLineWidth(1)
		love.graphics.setLineStyle("smooth")
		love.graphics.rectangle("line", object:GetX(), object:GetY(), object:GetWidth(), object:GetHeight())
    end
    colorbox:SetParent(panel)
	
	local slider1 = gui.Create("slider", frame)
	slider1:SetSlideType("horizontal")
	slider1.RelativeWidth = 0.3
	slider1.RelativeX = 0.6
	slider1.RelativeY = 0.15
	slider1.RelativeButtonSize = 0.1
	slider1:SetMax(255)
	slider1:SetDecimals(0)
	slider1.OnValueChanged = function(object, value)
		object:GetParent().color[1] = value / 255
    end
    slider1:SetParent(panel)
	
	local slider1Name = gui.Create("text", frame)
	slider1Name:SetText("Red")
	slider1Name:SetParent(panel)
	
	local slider1Value = gui.Create("text", frame)
	slider1Value.Update = function(object)
		object:SetText(slider1:GetValue())
	end
	slider1Value:SetParent(panel)
	
	local slider2 = gui.Create("slider", frame)
	slider2:SetSlideType("horizontal")
	slider2.RelativeWidth = 0.3
	slider2.RelativeX = 0.6
	slider2.RelativeY = 0.45
	slider2.RelativeButtonSize = 0.1
	slider2:SetMax(255)
	slider2:SetDecimals(0)
	slider2.OnValueChanged = function(object, value)
		object:GetParent().color[2] = value / 255
	end
	slider2:SetParent(panel)
	
	local slider2Name = gui.Create("text", frame)
	slider2Name:SetText("Green")
	slider2Name:SetParent(panel)
	
	local slider2Value = gui.Create("text", frame)
	slider2Value.Update = function(object)
		object:SetText(slider2:GetValue())
	end
	slider2Value:SetParent(panel)
	
	local slider3 = gui.Create("slider", frame)
	slider3:SetSlideType("horizontal")
	slider3.RelativeWidth = 0.3
	slider3.RelativeX = 0.6
	slider3.RelativeY = 0.75
	slider3.RelativeButtonSize = 0.1
	slider3:SetMax(255)
	slider3:SetDecimals(0)
	slider3.OnValueChanged = function(object, value)
		object:GetParent().color[3] = value / 255
	end
	slider3:SetParent(panel)
	
	local slider3Name = gui.Create("text", frame)
	slider3Name:SetText("Blue")
	slider3Name:SetParent(panel)
	
	local slider3Value = gui.Create("text", frame)
	slider3Value.Update = function(object)
		object:SetText(slider3:GetValue())
	end
	slider3Value:SetParent(panel)

    return panel
end

return colorChanger