-----REQUIREMENTS-----

math = require "math"
string = require "string"
os = require "os"
fonting = require "fonting"

gui = require "loveframes"
complexGui = require "complexGui"

TLfres = require "dependencies/tlfres"
IPL = require "dependencies/IPL"

textGenerator = require "textGenerator"

----------------------

-----GLOBAL VARIABLES-----

windowWidth = 1920
windowHeight = 1080

--------------------------

-----ELEMENTS FUNCTIONS-----

currentElements = {}

function clearCurrentElements()
    for key, value in pairs(currentElements) do
        if currentElements[key] ~= nil then
            currentElements[key]:Remove()
        else
            currentElements[key] = nil
        end
    end
end

----------------------------

-----STATES (aka scenes in Unity)-----

statesDirectory = "states"

states = {}
currentState = nil

function addState(name)
    states[name] = require(statesDirectory .. "/" .. name)
end

function searchAndAddStates()
    local files = love.filesystem.getDirectoryItems(statesDirectory)

    for fileNumber, fileName in ipairs(files) do
        local fileNameWithoutExtension = string.gsub(fileName, ".lua", "")
        addState(fileNameWithoutExtension)
    end
end

function updateComplexElementsChildrenPositionAndSize()
    for key, element in pairs(currentElements) do
        if element.complex then
            element:updateChildrenPositionAndSize()
        end
    end
end

function switchToState(stateName)
    clearCurrentElements()
    currentState = states[stateName]
    currentState:enter()
    currentState:updateElementsPositionAndSize()
    updateComplexElementsChildrenPositionAndSize()
    love.graphics.setBackgroundColor({0.1, 0.4, 0.3, 1})
end

--------------------------------------

-----USER PROFILES-----

userProfiles = {}
userProfilesFileName = "userProfiless.txt"
currentUserProfileName = nil
currentModeName = nil

function loadSavedUserProfiles()
    local info = love.filesystem.getInfo(userProfilesFileName)
    if info ~= nil then
        userProfiles = IPL.load(userProfilesFileName)
        if not userProfiles then
            userProfiles = {}
        end
    else
        if userProfiles ~= {} then
            IPL.store(userProfilesFileName, userProfiles)
        end
    end
end

--------------------------------------

-----LOVE CALLBACKS-----

love.load = function()
    math.randomseed(os.time())

    searchAndAddStates()
    complexGui:searchAndAddObjects()
    loadSavedUserProfiles()
    love.window.setMode(windowWidth, windowHeight, {fullscreen = false, resizable = true})
    switchToState("chooseUserProfileScreen")
end

love.update = function(dt)
    gui.update()
end

love.draw = function()
    TLfres.beginRendering(windowWidth, windowHeight)
    gui.draw()
    TLfres.endRendering()
end

love.resize = function(newWidth, newHeight)
    windowWidth = newWidth
    windowHeight = newHeight
    currentState:updateElementsPositionAndSize()
    updateComplexElementsChildrenPositionAndSize()
end

love.mousepressed = function(x, y, button)
    gui.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    gui.mousereleased(x, y, button)
end

love.keypressed = function(key, unicode)
    gui.keypressed(key, unicode)
    if currentState.keypressed then
        currentState:keypressed(key, unicode)
    end
end

function love.keyreleased(key)
    gui.keyreleased(key)
end

function love.textinput(text)
    gui.textinput(text)
    if currentState.textinput then
        currentState:textinput(text)
    end
end

function love.wheelmoved(x, y)
    gui.wheelmoved(x, y)
end

function getFileName(pathToFile)
    local reversed = string.reverse(pathToFile)
    local lastSlashIndex, trash = string.find(reversed, "/") or 0
    local lastReversedSlashIndex, trash = string.find(reversed, "\\") or 0
    local slashIndex = #pathToFile - math.max(lastSlashIndex, lastReversedSlashIndex)

    return string.sub(pathToFile, slashIndex + 2, -1)
end

function extensionOf(file)
    local pathToFile = file:getFilename()
    local fileName = getFileName(pathToFile)

    local reversed = string.reverse(fileName)
    local lastDotIndex, trash = string.find(reversed, ".") or 0
    if lastDotIndex == 0 then
        return nil
    end
    local dotIndex = #fileName - lastDotIndex
    print(fileName, dotIndex)

    return string.sub(fileName, dotIndex - 1, -1)
end

function mouseOnElement(element)
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()
    local elementX = element:GetX()
    local elementY = element:GetY()
    local elementWidth = element:GetWidth()
    local elementHeight = element:GetHeight()

    return (mouseX > elementX) and (mouseX < (elementX + elementWidth)) and (mouseY > elementY) and (mouseY < (elementY + elementHeight))
end

function createFileCopy(file)
    local fileCopyName = getFileName(file:getFilename())
    local fileCopy = love.filesystem.newFile(fileCopyName)
    
    file:open("r")
    fileCopy:open("w")
    fileCopy:write(file:read())
    file:close()
    fileCopy:close()

    return fileCopyName
end

function love.filedropped(file)
    if currentState.filedropped then
        currentState:filedropped(file)
    end
end
------------------------