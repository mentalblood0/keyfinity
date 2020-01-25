local colorChanger = {}

function colorChanger:Create(tableWhereToAddElements, parent, width, height)
	local panel = gui.Create("panel")
	panel.color = {0, 0, 0, 1}
	
	local colorbox = gui.Create("panel", panel)
	colorbox.RelativeWidth = 0.2
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
	
	local slider1 = gui.Create("slider", panel)
	slider1:SetSlideType("horizontal")
	slider1.RelativeWidth = 0.2
	slider1.RelativeHeight = 0.2
	slider1.RelativeX = 0.7
	slider1.RelativeY = 0.15
	slider1.RelativeButtonSize = 0.1
	slider1:SetMax(255)
	slider1:SetDecimals(0)
	slider1.OnValueChanged = function(object, value)
		object:GetParent().color[1] = value / 255
    end
	
	local slider1Value = gui.Create("text", panel)
	slider1Value.RelativeWidth = 0.2
	slider1Value.RelativeHeight = 0.25
	slider1Value.RelativeX = 0.4
	slider1Value.RelativeY = 0.15
	slider1Value.Update = function(object)
		local text = {{color = {1, 0, 0}}, "Red: " .. slider1:GetValue()}
		object:SetText(text)
	end
	
	local slider2 = gui.Create("slider", panel)
	slider2:SetSlideType("horizontal")
	slider2.RelativeWidth = 0.2
	slider2.RelativeHeight = 0.2
	slider2.RelativeX = 0.7
	slider2.RelativeY = 0.45
	slider2.RelativeButtonSize = 0.1
	slider2:SetMax(255)
	slider2:SetDecimals(0)
	slider2.OnValueChanged = function(object, value)
		object:GetParent().color[2] = value / 255
	end
	
	local slider2Value = gui.Create("text", panel)
	slider2Value.RelativeWidth = 0.2
	slider2Value.RelativeHeight = 0.25
	slider2Value.RelativeX = 0.4
	slider2Value.RelativeY = 0.45
	slider2Value.Update = function(object)
		local text = {{color = {0, 0.6, 0}}, "Green: " .. slider2:GetValue()}
		object:SetText(text)
	end
	
	local slider3 = gui.Create("slider", panel)
	slider3:SetSlideType("horizontal")
	slider3.RelativeWidth = 0.2
	slider3.RelativeHeight = 0.2
	slider3.RelativeX = 0.7
	slider3.RelativeY = 0.75
	slider3.RelativeButtonSize = 0.1
	slider3:SetMax(255)
	slider3:SetDecimals(0)
	slider3.OnValueChanged = function(object, value)
		object:GetParent().color[3] = value / 255
	end
	
	local slider3Value = gui.Create("text", panel)
	slider3Value.RelativeWidth = 0.2
	slider3Value.RelativeHeight = 0.25
	slider3Value.RelativeX = 0.4
	slider3Value.RelativeY = 0.75
	slider3Value.Update = function(object)
		local text = {{color = {0, 0, 1}}, "Blue: " .. slider3:GetValue()}
		object:SetText(text)
	end

    return panel
end

return colorChanger