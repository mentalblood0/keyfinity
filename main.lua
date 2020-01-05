-----REQUIREMENTS-----

TLfres = require "dependencies/tlfres"
gui = require "dependencies/Gspot"
IPL = require "dependencies/IPL"

autostack = require "autostack"

math = require "math"
string = require "string"

----------------------

-----GLOBAL VARIABLES-----

windowWidth = 1920
windowHeight = 1080

--------------------------

-----STATES (aka scenes in Unity)-----

states = {}

function addState(name)
  states[name] = require(name)
end

addState("mainMenu")
addState("chooseUserProfileScreen")
addState("createUserScreen")

currentState = states.chooseUserProfileScreen

function clearCurrentElements()
  local count = #currentElements
  for i=1,count do
    if currentElements[i] ~= nil then
      gui:rem(currentElements[i])
    else
      currentElements[i] = nil
    end
  end
end

function switchToState(stateName)
  clearCurrentElements()
  currentState = states[stateName]
  currentState:enter()
end

--------------------------------------

-----ELEMENTS FUNCTIONS-----

currentElements = {}

function setElements()
  setProperElementsFont()
  currentState:updateElementsPositionAndSize()
  updateElementsFontSize()
end

function updateElementsFontSize()
  for elementName,element in next,currentElements,nil do
    element:updateFontSize()
  end
end

function setProperElementsFont()
  local currentFontPath = "resources" .. currentState.resourcesDir .. "/font.ttf"
  for elementName,element in next,currentElements,nil do element:setfont(currentFontPath) end
end

----------------------------

-----LOVE CALLBACKS-----

love.load = function()
  love.window.setMode(windowWidth, windowHeight, {fullscreen = false, resizable = true})
  switchToState("chooseUserProfileScreen")
end

love.update = function(dt)
  currentState:update(dt)
end

love.draw = function()
  currentState.draw()
end

love.resize = function(newWidth, newHeight)
  windowWidth = newWidth
  windowHeight = newHeight
  
  currentState:updateElementsPositionAndSize()
  updateElementsFontSize()
end

love.mousepressed = function(x, y, button)
  gui:mousepress(x, y, button)
end

love.keypressed = function(key, scancode, isrepeat)
  gui:keypress(scancode)
end

love.textinput = function(text)
  gui:textinput(text)
end

love.wheelmoved = function(x, y)
  local button
  if y > 0 then
    button = 'wu'
  else
    button = 'wd'
  end
  gui:mousewheel(x, y)
end

------------------------