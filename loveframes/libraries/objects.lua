--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

return function(loveframes)
---------- module start ----------

loveframes.objects = {}


--[[---------------------------------------------------------
	- func: Create(type, parent)
	- desc: creates a new object or multiple new objects
			(based on the method used) and returns said
			object or objects for further manipulation
--]]---------------------------------------------------------
function loveframes.Create(data, parent)
	
	if type(data) == "string" then
	
		local objects = loveframes.objects
		local object = objects[data]
		local objectcount = loveframes.objectcount
		
		if not object then
			loveframes.Error("Error creating object: Invalid object '" ..data.. "'.")
		end
		
		-- create the object
		local newobject = object:new()
		
		-- apply template properties to the object
		loveframes.ApplyTemplatesToObject(newobject)
		
		-- if the object is a tooltip, return it and go no further
		if data == "tooltip" then
			return newobject
		end
		
		-- remove the object if it is an internal
		if newobject.internal then
			newobject:Remove()
			return
		end
		
		-- parent the new object by default to the base gui object
		newobject.parent = loveframes.base
		table.insert(loveframes.base.children, newobject)
		
		-- if the parent argument is not nil, make that argument the object's new parent
		if parent then
			newobject:SetParent(parent)
		end
		
		loveframes.objectcount = objectcount + 1
		
		-- return the object for further manipulation
		return newobject
		
	elseif type(data) == "table" then

		-- table for creation of multiple objects
		local objects = {}
		
		-- this function reads a table that contains a layout of object properties and then
		-- creates objects based on those properties
		local function CreateObjects(t, o, c)
			local child = c or false
			local validobjects = loveframes.objects
			for k, v in pairs(t) do
				-- current default object
				local object = validobjects[v.type]:new()
				-- insert the object into the table of objects being created
				table.insert(objects, object)
				-- parent the new object by default to the base gui object
				object.parent = loveframes.base
				table.insert(loveframes.base.children, object)
				if o then
					object:SetParent(o)
				end
				-- loop through the current layout table and assign the properties found
				-- to the current object
				for i, j in pairs(v) do
					if i ~= "children" and i ~= "func" then
						if child then
							if i == "x" then
								object["staticx"] = j
							elseif i == "y" then
								object["staticy"] = j
							else
								object[i] = j
							end
						else
							object[i] = j
						end
					elseif i == "children" then
						CreateObjects(j, object, true)
					end
				end
				if v.func then
					v.func(object)
				end
			end
		end
		
		-- create the objects
		CreateObjects(data)
		
		return objects
		
	end
	
end

--[[---------------------------------------------------------
	- func: NewObject(id, name, inherit_from_base)
	- desc: creates a new object
--]]---------------------------------------------------------

function loveframes.NewObject(id, name, inherit_from_base)
	
	local objects = loveframes.objects
	local object = false
	
	if inherit_from_base then
		local base = objects["base"]
		object = loveframes.class(name, base)
		objects[id] = object
	else
		object = loveframes.class(name)
		objects[id] = object
	end

	object.SetFont = function(this, font)
		this.font = font
	end

	object.getProperFontSize = function(this, fontFileName)
		return fonting:fontSizeToFitIntoRect(fontFileName, this.width, this.height, this:GetText())
	end

	object.setProperFontSize = function(this, fontFileName)
		if (not this.text) and (not this.value) and (not (this:GetType() == "numberbox")) and (not (this.type == "textinput")) then
			return
		end
		this.fontFileName = fontFileName
		this.fontSize = this:getProperFontSize(fontFileName)
		this.font = love.graphics.newFont(fontFileName, this.fontSize)
		this:SetFont(this.font)
	end

	object.updatePositionAndSizeRelativeToParent = function(this)
		if this.RelativeWidth and this.RelativeHeight then
			local newWidth = this.RelativeWidth * this.parent.width
			local newHeight = this.RelativeHeight * this.parent.height
			if this.sidesAreEqual then
				local minSideLength = math.min(newWidth, newHeight)
				this:SetSize(minSideLength, minSideLength)
			else
				this:SetSize(newWidth, newHeight)
			end
		end
		if this.RelativeX and this.RelativeY then
			this:SetPos(this.RelativeX * this.parent.width, this.RelativeY * this.parent.height, this.center)
		end
		if this.RelativeButtonSize then
			local minParentSideSize = math.min(this.parent.width, this.parent.height)
			this:SetButtonSize(this.RelativeButtonSize * minParentSideSize, this.RelativeButtonSize * minParentSideSize)
		end
		if this:GetType() == "slider" then
			this:SetValue(this:GetValue())
		end
	end

	object.updateRelativePositionAndSize = function(this)
		if this.RelativeWidth and this.RelativeHeight then
			this.RelativeWidth = this.width / this.parent.width
			this.RelativeHeight = this.height / this.parent.height
		end
		if this.RelativeX and this.RelativeY then
			if this.center then
				this.RelativeX = (this.x + this.width / 2 - this.parent.x) / this.parent.width
				this.RelativeY = (this.y + this.height / 2 - this.parent.y) / this.parent.height
			else
				this.RelativeX = (this.x - this.parent.x) / this.parent.width
				this.RelativeY = (this.y - this.parent.y) / this.parent.height
			end
		end
	end

	if name == "loveframes_object_list" then

		object.SetEqualChildrenFontSize = function(this, fontFileName)
			local children = this:GetChildren()
			if not children then
				return
			end
			local minFontSize = 0
			for key, child in pairs(children) do
				if child.text or (child.type == "textinput") or (child.type == "numberbox") then
					local currentChildFontSize = child:getProperFontSize(fontFileName)
					if (currentChildFontSize < minFontSize) or (minFontSize == 0) then
						minFontSize = currentChildFontSize
					end
				end
			end
			for key, child in pairs(children) do
				if child.text or (child.type == "textinput") or (child.type == "numberbox") then
					child:SetFont(love.graphics.newFont(fontFileName, minFontSize))
				end
			end
		end

		object.SetChildrenHeight = function(this, height)
			local children = this:GetChildren()
			for key, value in next, children, nil do
				children[key]:SetHeight(height)
			end
		end

	elseif name == "loveframes_object_text" then
		object.SetHeight = function(this, newHeight)
			this.height = newHeight
		end
	elseif name == "loveframes_object_tabs" then
		object.setChildrenSize = function(this, newWidth, newHeight)
			for key, child in pairs(this:GetChildren()) do
				child:SetSize(newWidth, newHeight)
			end
		end
	end
	
	object:SetFont(loveframes.basicfont)

	return object
	
end

function loveframes.LoadObjects(dir)
	local objectlist = loveframes.GetDirectoryContents(dir)
	-- loop through a list of all gui objects and require them
	for k, v in ipairs(objectlist) do
		if v.extension == "lua" then
			loveframes.require(v.requirepath)
		end
	end
end
--return objects

---------- module end ----------
end