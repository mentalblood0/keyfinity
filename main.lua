-----REQUIREMENTS-----

TLfres = require "dependencies/tlfres"
gui = require "dependencies/Gspot"
autostack = require "autostack"
local math = require "math"
local string = require "string"

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
addState("createUserScreen")
addState("chooseUserProfileScreen")

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

function fontSizeToFitIntoRect(rect, label)
  return math.min(rect.w / string.len(label) * 2, rect.h / 1.3)
end

function updateElementsFontSize()
  for elementName,element in next,currentElements,nil do
    local newFontSize
    if labelLength ~= 0 then
      if element.elementtype == "group" then
        newFontSize = fontSizeToFitIntoRect(element.children[1].pos, element.label)
      else
        if element.elementtype == "scrollgroup" then
          newFontSize = fontSizeToFitIntoRect(element.children[2].pos, element.label)
        else
          newFontSize = fontSizeToFitIntoRect(element.pos, element.label)
        end
      end
    else
      if element.elementtype == "input" then
        newFontSize = math.min(element.pos.h / 1.3)
      end
    end
    element:setfont(newFontSize)
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

------------------------