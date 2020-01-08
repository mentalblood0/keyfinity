-----REQUIREMENTS-----

TLfres = require "dependencies/tlfres"
gui = require "dependencies/Gspot"
IPL = require "dependencies/IPL"
textGenerator = require "textGenerator"

autostack = require "autostack"

math = require "math"
string = require "string"
os = require "os"

----------------------

-----GLOBAL VARIABLES-----

windowWidth = 1920
windowHeight = 1080

--------------------------

-----STATES (aka scenes in Unity)-----

statesDirectory = "states"

states = {}

function addState(name)
    states[name] = require(statesDirectory .. "/" .. name)
end

function searchAndAddStates()
    local files = love.filesystem.getDirectoryItems("states")

    for fileNumber, fileName in ipairs(files) do
        local fileNameWithoutExtension = string.gsub(fileName, ".lua", "")
        addState(fileNameWithoutExtension)
    end
end

function clearCurrentElements()
    for key, value in pairs(currentElements) do
        if key ~= nil then
            gui:rem(currentElements[key])
        else
            currentElements[key] = nil
        end
    end
end

function switchToState(stateName)
    print(stateName)
    clearCurrentElements()
    currentState = states[stateName]
    print('current state is', currentState)
    currentState:enter()
    love.graphics.setBackgroundColor({0.6, 0.3, 0.6, 1})
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
    math.randomseed(os.time())

    searchAndAddStates()
    loadSavedUserProfiles()
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
    if currentState.keypressed then
        currentState:keypressed(key, scancode, isrepeat)
    end
end

love.textinput = function(text)
    gui:textinput(text)
    if currentState.keypressed then
        currentState:textInput(text)
    end
end

love.wheelmoved = function(x, y)
    gui:mousewheel(x, y)
end

------------------------