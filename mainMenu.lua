local mainMenu = {resourcesDir = "mainMenu"}

function updateElementsPositionAndSize()
    local buttonsWidth = windowWidth/4
    local buttonsHeight = windowHeight/4
  
    local firstEntityPositionX = buttonsWidth/2
    local firstEntityPositionY = buttonsHeight/2
    for key,entity in ipairs(currentElements) do
      entity.pos = {x=firstEntityPositionX, y=firstEntityPositionY + buttonsHeight*1.6*(key - 1), w=buttonsWidth, h=buttonsHeight}
    end
  end
  
  function enter()
    currentElements[1] = gui:button("start")
    currentElements[2] = gui:button("exit")
    currentElements[2].click = function(this) love.event.quit() end
  
    setElements()
  end
  
  function draw()
    TLfres.beginRendering(windowWidth, windowHeight)
    gui:draw()
    TLfres.endRendering()
  end
  
  function update(dt)
    gui:update(dt)
  end