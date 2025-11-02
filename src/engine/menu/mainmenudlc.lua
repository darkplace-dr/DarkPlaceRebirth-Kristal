---@class MainMenuDLC : StateClass
---
---@field menu MainMenu
---
---@overload fun(menu:MainMenu) : MainMenuDLC
local MainMenuDLC, super = Class(StateClass)

local extractor = require("src.lib.extractor")

function MainMenuDLC:init(menu)
    self.menu = menu

    self.state_manager = StateManager("MAIN", self, true)
    self.state_manager:addState("MAIN", {
    	enter = self.onEnterMain,
    	keypressed = self.onKeyPressedMain,
    	draw = self.drawMain
    })
    self.state_manager:addState("DOWNLOAD", {
    	enter = self.onEnterDownload,
    	draw = self.drawDownload,
    	update = self.updateDownload
    })
    self.state_manager:addState("ERROR", {
    	enter = self.onEnterError,
    	leave = self.onLeaveError,
    	keypressed = self.onKeyPressedError,
    	draw = self.drawError
    })

    self.list = nil

    self.images = {
    	preview={},
    	banner={}
    }

    self.installed_dlcs = {}

    -- Networking stuff I guess??
    self.loading_dlcs = false
    self.loading_list = {}
    self.loading_callback = nil
    self.loading_queue_index = 0
    self.send_request = false

    self.content_index = 1
    self.temp_content = nil

    self.loading_errors = {}

    self.active = false

    -- Something something UI Box
    self.left_frame   = 0
    self.top_frame    = 0
    self.corner_frame = 0

    self.left   = Assets.getFramesOrTexture("ui/box/paddingless/left")
    self.top    = Assets.getFramesOrTexture("ui/box/paddingless/top")
    self.corner = Assets.getFramesOrTexture("ui/box/paddingless/corner")

    self.corners = {{0, 0}, {1, 0}, {1, 1}, {0, 1}}

    self.box_mode = Kristal.Config["dlc_box_style"] or "menu" -- menu, ui

    self.font = Assets.getFont("main", 16)

    DLC = self -- For easy access in the console
end

function MainMenuDLC:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

-----------------------------------------------
--- Callbacks
-----------------------------------------------

function MainMenuDLC:onEnter()
	print("onEnter")
	self.active = true

	self.menu.heart_target_x = -16
	--self.menu.heart_target_y = -16

	if not self.list then
		if (Kristal.Config["ardlc"] and Kristal.loadedDLCs ~= true) then
		
		end
		print("Build the DLC list")
		self:buildDLCList()
		if (Kristal.Config["ardlc"] and Kristal.loadedDLCs ~= true) then
			self:reloadMods(function()
				self:buildDLCList(true)
			end)
			Kristal.loadedDLCs = true
		end
	else
		self.list.active = true
		self.list.visible = true

		self:setState("MAIN")
	end
end

function MainMenuDLC:onLeave()
	self.active = false

	if self.list then
        self.list.active = false
        self.list.visible = false
    end

    if self.box_mode ~= Kristal.Config["dlc_box_style"] then
    	Kristal.Config["dlc_box_style"] = self.box_mode
    	Kristal.saveConfig()
    end
end

function MainMenuDLC:update()
	self.state_manager:update()
end

function MainMenuDLC:draw()
	Draw.setColor(COLORS.silver)
    Draw.printShadow("( DLC  )", 0, 0, 2, "center", 640)

	self.state_manager:draw()

	Draw.setColor(COLORS.red)
	Draw.printShadow("Note: This thing is held together by hopes and dreams", 0, SCREEN_HEIGHT-16)
end

function MainMenuDLC:onKeyPressed(key, is_repeat)
	self.state_manager:call("keypressed", key, is_repeat)
end

-----------------------------------------------
--- Substates Callbacks
-----------------------------------------------

--- MAIN
function MainMenuDLC:onEnterMain()
	--print("Gello world...?")
	if self.list then
        self.list.active = true
        self.list.visible = true
    end
end

function MainMenuDLC:onKeyPressedMain(key, is_repeat)
	if Input.isConfirm(key) and not is_repeat then
    	local id = self.list:getSelectedId()
    	self:handleMod(id)
	elseif Input.isCancel(key) then
		Assets.stopAndPlaySound("ui_move")

        self.menu:setState("TITLE")
        self.menu.title_screen:selectOption("dlc")
        return true
    elseif (Input.isMenu(key) and not Input.ctrl()) and not is_repeat then
    	Assets.stopAndPlaySound("ui_select")
		love.system.openURL("file://"..love.filesystem.getSaveDirectory().."/mods")
    elseif Input.ctrl() and key == "f5" then
		-- Ctrl+Alt+f<n> is VTY-switching on Linux,
		-- so we MUST provide Shift as an alternative.
    	local force = Input.alt() or Input.shift()
    	self:reloadMods(function()
    		self:buildDLCList(force)
    	end)
    elseif Input.ctrl() and key == "u" then
    	Assets.stopAndPlaySound("ui_select")
    	self.box_mode = self.box_mode == "menu" and "ui" or "menu"
    elseif Input.is("down", key) then
    	self.list:selectDown(is_repeat)
    elseif Input.is("up", key) then
    	self.list:selectUp(is_repeat)
    end
end

function MainMenuDLC:drawMain()
	local shader = Kristal.Shaders["ColorGradient"]

    -- modbutton.lua
    local function drawCoolRectangle(x, y, w, h, color)
	    -- Make sure the line is a single pixel wide
	    love.graphics.setLineWidth(1)
	    love.graphics.setLineStyle("rough")
	    -- Set the color if set
	    local old_color
	    if color then
	    	old_color = {love.graphics.getColor()}
	    	local r, g, b, a = unpack(color)
	    	Draw.setColor(r*0.9, g*0.9, b*1.0, a)
	    end
	    -- Draw the rectangles
	    love.graphics.rectangle("line", x, y, w + 1, h + 1)
	    -- Increase the width and height by one instead of two to produce the broken effect
	    love.graphics.rectangle("line", x - 1, y - 1, w + 2, h + 2)
	    love.graphics.rectangle("line", x - 2, y - 2, w + 5, h + 5)
	    -- Here too
	    love.graphics.rectangle("line", x - 3, y - 3, w + 6, h + 6)

	    -- Reset the color to the previous one
	    if color then
	    	Draw.setColor(old_color)
	    end
	end

	local function getBorder()
    	return self.left[1]:getWidth()*2, self.top[1]:getHeight()*2
	end

	local function drawUIBorders(x, y, width, height)
		local speed = 10

		self.left_frame   = ((self.left_frame   + (DTMULT / speed)) - 1) % #self.left   + 1
    	self.top_frame    = ((self.top_frame    + (DTMULT / speed)) - 1) % #self.top    + 1
    	self.corner_frame = ((self.corner_frame + (DTMULT / speed)) - 1) % #self.corner + 1

    	local left_width  = self.left[1]:getWidth()
    	local left_height = self.left[1]:getHeight()
    	local top_width   = self.top[1]:getWidth()
    	local top_height  = self.top[1]:getHeight()

    	local o_color = {love.graphics.getColor()}
    	local r, g, b, a = unpack(COLORS.white)
	    Draw.setColor(r*0.9, g*0.9, b*1.0, a)

    	Draw.draw(self.left[math.floor(self.left_frame)], x, y, 0, 2, height / left_height, left_width, 0)
	    Draw.draw(self.left[math.floor(self.left_frame)], x+width, y, math.pi, 2, height / left_height, left_width, left_height)

    	Draw.draw(self.top[math.floor(self.top_frame)], x, y, 0, width / top_width, 2, 0, top_height)
    	Draw.draw(self.top[math.floor(self.top_frame)], x, y+height, math.pi, width / top_width, 2, top_width, top_height)

    	for i = 1, 4 do
	        local cx, cy = self.corners[i][1] * width, self.corners[i][2] * height
	        local sprite = self.corner[math.floor(self.corner_frame)]
	        local width  = 2 * ((self.corners[i][1] * 2) - 1) * -1
	        local height = 2 * ((self.corners[i][2] * 2) - 1) * -1
	        local offset_x, offset_y = 18*(self.corners[i][1]==0 and 1 or -1), 18*(self.corners[i][2]==0 and 1 or -1)
	        Draw.draw(sprite, x+cx+offset_x, y+cy+offset_y, 0, width, height, sprite:getWidth(), sprite:getHeight())
	    end

	    Draw.setColor(o_color)
	end

	local drawBox = function() end
	if self.box_mode == "menu" then
		drawBox = drawCoolRectangle
	elseif self.box_mode == "ui" then
		drawBox = drawUIBorders
	end

    --[[Draw.setColor(COLORS.white)
	Draw.printShadow("Work In Progress!", 0, 115 + 30, 2, "center", 640)
	Draw.printShadow("Come back later!", 0, 115 + 30*2, 2, "center", 640)

	Draw.printShadow("Press "..Input.getText("confirm").." to open the DLC folder.", 0, 115 + 30*4, 2, "center", 640)
	Draw.printShadow("Press "..Input.getText("cancel").." to return", 0, 115 + 30*5, 2, "center", 640)]]

	local r, g, b = unpack(COLORS.black)
	Draw.setColor(r, g, b, 0.5)
	Draw.pushShader(shader, {from={1, 1, 1, 1}, to={1, 1, 1, 0}, screenHeight=SCREEN_HEIGHT})
	Draw.rectangle("fill", 10, 48, 280, SCREEN_HEIGHT-48-10)
	Draw.popShader()
	drawBox(10, 48, 280, SCREEN_HEIGHT-48-10, COLORS.white)

	Draw.rectangle("fill", 310, 48, 320, 240)
	local id = self.list:getSelectedId()
	if self.images.preview[id] then
		Draw.setColor(1, 1, 1, 1)
		Draw.draw(self.images.preview[id], 310, 48)
		Draw.setColor(r, g, b, 0.5)
	end
	drawBox(310, 48, 320, 240, COLORS.white)

	Draw.rectangle("fill", 310, 240+48+10, 320, SCREEN_HEIGHT-(240+48+10)-10)

	love.graphics.setFont(self.font)
	Draw.setColor(COLORS.white)

	local mod = self.list:getSelectedMod()
	if mod then
		local top_rect_y = 240+48+10
		love.graphics.print(mod.name.. " "..mod.version, 315, top_rect_y+5)
		love.graphics.print("Creator: "..(mod.creator or (mod.repo_data and mod.repo_data.owner and mod.repo_data.owner or "Unknown") or "Unknown"), 315, top_rect_y+16+5)

		local desc = mod.description or mod.subtitle or ""
		love.graphics.printf(
			"Description: "..desc,
			315,
			top_rect_y+40,
			320-5
		)

		local bottom_rect_y = 310+SCREEN_HEIGHT-(240+48+10)-10
		local d_text = Input.getText("confirm").." "
		if Kristal.Mods.getMod(id) then
			d_text = d_text.."Delete"
		elseif mod.repo_data then
			d_text = d_text.."Download"
		else
			d_text = ""
		end
		love.graphics.print(d_text, 315, bottom_rect_y-32)

		local f_text = Input.getText("menu").." Open DLC Folder"
		local width = self.font:getWidth(f_text)+5
		love.graphics.print(f_text, 310+320-width, bottom_rect_y-32)
	end

	drawBox(310, 240+48+10, 320, SCREEN_HEIGHT-(240+48+10)-10, COLORS.white)
end

-- DOWNLOAD
function MainMenuDLC:onEnterDownload()
	if self.list then
        self.list.active = false
        self.list.visible = false
    end
end

function MainMenuDLC:updateDownload()
	if not self.send_request then
		if self.loading_queue_index > 0 then
			self.send_request = true
			local data = self.loading_list[self.loading_queue_index]

			local owner = data.owner
			local repo = data.repo

			---------------
			--- CONTENT ---
			---------------
			if data.contents and #data.contents>0 then
				if self.content_index > #data.contents then
					print("Downloading done!")
					self.loading_queue_index = self.loading_queue_index - 1
					self.content_index = 1
					self.temp_content = nil
					self.send_request = false
					return
				end
				print("Downloading content for "..owner.."'s repo "..repo)
				self:handleContentDownload(data, self.content_index)
			end

			--------------
			--- COMMIT ---
			--------------
			-- TODO

			---------------
			--- ZIPBALL ---
			---------------
			if data.zipball then
				print("Downloading zip of "..owner.."'s repo "..repo)
				self:handleZipDownload(data)
				self.loading_queue_index = 0
			end
		else
			self.loading_dlcs = false
			love.filesystem.write("cache/dlc_data.json", JSON.encode(Kristal.Mods.dlc_data))
			if self.loading_callback then
				self:loading_callback()
				self.loading_callback = nil
			end
			Input.clear("confirm", true)
			self.loading_list = {}
			self.loading_queue_index = 0
			self.content_index = 0
			if #self.loading_errors > 0 then
				self:setState("ERROR")
			else
				self:setState("MAIN")
			end
		end
	end
end

function MainMenuDLC:drawDownload()
	Draw.setColor(COLORS.white)
	Draw.printShadow("Downloading data... "..Utils.round(100-(self.loading_queue_index*100/#self.loading_list)).."%", 0, (SCREEN_HEIGHT/2)-15, 2, "center", 640)

	Draw.setColor(COLORS.silver)
	Draw.rectangle("fill", 170, (SCREEN_HEIGHT/2)+20, 250, 20)
	Draw.setColor(COLORS.green)
	Draw.rectangle("fill", 170, (SCREEN_HEIGHT/2)+20, 250-(250*self.loading_queue_index/#self.loading_list), 20)

	Draw.setColor(COLORS.white)
	if self.loading_queue_index > 0 then
		local data = self.loading_list[self.loading_queue_index]
		Draw.printShadow("Getting data from\n"..data.owner.."'s "..data.repo, 0, (SCREEN_HEIGHT/2)+45, 2, "center", 640)
	end
end

--ERROR
function MainMenuDLC:onEnterError()
	if self.list then
        self.list.active = false
        self.list.visible = false
    end
end

function MainMenuDLC:onLeaveError()
	if self.list then
        self.list.active = true
        self.list.visible = true
    end
end

function MainMenuDLC:onKeyPressedError(key, is_repeat)
	if Input.isConfirm(key) then
		self.loading_errors = {}
		self:setState("MAIN")
	end
end

function MainMenuDLC:drawError()
	Draw.printShadow("The following DLCs encountered an error during download:", 0, 48, 2, "center", 640)

	local y = 48*3
	for i,error in ipairs(self.loading_errors) do
		Draw.printShadow(string.format("%s's %q: %i - %s", error.owner, error.repo, error.response, error.message), 0, y, 2, "center", 640)
		y = y + 48
	end
end

------------------------------------
--- Miscellanous functions
------------------------------------

-- Is the DLC already installed or are we using bits of data downloaded from Github?
function MainMenuDLC:isModLocal(id)
	return Kristal.Mods.getMod(id) ~= nil
end

-- Handles what to do with mod.json once downloaded
function MainMenuDLC:handleDataFile(body)
	local data = JSON.decode(body)
	local content = JSON.decode(Utils.decodeBase64(data.content))
	Kristal.Mods.dlc_data[content.id] = content
	Kristal.Mods.dlc_data[content.id].repo_data = {
		owner=self.loading_list[self.loading_queue_index].owner,
		repo=self.loading_list[self.loading_queue_index].repo
	}
	return Kristal.Mods.dlc_data[content.id]
end

-- Handles what to do with images files once downloaded
function MainMenuDLC:handleImageFile(body, filename, data)
	local name = "cache/"..filename..".png"
	if not data then
		Kristal.Console:warn("No data given! Was the "..filename.." downloaded before the data?")
		local i = 1
		while true do
			if not love.filesystem.getInfo("cache/"..filename..i..".png") then
				name = "cache/"..filename..i..".png"
				break
			else
				i = i + 1
			end
		end
	else
		name = "cache/"..filename.."-"..data.id..".png"
		Kristal.Mods.dlc_data[data.id][filename] = name
	end
	love.filesystem.write(name, body)
	self.images[filename][data.id] = love.graphics.newImage(love.data.newByteData(body))
end

function MainMenuDLC:handleError(owner, repo, message, response)
	table.insert(self.loading_errors, {
		owner=owner,
		repo=repo,
		response=response or "unknown",
		message=message
	})
end

function MainMenuDLC:handleContentDownload(data, index)
	local content = data.contents
	local file = content[index]
	local link = "https://api.github.com/repos/"..data.owner.."/"..data.repo.."/contents/"..file
	local headers
	if file:find(".png") then headers = {Accept="application/vnd.github.v3.raw"} end


	local ok = Kristal.fetch(link, {
		headers=headers,
		callback=function(res, body, headers)
			if res == 200 then
				if file == "mod.json" then
					self.temp_content = self:handleDataFile(body)
				elseif file:find(".png") then
					local name = file:sub(1, file:find(".png")-1)
					self:handleImageFile(body, name, self.temp_content)
				end
			else
				self:handleError(data.owner, data.repo, "An error occured when downloading "..file..": "..JSON.decode(body).message, res)
			end
			self.send_request = false
			self.content_index = self.content_index + 1
		end
	})
	if not ok then
		self:handleError(data.owner, data.repo, "The fetching request failed. Is HTTPS available?", nil)
		self.content_index = self.content_index + 1
		self.send_request = false
	end
end

function MainMenuDLC:handleZipDownload(data)
	local link = "https://api.github.com/repos/"..data.owner.."/"..data.repo.."/zipball"

	local ok = Kristal.fetch(link, {
		headers={Accept="application/vnd.github.v3.raw"},
		callback = function(res, body, headers)
			if res == 200 then
				print("Writing zip to disk...")
				local name = data.repo..".zip"
				love.filesystem.write("mods/"..name, body)

				extractor.extractZIP("mods/"..name, "mods", true, function()
					self.send_request = false
					self.loading_callback = function()
						for i,dlc in ipairs(love.filesystem.getDirectoryItems("mods")) do
							local s, _ = dlc:find(data.repo)
							if s and s>1 then
								local path = love.filesystem.getSaveDirectory().."/mods"
								
								local old_name = dlc
								local new_name = data.repo

								local command = "mv \""..path.."/"..old_name.."\" \""..path.."/"..new_name.."\""
								if love.system.getOS() == "Windows" then
									command = "cd /d \""..path.."\" && ren \""..old_name.."\" \""..new_name.."\""
								end
								print("Running command: "..command)

								os.execute(command)
							end
						end
						self:reloadMods(function()
    						self:buildDLCList(false)
    					end)
					end
				end)
			else
				self.send_request = false
				self:handleError(data.owner, data.repo, JSON.decode(body).message, nil)
			end
		end
	})
	if not ok then
		self:handleError(data.owner, data.repo, "The fetching request failed. Is HTTPS available?", nil)
		self.content_index = self.content_index + 1
		self.send_request = false
	end
end

function MainMenuDLC:setState(state, ...)
	self.state_manager:setState(state, ...)
end

function MainMenuDLC:getState()
	return self.state_manager.state
end

function MainMenuDLC:checkForNewDLCs()

	local function inGitList(owner, repo)
		if not GITHUB_REPOS[owner] then return false end

		for i,v in ipairs(GITHUB_REPOS[owner]) do
			if v == repo then
				return true
			end
		end
		return false
	end

	local new_dlcs = {}

	for id,data in pairs(Kristal.Mods.dlc_data) do
		if not data["local"] and not inGitList(data.repo_data.owner, data.repo_data.repo) then
			if not new_dlcs[data.repo_data.owner] then
				new_dlcs[data.repo_data.owner] = {}
			end
			table.insert(new_dlcs[data.repo_data.owner], data.repo_data.repo)
		end
	end
	return #new_dlcs>0, new_dlcs
end

function MainMenuDLC:REALbuildDLCList()
	local dlcs = {}
	for id,mod in pairs(Kristal.Mods.dlc_data) do
		if not mod.id then
			mod.id = id
		end
		if not mod.plugin_path then
			table.insert(dlcs, mod)
		end
	end

	table.sort(dlcs, function(a, b)
		local a_mod = Kristal.Mods.getMod(a.id)
		local b_mod = Kristal.Mods.getMod(b.id)
		return (
			(a_mod and not b_mod)
			or (a_mod == b_mod and a.name < b.name)
		)
	end)

	for i,mod in ipairs(dlcs) do
		local button = DLCButton(mod.name or mod.id, 424, 62, mod)
        self.list:addMod(button)

        if self:isModLocal(mod.id) then
	        local path = Kristal.Mods.getMod(mod.id).path
	        if not self.images.preview[mod.id] and love.filesystem.getInfo(path.."/preview.png") then
	        	self.images.preview[mod.id] = love.graphics.newImage(path.."/preview.png")
	        end
	        if not self.images.banner[mod.id] then
	        	if love.filesystem.getInfo(path.."/banner.png") then
	        		self.images.banner[mod.id] = love.graphics.newImage(path.."/banner.png")
	        	elseif love.filesystem.getInfo(path.."/button.png") then -- ??? Gonna have to make sure which one is the one we want to go with
	        		self.images.banner[mod.id] = love.graphics.newImage(path.."/button.png")
	        	end
	        end
	    end

        if mod.preview and not self.images.preview[mod.id] then
        	self.images.preview[mod.id] = love.graphics.newImage(mod.preview)
        end
        button.button_texture = self.images.banner[mod.id]
        if Kristal.Mods.getMod(mod.id) then
        	table.insert(self.installed_dlcs, mod.id)
        end
	end
end

function MainMenuDLC:reloadMods(callback)
    if MOD_LOADING then return end
    MOD_LOADING = true

    Kristal.Mods.clear()
	Kristal.loadAssets("", "plugins", "")
    Kristal.loadAssets("", "mods", "", function()
        --[[if #Kristal.Mods.failed_mods > 0 then
            self.menu:setState("MODERROR")
        end

        self.loading_mods = false

        Kristal.setDesiredWindowTitleAndIcon()
        self:buildModList()]]
        MOD_LOADING = false
        self.menu:buildInstalledDLCsString()
        if callback then
        	callback()
        end
    end)
end

function MainMenuDLC:buildDLCList(reset_cache)
	self.loading_list = {}

	local url_list = GITHUB_REPOS

	if not self.list then
		self.list = ModList(10, 48+4, 280, SCREEN_HEIGHT-(48-4)-10)
		self.list.layer = 50
    	self.menu.stage:addChild(self.list)
    else
    	self.list:clearMods()
    end

    if reset_cache then
    	local function recursivelyDelete(item)
	        if love.filesystem.getInfo( item , "directory" ) then
	            for _, child in ipairs( love.filesystem.getDirectoryItems( item )) do
	                recursivelyDelete( item .. '/' .. child )
	                love.filesystem.remove( item .. '/' .. child )
	            end
	        elseif love.filesystem.getInfo( item ) then
	            love.filesystem.remove( item )
	        end
	        --love.filesystem.remove( item )
	    end
    	recursivelyDelete('cache')
    	Kristal.Mods.dlc_data = {}
    else
    	--print("Try to load cache")
    	if not love.filesystem.getInfo("cache", "directory") then
    		--print("Creating cache folder")
    		love.filesystem.createDirectory("cache")
    	end
    	if love.filesystem.getInfo("cache/dlc_data.json") then
    		--print("Cache found, loading...")
    		for i,mod in ipairs(Kristal.Mods.getMods()) do
    			if not Utils.containsValue({"dpr_main", "dpr_light"}, mod.id) then
    				Kristal.Mods.dlc_data[mod.id] = mod
    				Kristal.Mods.dlc_data[mod.id]['local'] = true
    			end
    		end
    		local data = JSON.decode(love.filesystem.read("cache/dlc_data.json"))
    		for i,mod in pairs(data) do
    			if not Kristal.Mods.dlc_data[mod.id] then
    				Kristal.Mods.dlc_data[mod.id] = mod
    			end
    		end

    		-- TODO: remake that better
    		local new, list = self:checkForNewDLCs()
    		if not new then
    			self:REALbuildDLCList()
    			return
    		end
    		--print("New DLCs found")
    		url_list = list
    	end
    end

    if not HTTPS_AVAILABLE then
    	Kristal.Console:warn("HTTPS is not available but files need to be downloaded!")
    	return
    end

    -- Put all the repos we're gonna get data from in a list for update
    for owner,repos in pairs(url_list) do
    	for i,repo in ipairs(repos) do
    		print("Add repo "..repo)
    		table.insert(self.loading_list, {
    			owner=owner,
    			repo=repo,
    			contents={"mod.json", "preview.png", "banner.png"}
    		})
    		self.loading_queue_index = self.loading_queue_index + 1
    	end
    end

    if self.loading_queue_index > 0 then
    	self.loading_callback = self.REALbuildDLCList

    	self:setState("DOWNLOAD")
    else
    	self:REALbuildDLCList()
    	self:setState("MAIN")
    end

	--[[Kristal.fetch(
		"https://api.github.com/repos/Simbel0/Dark-Place/contents/mod.json",
	{
		callback=function(a, b, c)
			print("response:"..a)
			print("body:"..b)
			BODY=b
			print("headers:"..c)
		end
	}
	)]]
end

function MainMenuDLC:handleMod(id)
	print("Handle "..id)
	local data = Kristal.Mods.dlc_data[id]
	if not Kristal.Mods.getMod(id) then
		table.insert(self.loading_list, {
			owner=data.repo_data.owner,
			repo=data.repo_data.repo,
			zipball=true
		})
		self.loading_queue_index = self.loading_queue_index + 1
		self:setState("DOWNLOAD")
	else
		local function recursivelyDelete(item)
	        if love.filesystem.getInfo( item , "directory" ) then
	            for _, child in ipairs( love.filesystem.getDirectoryItems( item )) do
	                recursivelyDelete( item .. '/' .. child )
	                love.filesystem.remove( item .. '/' .. child )
	            end
	        elseif love.filesystem.getInfo( item ) then
	            love.filesystem.remove( item )
	        end
	        love.filesystem.remove( item )
	    end
    	if love.filesystem.getInfo((Kristal.Mods.getMod(id).path).."/.git") then
            Assets.playSound("ui_cant_select")
            return
        end
    	recursivelyDelete(Kristal.Mods.getMod(id).path)
		self:reloadMods(function()
			self:buildDLCList(false)
		end)
	end
end

return MainMenuDLC
