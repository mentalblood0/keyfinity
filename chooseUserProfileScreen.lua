local table = require "dependencies/libSaveTableToFile"

local chooseUserProfileScreen = {resourcesDir = "chooseUserProfileScreen"}

userProfiles = {}
userProfilesFileName = "userProfiles.txt"

function loadSavedUserProfiles()
  if love.filesystem.isFile(userProfilesFileName) then
    userProfiles = table.load(userProfilesFileName)
  else
    table.save(userProfiles, userProfilesFileName)
  end
end

function chooseUserProfileScreen:updateElementsPositionAndSize()
  local scrollgroupWidth = windowWidth / 1.5
  local scrollgroupHeight = windowHeight / 8 * 6
  currentElements[1].pos = {x=windowWidth / 6, y=windowHeight / 8, w=scrollgroupWidth, h=scrollgroupHeight}

  autostack:stackChildren(currentElements[1], scrollgroupHeight / 8, 0.1, 0.1, 0.5)
end

function chooseUserProfileScreen:enter()
  currentElements[1] = gui:scrollgroup("Choose User", {}, nil, "vertical")
  currentElements[1].style.bg = {0.2, 0.2, 0.2, 1}
  
  currentElements[2] = gui:button("Add user", {}, currentElements[1])
  currentElements[2].style.hilite = {0.3, 0.7, 0.3, 1}
  currentElements[2].style.focus = {0.3, 0.8, 0.3}
  currentElements[2].click = function(this) switchToState("createUserScreen") end
  
  loadSavedUserProfiles()
  currentElementNumber = 3
  for userName,userProfile in next,userProfiles,nil do
    currentElements[currentElementNumber] = gui:button(userName, {}, currentElements[1])
    currentElements[currentElementNumber].style.hilite = {0.4, 0.4, 0.4, 1}
    currentElements[currentElementNumber].style.focus = {0.7, 0.7, 0.7, 1}
    currentElementNumber = currentElementNumber + 1
  end
  
  setElements()
end

function chooseUserProfileScreen:draw()
  TLfres.beginRendering(windowWidth, windowHeight)
  gui:draw()
  TLfres.endRendering()
end

function chooseUserProfileScreen:update(dt)
  gui:update(dt)
end

return chooseUserProfileScreen