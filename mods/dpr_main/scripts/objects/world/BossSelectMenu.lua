---@class BossSelectMenu : Object
---@overload fun(...) : BossSelectMenu
local BossSelectMenu, super = Class(Object)

function BossSelectMenu:init()
    super.init(self, 0, 0, 540, 360)

    self.parallax_x = 0
    self.parallax_y = 0
    self.layer = WORLD_LAYERS["ui"]
    self.draw_children_below = 0

    self.box = UIBox(50, 60, self.width, self.height)
    self.box.layer = -1
    self.box.debug_select = false
    self:addChild(self.box)

    ---@type love.Font
    self.font = Assets.getFont("main")
    self.font_2 = Assets.getFont("plain")

    self.heart = Sprite("player/heart_menu")
    self.heart:setOrigin(0.5, 0.5)
    self.heart:setScale(2)
    self.heart:setColor(Game:getSoulColor())
    self.heart.layer = 1
    self.heart.x = 66
    self:addChild(self.heart)

    self.none_text = "---"
    self.none_preview = "default"
    self.boss_entry = {
        name = nil,
        encounter = nil,
        difficulty = {nil, nil, nil, nil, nil}, -- TODO: find a way to use numbers instead doing of this.
        preview = nil,
        description = nil,
        locked_description = nil,
        health = nil,
        attack = nil,
        defense = nil,
        flag = nil,
    }

    self.bosses = modRequire("scripts.boss_list")

    self.preview_cache = {}
    self.preview_cache[self.none_preview] = Assets.getTexture("ui/boss_previews/"..self.none_preview)
    for _,boss in ipairs(self.bosses) do
        if Game:getFlag(boss.flag) == true then
            boss.locked = false
        else
            boss.locked = true
        end

        if boss.preview and not self.preview_cache[boss.preview] then
            self.preview_cache[boss.preview] = Assets.getTexture("ui/boss_previews/"..boss.preview)
        end
    end

    self.pages = {}
    self.page_index = 1
    self.bosses_per_page = 7
    self.selected_index = {}
    for page = 1, math.ceil(#self.bosses / self.bosses_per_page) do
        local start_index = 1 + (page-1) * self.bosses_per_page
        self.pages[page] = {unpack(self.bosses, start_index, math.min(start_index + self.bosses_per_page - 1, #self.bosses))}
        self.selected_index[page] = 1
    end

	self.heart_target_x = 66
    self.heart_target_y = self:calculateHeartTargetY()
    self.heart.y = self.heart_target_y
    self.state = "SELECTING" -- "SELECTING", "CHOICE"
	self.choice_selection = 1
end

function BossSelectMenu:draw()

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.font)
    love.graphics.printf("BOSSES", 0 + 50, -17 + 60, self.width, "center")
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", -16 + 50, 20 + 60, self.width+32, 1)

    local page = self.pages[self.page_index]

    love.graphics.setLineWidth(1)
    -- draw the first line
    love.graphics.setColor(0, 0.4, 0)
    love.graphics.rectangle("line", 2 + 50, 40 + 60, 240, 1)

    for i = 1, self.bosses_per_page do
        local boss = page[i] or self.boss_entry
        local name = boss.name or self.none_text
        if boss.locked then 
            name = string.rep("?", utf8.len(name))
        end
        love.graphics.setColor(1, 1, 1)

        if not boss.encounter or boss.locked then
            love.graphics.setColor(0.5, 0.5, 0.5)
        end

        local scale_x = math.min(math.floor(196 / self.font:getWidth(name) * 100) / 100, 1)
        love.graphics.print(name, 40 + 50, 40 + 40 * (i - 1) + 3 + 60, 0, scale_x, 1)
        love.graphics.setColor(1, 1, 1)

        love.graphics.setColor(0, 0.4, 0)
        love.graphics.rectangle("line", 2 + 50, 40 + 40 * i + 60, 240, 1)
    end
    love.graphics.setLineWidth(2)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.setFont(self.font_2)
    love.graphics.printf("Page "..self.page_index.."/"..#self.pages, -16 + 50, (43 + 40 * (self.bosses_per_page - 1)) + 60 + 60, 276, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.font)

    local info_area_sep_padding = 40
    local info_area_sep_a = (self.width - 300 + info_area_sep_padding)/info_area_sep_padding
    love.graphics.setColor(1, 1, 1, info_area_sep_a)
    love.graphics.rectangle("line", 300 - info_area_sep_padding + 50, 20 + 60, 1, 356)
    love.graphics.setColor(1, 1, 1)

    local boss = page[self.selected_index[self.page_index]] or self.boss_entry

    -- preview
    love.graphics.setColor(1, 1, 1)
    local preview_path = boss.preview or self.none_preview
    if not boss.encounter or boss.locked then
        preview_path = self.none_preview
    end
    local preview = self.preview_cache[preview_path] or self.preview_cache[self.none_preview]
    love.graphics.draw(preview, 410 + 50, 121 + 60, 0, 1, 1, preview:getWidth()/2, preview:getHeight()/2)

    love.graphics.setColor(1, 1, 1)

    -- description
    local description_font = self.font
    local description_scale = 0.5

    love.graphics.setFont(description_font)
    local description_w = 260 / description_scale
    if not boss.locked then
        local description = string.format(
            "%s",
            boss.description or self.none_text
        )
        local _, description_lines = description_font:getWrap(description, description_w)
        love.graphics.printf(description, 280 + 50, 202 + 60, description_w, "left", 0, description_scale, description_scale)
    else
        local description = string.format(
            "%s",
            boss.locked_description or self.none_text
        )
        local _, description_lines = description_font:getWrap(description, description_w)
        love.graphics.printf(description, 280 + 50, 202 + 60, description_w, "left", 0, description_scale, description_scale)
    end

    -- stats
    if not boss.locked then
        local stats_1 = string.format(
            "DIFFICULTY\nATTACK     %s\nDEFENSE   %s",
            boss.attack or self.none_text,
            boss.defense or self.none_text
        )
        local stats_2 = string.format(
            "\nHEALTH   %s\n",
            boss.health or self.none_text
        )
        love.graphics.printf(stats_1, 280 + 50, 262 + 60, description_w, "left", 0, 0.5, 1)
        love.graphics.printf(stats_2, 400 + 50, 262 + 60, description_w, "left", 0, 0.5, 1)
    else
        local stats_1 = string.format(
            "DIFFICULTY\nATTACK     ???\nDEFENSE   ???"
        )
        local stats_2 = string.format(
            "\nHEALTH   ???\n"
        )
        love.graphics.printf(stats_1, 280 + 50, 262 + 60, description_w, "left", 0, 0.5, 1)
        love.graphics.printf(stats_2, 400 + 50, 262 + 60, description_w, "left", 0, 0.5, 1)
    end

    for i = 1, 5 do
        local star = Assets.getFrames("ui/star")
        local star_x = 343 + 24 * i
		
        if not boss.locked and boss.difficulty[i] then
            love.graphics.setColor(1, 1, 1)
            Draw.draw(star[1], star_x + 50, 278 + 60, 0, 2, 2, 5, 4)
        else
            love.graphics.setColor(0.4, 0.4, 0.4)
            Draw.draw(star[2], star_x + 50, 278 + 60, 0, 2, 2, 5, 4)
        end
    end

    if self.state == "CHOICE" then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 379, SCREEN_WIDTH, 101)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(4)
        love.graphics.line(0, 377, SCREEN_WIDTH, 377)

        Draw.setColor(PALETTE["world_text"])
        love.graphics.print("Challenge?", 60, 400)

        if self.choice_selection == 1 then
            Draw.setColor(COLORS.yellow)
        end
        love.graphics.print("Yes", 380, 400)

        if self.choice_selection == 1 then
            Draw.setColor(PALETTE["world_text"])
        else
            Draw.setColor(COLORS.yellow)
        end
        love.graphics.print("No", 480, 400)
    end

    love.graphics.setColor(1, 1, 1)

    super.draw(self)
end

function BossSelectMenu:update()
    local function warpIndex(index)
        return Utils.clampWrap(index, 1, self.bosses_per_page)
    end

    if not OVERLAY_OPEN then
        -- close menu
        if Input.pressed("cancel", false) and not Game.battle then
			if self.state == "CHOICE" then
				self.state = "SELECTING"
			else
				Assets.stopAndPlaySound("ui_cancel_small")
				Game.world:closeMenu()
			end
            return
        end

        -- start fight
        if Input.pressed("confirm", false) and not Game.battle then
            local boss = self.pages[self.page_index][self.selected_index[self.page_index]] or self.boss_entry

            if Game:getFlag(boss.flag) == true then
				if self.state == "CHOICE" then
					if self.choice_selection == 1 then
						Game:encounter(boss.encounter)
						Game.world:closeMenu()
					else
						self.state = "SELECTING"
					end
				else
					self.state = "CHOICE"
				end
            else
                Assets.stopAndPlaySound("ui_cant_select")
            end
        end

        -- page left
        if Input.pressed("left", true) and not Game.battle then
			if self.state == "CHOICE" then
				if self.choice_selection == 1 then
					self.choice_selection = 2
				else
					self.choice_selection = 1
				end
			else
				if #self.pages == 1 then
					Assets.playSound("ui_cant_select")
				else
					Assets.playSound("ui_move")
				end
				self.page_index = self.page_index - 1
			end
        end
        -- page right
        if Input.pressed("right", true) and not Game.battle then
			if self.state == "CHOICE" then
				if self.choice_selection == 1 then
					self.choice_selection = 2
				else
					self.choice_selection = 1
				end
			else
				if #self.pages == 1 then
					Assets.playSound("ui_cant_select")
				else
					Assets.playSound("ui_move")
				end
				self.page_index = self.page_index + 1
			end
        end
        self.page_index = Utils.clampWrap(self.page_index, 1, #self.pages)

        local page = self.pages[self.page_index]
        -- move up
        if Input.pressed("up", true) and not Game.battle and self.state ~= "CHOICE" then
            Assets.playSound("ui_move")
            self.selected_index[self.page_index] = warpIndex(self.selected_index[self.page_index] - 1)
            while not page[self.selected_index[self.page_index]] do
                self.selected_index[self.page_index] = warpIndex(self.selected_index[self.page_index] - 1)
            end
        end
        -- move down
        if Input.pressed("down", true) and not Game.battle and self.state ~= "CHOICE" then
            Assets.playSound("ui_move")
            self.selected_index[self.page_index] = warpIndex(self.selected_index[self.page_index] + 1)
            while not page[self.selected_index[self.page_index]] do
                self.selected_index[self.page_index] = warpIndex(self.selected_index[self.page_index] + 1)
            end
        end


        -- boss rush (commented out as it currently doesn't detect if a boss is locked.)

        --[[if Input.pressed("r") then
            Assets.stopAndPlaySound("ui_select")
            Game.world:closeMenu()
            Game.world:startCutscene(function(cutscene)
                for i, v in ipairs(self.bosses) do
                    cutscene:text("* "..#self.bosses-(i-1).." left to go.[wait:10]\n* Up next: [wait:5]"..v.name..".")
                    cutscene:startEncounter(v.encounter, true)
                    while Game.battle do end
                end
                cutscene:text("* Congratulations![wait:10] You win absolutely nothing!")
            end)
        end]]
    end

    --soul positions
	if self.state == "CHOICE" then
        if self.choice_selection == 1 then
            self.heart_target_x = 358
        else
            self.heart_target_x = 458
        end
        self.heart_target_y = 416
    else
		self.heart_target_x = 66
		self.heart_target_y = self:calculateHeartTargetY()
		if math.abs(self.heart_target_y - self.heart.y) <= 2 then
			self.heart.y = self.heart_target_y
		end	
	end
    self.heart.x = self.heart.x + (self.heart_target_x - self.heart.x) / 2 * DTMULT
    self.heart.y = self.heart.y + (self.heart_target_y - self.heart.y) / 2 * DTMULT
end

function BossSelectMenu:calculateHeartTargetY(i)
    if i == nil then i = self.selected_index[self.page_index] end
    return 120 + 40 * (i - 1)
end

function BossSelectMenu:close()
    Game.world.menu = nil
    self:remove()
end

return BossSelectMenu