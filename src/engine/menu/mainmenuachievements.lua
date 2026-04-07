local MainMenuAch, super = Class(StateClass)

function MainMenuAch:init(menu)
    self.menu = menu
    
    self.pages = {}
    self.achievements_data = {}
    
    self.selected_page = 1
    self.offset = 0
    
    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
    self.ui_cancel_small = Assets.newSound("ui_cancel_small")
	
	self.up_sprite = Assets.getTexture("ui/page_arrow_up")
	self.down_sprite = Assets.getTexture("ui/page_arrow_down")
	self.left_sprite = Assets.getTexture("ui/flat_arrow_left")
	self.right_sprite = Assets.getTexture("ui/flat_arrow_right")
end

function MainMenuAch:update()
    self.menu.kristal_stage_title.visible = false
    
    if Input.pressed("cancel") then
        self.menu:setState("SUBTITLE")
        self.menu.subtitle:selectOption("achievements")
	end
	
	if Input.pressed("up") then
		if self.offset > 0 then
			self.offset = self.offset - 1
			self.ui_move:stop()
			self.ui_move:play()
		end
	end
	
	if Input.pressed("down") then
		if self.offset < #self.pages[self.selected_page].achievements - 3 then
			self.offset = self.offset + 1
			self.ui_move:stop()
			self.ui_move:play()
		end
	end
    
    local old_page = self.selected_page
	
	if Input.pressed("left") then
        self.selected_page = self.selected_page - 1
        if self.selected_page == 0 then
            self.selected_page = #self.pages
        end
	end
	
	if Input.pressed("right") then
        self.selected_page = self.selected_page + 1
        if self.selected_page == #self.pages + 1 then
            self.selected_page = 1
        end
	end
    
    if old_page ~= self.selected_page then
        self.ui_move:stop()
		self.ui_move:play()
    end
end

function MainMenuAch:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

-------------------------------------------------------------------------------
-- Callbacks
-------------------------------------------------------------------------------

function MainMenuAch:onEnter(old_state)
    self.pages = {}
    
    self.selected_page = 1
    self.offset = 0
    
    if love.filesystem.getInfo("saves/achievements.json") then
        self.achievements_data = JSON.decode(love.filesystem.read("saves/achievements.json"))
    end
    
    local current_order = {"dpr_main", "dark_future_dlc"}
    
    local mods = Kristal.Mods.getMods()
    
    for i,item in ipairs(current_order) do
        for i2,mod in ipairs(mods) do
            if mod.id == item then
                self:registerModAchievements(mod)
            end
        end
    end
    
    for i,mod in ipairs(mods) do
        if not TableUtils.contains(current_order, mod.id) then
            self:registerModAchievements(mod)
        end
    end
    
    self.menu.heart_target_x = 320
    self.menu.heart_target_y = 80
end

function MainMenuAch:registerModAchievements(mod)
    if love.filesystem.getInfo(mod.path .. "/achievements.lua") then
        local chunk = love.filesystem.load(mod.path .. "/achievements.lua")
        success, result = pcall(chunk, mod.path)
        if success then
            local data = {
                name = string.upper(mod.name)
            }
            
            local achievements = {}
            local hidden = 0
            
            for i,ach in ipairs(result) do
                if self.achievements_data[mod.id] and self.achievements_data[mod.id][ach.id] then
                    Kristal.Console:log("We have data for " .. ach.name .. "!")
                    ach.data = self.achievements_data[mod.id][ach.id]
                else
                    Kristal.Console:log("We don't have data for " .. ach.name .. "...")
                    ach.data = {
                        progress = 0,
                        earned = false
                    }
                end
                
                if ach.border then
                    if love.filesystem.getInfo(mod.path .. "/assets/sprites/achievements/frames/" .. ach.border .. ".png") then
                        ach.border = love.graphics.newImage(mod.path .. "/assets/sprites/achievements/frames/" .. ach.border .. ".png")
                    elseif love.filesystem.getInfo("assets/sprites/achievements/frames/" .. ach.border .. ".png") then
                        ach.border = love.graphics.newImage("assets/sprites/achievements/frames/" .. ach.border .. ".png")
                    else
                        ach.border = love.graphics.newImage("assets/sprites/achievements/frames/Common.png")
                    end
                else
                    ach.border = love.graphics.newImage("assets/sprites/achievements/frames/Common.png")
                end
                
                if ach.icon then
                    if love.filesystem.getInfo(mod.path .. "/assets/sprites/achievements/" .. ach.icon .. ".png") then
                        ach.icon = love.graphics.newImage(mod.path .. "/assets/sprites/achievements/" .. ach.icon .. ".png")
                    else
                        ach.icon = love.graphics.newImage("assets/sprites/achievements/placeholder.png")
                    end
                else
                    ach.icon = love.graphics.newImage("assets/sprites/achievements/placeholder.png")
                end
                
                if not (ach.hidden and not ach.data.earned) then
                    table.insert(achievements, ach)
                elseif ach.hidden then
                    hidden = hidden + 1
                end
            end
            
            data.achievements = achievements
            data.hidden = hidden
            
            table.insert(self.pages, data)
        else
            print(result)
        end
    end
end

function MainMenuAch:onKeyPressed(key, is_repeat)

end

function MainMenuAch:mask_string(str)
	local result = ""
	for i = 1, #str do
		local char = str:sub(i, i)
		if char == " " then
			result = result .. " "
		else
			result = result .. "?"
		end
	end
	return result
end

function MainMenuAch:draw()
    love.graphics.setFont(Assets.getFont("main"))
    if #self.pages == 0 then
        love.graphics.draw(love.graphics.newImage("assets/sprites/kristal/no_achievements.png"), 200, 120)
    else
        Draw.setColor(COLORS.silver)
        
        love.graphics.printf(self.pages[self.selected_page].name, 0, 94, 640, "center")
        
        if #self.pages > 1 then
            love.graphics.setColor(1, 1, 1)
            
            local leng = Assets.getFont("main"):getWidth(self.pages[self.selected_page].name)/2
            
            love.graphics.draw(self.left_sprite, 290 - leng, 100, 0, 2, 2)
            
            love.graphics.draw(self.right_sprite, 330 + leng, 100, 0, 2, 2)
        end
        
        love.graphics.setFont(Assets.getFont("main", 16))
        
        for i=1, math.min(#self.pages[self.selected_page].achievements, 3) do
            local k = i + self.offset
            local ach = self.pages[self.selected_page].achievements[k]
            
            local y = 60 + 80 * i
            
            if ach then
                love.graphics.setColor(1, 1, 1)
                local raritysprite = ach.border
                love.graphics.draw(raritysprite, 30, y, 0, 2, 2)
                
                if not ach.data.earned then
                    if ach.steps then
                        local completion_percent = 0
                        if ach.data and ach.data.progress then
                            completion_percent = ach.data.progress / ach.steps
                        end

                        love.graphics.setColor(self.progress_color_bg)
                        love.graphics.rectangle("fill", 120, y + 60, 150, 12)

                        love.graphics.setColor(self.progress_color)
                        love.graphics.rectangle("fill", 120, y + 60, (math.min(1, completion_percent) * 150), 12)
                        love.graphics.setColor(0.5, 0.5, 0.5)
                        local completion_percent_2 = math.min(100, completion_percent * 100)
                        love.graphics.print(math.floor(completion_percent_2).."%", 275, y + 57)
                    end
                    love.graphics.setColor(0.5, 0.5, 0.5)
                    local name = ach.name
                    if type(name) == "function" then
                        name = name(ach)
                    end
                    name = self:mask_string(name)
                    love.graphics.print(name, 120, y + 5)
                    if ach.hint and not ach.hidden then
                        if type(ach.hint) == "function" then
                            love.graphics.printf(ach.hint(ach), 120, y + 25, 400)
                        else
                            love.graphics.printf(ach.hint, 120, y + 25, 400)
                        end
                    end
                else
                    if ach.steps then
                        local completion_percent = 0
                        if ach.data and ach.data.progress then
                            completion_percent = ach.data.progress / ach.steps
                        end

                        love.graphics.setColor(self.progress_color_bg)
                        love.graphics.rectangle("fill", 120, y + 60, 150, 12)
                        
                        love.graphics.setColor(1, 205/255, 0)

                        love.graphics.rectangle("fill", 120, y + 60, (math.min(1, completion_percent) * 150), 12)
                        local completion_percent_2 = math.min(100, completion_percent * 100)
                        love.graphics.print(math.floor(completion_percent_2).."%", 275, y + 57)
                    end
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.draw(ach.icon, 38, y + 8, 0, 2, 2)
                    local name = ach.name
                    if type(name) == "function" then
                        name = name(ach)
                    end
                    love.graphics.print(name, 120, y + 5)
                    if ach.desc then
                        if type(ach.desc) == "function" then
                            love.graphics.printf(ach.desc(ach), 120, y + 25, 400)
                        else
                            love.graphics.printf(ach.desc, 120, y + 25, 400)
                        end
                    end
                end
            end
        end
        
        love.graphics.setColor(1, 1, 1)
        
        if self.offset > 0 then
            love.graphics.draw(self.up_sprite, 560, 120, 0, 1, 1)
        end
        if self.offset < #self.pages[self.selected_page].achievements - 3 then
            love.graphics.draw(self.down_sprite, 560, 360, 0, 1, 1)
        end
        
        if self.pages[self.selected_page].hidden == 1 then
			love.graphics.printf("And 1 hidden achievement", 0, 400, 640, "center")
		elseif self.pages[self.selected_page].hidden > 1 then
			love.graphics.printf("And " .. self.pages[self.selected_page].hidden .. " hidden achievements", 0, 400, 640, "center")
		end
    end
end

return MainMenuAch
