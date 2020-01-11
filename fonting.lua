local fonting = {}

function fonting:fontSizeToFitIntoRect(fontFileName, rectWidth, rectHeight, text)
	print(fontFileName, rectWidth, rectHeight, text)
	local fontSize = math.floor(math.min(rectWidth / string.len(text) * 2, rectHeight / 1.3))
    local font = love.graphics.newFont(fontFileName, fontSize)
    while font:getHeight(text) * 1.3 < rectHeight do
		fontSize = fontSize + 1
		font = love.graphics.newFont(fontFileName, fontSize)
    end
    while font:getHeight(text) * 1.3 > rectHeight do
		fontSize = fontSize - 1
		font = love.graphics.newFont(fontFileName, fontSize)
    end
    while font:getWidth(text) > rectWidth do
		fontSize = fontSize - 1
		font = love.graphics.newFont(fontFileName, fontSize)
	end
	print("=>", fontSize)
	return fontSize
end

return fonting