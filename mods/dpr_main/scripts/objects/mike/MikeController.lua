local MikeController, super = Class(Object)

function MikeController:init()
    super.init(self)

    self.mic = Mod.mic_controller

    self.draw_children_above = 1
    self.font = Assets.getFont("main")
    
    ------------------------------
    -- Arena-specific variables --
    ------------------------------
    self.heart_sprite = Assets.getTexture("player/heart_dodge")

    --[[
        ARENA GUIDE:
        "WINGBOX" 
        "XSLIDER" 
        "DEFAULT" (Default arena to use)
        "RING" (Unused type)
        "SMALL_RING" (Unused type)
        "YSLIDER" 
        "WALKER" (Used for Pluey)
    ]]
    self.arena_mode = "DEFAULT"
    self.last_arena_mode = self.arena_mode
    self.arena_phase = 0
    --[[
        HAND GUIDE:
        "INACTIVE" 
        "DEFAULT" (Default hand to use)
		"PONGPADDLE"
    ]]
	self.hand_mode = "DEFAULT"
    self.last_hand_mode = self.hand_mode
	self.play_hand_switch_sfx = true
	self.hand_switch_sfx = nil
    self.hand_phase = 0

    self.line_xpos, self.line_ypos = 0, -32 
    self.line_width, self.line_height = 140, 110
    self.line_side = TableUtils.pick{ 1, -1 }

    self.line_x = {}
    self.line_y = {}
    for i = 1, 36 do
		self.line_x[i] = self.line_xpos + (SCREEN_HEIGHT/2)
        self.line_y[i] = self.line_ypos + (SCREEN_WIDTH/2)
    end

    self.circle_width = 120
    self.circle_height = MathUtils.round(self.circle_width * 0.75)
    self.circle_offset = -32

    self.arena_x, self.arena_y = 0, 0
    self.arena_new_x, self.arena_new_y = SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + self.line_ypos
    
    self.arena_size1 = 0
    self.arena_size2 = 31
    self.arena_size3 = 10
    
    self.arena_dir = 270
    self.arena_new_dir = 270
    
    self.wing_angle1 = 180
    self.wing_angle2 = 180
    self.wing_angle3 = 0
    self.wingbox_volume_thereshold = 1
	
	self.walker_speed_x_division = 100
	
	self.arena_speed = 0
	self.arena_direction = 0
	self.arena_friction = 0
	self.arena_speed_x = 0
	self.arena_speed_y = 0
	self.arena_gravity = 0
	self.arena_gravity_direction = 270
    
    self.x_target, self.y_target = 0, 0

    -----------------------------
    -- Maus Hand-specific variables --
    -----------------------------
    Game.battle.draw_children_above = 6453
    
    self.hand = MikeHand(0, 0)
    self.hand.visible = false
    self.hand.layer = 6453
    Game.battle:addChild(self.hand)

    self.__usable = true
    self.hand_x, self.hand_y = 0, 0
    self.hand_dist = 140
    self.hand_xscale, self.hand_yscale = 1, 1
    self.hand_speed = 0
    self.hand_type = 1
    self.hand_shake = 0
    self.hand_act = 0
    self.hand_target = -1
    self.hand_anim = 10
    self.hand_angle = 0
    self.hand_yscale2 = 1
    self.hand_wait = 0

    self.wait = 0
    self.reload = 0
    
    self.allow_sensitivity_adjust = false
    self.left_click_pressed = false
    self.left_click_down = false

    local mx = 100
    local my = 0
    local mwidth = 440
    local mheight = 100
    local ly = my + (mheight / 2) + 32
    self.sensitivity_collider = Hitbox(Game.battle, mx + 86, ly - 30, ((mx + mwidth) - 96) - (mx + 86), (ly - 46) - (ly - 30))

	self.party_heals = { -- TODO: find a better way to do this
		apm = 0,
		berdly = 0,
		bor = 0,
		brenda = 0,
		ceroba = 0,
		ddelta = 0,
		dess = 0,
		hero = 0,
		jamm = 0,
		jerdly = 0,
		kris = 0,
		len = 0,
		mario = 0,
		nell = 0,
		noel = 0,
		noelle = 0,
		osw = 0,
		pauling = 0,
		ralsei = 0,
		susie = 0,
	}

    self.display_fake_arena = false
end

function MikeController:canDisplayFakeArena()
    return self.display_fake_arena
end

function MikeController:getArenaMode()
    return self.arena_mode
end

function MikeController:getHandMode()
    return self.hand_mode
end

local function lengthDirX(length, dir)
    return math.cos(dir) * length
end

local function lengthDirY(length, dir)
    return math.sin(dir) * length
end

local function inverseLerp(from, to, factor)
    if to == from then
        return 0
    end
    return (factor - from) / (to - from)
end

function MikeController:update()
    super.update(self)

    self.left_click_pressed = false
    self.left_click_down = false

    if Kristal.isConsole() then
        if Input.pressed("confirm") then
            self.left_click_pressed = true
        end
        if Input.down("confirm") then
            self.left_click_down = true
        end
    else
        if Input.mousePressed(1) then
            self.left_click_pressed = true
        end
        if Input.mouseDown(1) then
            self.left_click_down = true
        end
    end

    if self:canDisplayFakeArena() then
        local arena = self:getArenaMode()
        local hand = self:getHandMode()

		if math.abs(self.arena_speed) > 0 then
			self.arena_speed_x = lengthDirX(self.arena_speed, -math.rad(self.arena_direction))
			self.arena_speed_y = lengthDirY(self.arena_speed, -math.rad(self.arena_direction))
		end
		self.arena_speed_x = MathUtils.approach(self.arena_speed_x, 0, self.arena_friction * DTMULT)
		self.arena_speed_y = MathUtils.approach(self.arena_speed_y, 0, self.arena_friction * DTMULT)
		self.arena_speed_x = self.arena_speed_x + lengthDirX(self.arena_gravity, -math.rad(self.arena_gravity_direction)) * DTMULT
		self.arena_speed_y = self.arena_speed_y + lengthDirY(self.arena_gravity, -math.rad(self.arena_gravity_direction)) * DTMULT
		self.arena_x = self.arena_x + self.arena_speed_x * DTMULT
		self.arena_y = self.arena_y + self.arena_speed_y * DTMULT

        if arena ~= self.last_arena_mode then
            if arena ~= "DEFAULT" then
				self.line_xpos = 0
				self.line_ypos = -32
                if TableUtils.contains({"YSLIDER"}, arena) then
					self.line_ypos = 0
                    self.arena_x = SCREEN_WIDTH/2
					self.arena_y = 190
                elseif TableUtils.contains({"WINGBOX"}, arena) then
                    self.arena_x = SCREEN_WIDTH/2
                else
                    self.arena_y = (SCREEN_HEIGHT/2) + self.line_ypos
                end
            else
                self.arena_phase = 0
            end
            
            if arena == "WALKER" then
                self.x_target = SCREEN_WIDTH/2
                self.y_target = (SCREEN_HEIGHT/2) - 32
            end
            
            self.circle_width, self.circle_height = 0, 0
			self.arena_speed = 0
			self.arena_direction = 0
			self.arena_friction = 0
			self.arena_speed_x = 0
			self.arena_speed_y = 0
			self.arena_gravity = 0
			self.arena_gravity_direction = 270
            self.arena_size2 = 30
            self.arena_size3 = 13
            self.line_side = TableUtils.pick{ 1, -1 }
            self.line_xpos = 0
            self.hand_speed = 0
            self.last_arena_mode = arena
        end

        if hand ~= self.last_hand_mode then
            if hand ~= "DEFAULT" and hand ~= "INACTIVE" then
				if self.play_hand_switch_sfx then
					self.hand_switch_sfx_pitch = 0.3
					self.hand_switch_sfx = Assets.newSound("power")
					self.hand_switch_sfx:setVolume(1)
					self.hand_switch_sfx:setPitch(0.3)
					self.hand_switch_sfx:play()
					Game.stage.timer:tween(1, self, { hand_switch_sfx_pitch = 1.2 }, "linear")
                end
            end
            
            self.last_hand_mode = hand
        end

		if self.hand_switch_sfx and self.hand_switch_sfx:isPlaying() then
			self.hand_switch_sfx:setPitch(self.hand_switch_sfx_pitch)
		end
		
        if self.arena_phase == 0 then
            self.arena_x = self.arena_x + ((self.arena_new_x - self.arena_x) * 0.25) * DTMULT
            self.arena_y = self.arena_y + ((self.arena_new_y - self.arena_y) * 0.25) * DTMULT
            self.arena_x = MathUtils.approach(self.arena_x, self.arena_new_x, 1 * DTMULT)
            self.arena_y = MathUtils.approach(self.arena_y, self.arena_new_y, 1 * DTMULT)

            if self.arena_x == self.arena_new_x and self.arena_y == self.arena_new_y then
                self.arena_size2 = 30
                self.arena_size3 = 13
                self.arena_phase = 1
                self.arena_mode = "DEFAULT"
            end
        end

        if arena == "WINGBOX" then
            local my_gravity = 1
            local ymax = { 32, 300, 64 }
            self.wait = self.wait - DTMULT
            local new_volume = math.min(12, self.mic.mic_volume / 6)
            
            -- if (room == room_dw_castle_tv_zone_minigame) then
            --     ymax[2] = 340
                
            --     if (i_ex(obj_mike_quiet)) then
            --         my_gravity = 2;
            --     else
            --         my_gravity = 0.25;
            --     end
            -- end
            
            -- if (i_ex(obj_mike_quiet)) then
            --     my_gravity = 2;
            -- end
            
            if self.wait > 0 then
                new_volume = 0
            end
            
            if new_volume > self.wingbox_volume_thereshold then
                self.arena_y = self.arena_y - MathUtils.lerp(1, 11, 1 - (1 - (new_volume - self.wingbox_volume_thereshold) / (12 - self.wingbox_volume_thereshold)) ^ DTMULT)
                self.arena_gravity = 0
                self.arena_speed_y = 0
            else
                self.arena_gravity = my_gravity
                self.arena_speed_y = math.max(self.arena_speed_y, 2)
            end
            
            self.reload = self.reload + DTMULT
            
            if (self.reload > (math.max(1, (100 - self.mic.mic_volume) * 0.1) * 2) and self.mic.mic_volume > (self.wingbox_volume_thereshold * 6)) then
                self.reload = 0
                self.wing_angle1 = 10
                self.wing_angle2 = 270
                self.arena_size2 = 21
            end
            
            self.arena_speed_y = MathUtils.clamp(self.arena_speed_y, -10, 10)
            self.arena_y = math.max(self.arena_y, ymax[1])
            
            if self.arena_y <= ymax[1] then
                self.wait = 1
            end
            
            if self.arena_y > ymax[2] then
                self.arena_speed_y = 0
                self.arena_y = ymax[2]
            end
            
            if self.arena_speed_y > 0 then
                self.wing_angle3 = 90
                self.wing_angle2 = 90
            end
            
            if (self.arena_speed_y == 0 and new_volume <= 1) then
                self.wing_angle3 = 270
                self.wing_angle2 = 270
                self.wing_angle1 = 270
            end
            
            self.wing_angle1 = self.wing_angle1 + ((self.wing_angle2 - self.wing_angle1) * 0.2) * DTMULT
            self.wing_angle2 = self.wing_angle2 + ((self.wing_angle3 - self.wing_angle2) * 0.01) * DTMULT
        end

        if arena == "XSLIDER" then
            local new_volume = math.min(12, self.mic.mic_volume / 8)
            
            if new_volume > 1 then
                self.line_xpos = self.line_xpos + (self.line_side * new_volume) * DTMULT
            end
            
            if (self.line_side == 1 and self.line_xpos >= self.line_width) then
                self.line_side = -1
                self.line_xpos = self.line_width
                self.arena_size2 = 20
                
            elseif (self.line_side == -1 and self.line_xpos <= -self.line_width) then
                self.line_side = 1
                self.line_xpos = -self.line_width
                self.arena_size2 = 20
            end
            
            -- if (room == room_dw_castle_tv_zone_minigame)
            -- {
            --     if (abs(x - scr_mouse_x()) > 60)
            --     {
            --         if (scr_mouse_x() > x)
            --             line_side = 1;
            --         else
            --             line_side = -1;
            --     }
            -- }
            
            self.arena_x = (SCREEN_WIDTH / 2) + self.line_xpos
        end

        if arena == "YSLIDER" then
            local new_volume = math.min(12, self.mic.mic_volume / 8)
            
            if new_volume > 1 then
                self.line_ypos = self.line_ypos + (self.line_side * new_volume) * DTMULT
            end
            
            if (self.line_side == 1 and self.line_ypos >= self.line_height) then
                self.line_side = -1
                self.line_ypos = self.line_height
                self.arena_size2 = 20
                
            elseif (self.line_side == -1 and self.line_ypos <= -self.line_height) then
                self.line_side = 1
                self.line_ypos = -self.line_height
                self.arena_size2 = 20
            end
            
            -- if (room == room_dw_castle_tv_zone_minigame)
            -- {
            --     if (abs(x - scr_mouse_x()) > 60)
            --     {
            --         if (scr_mouse_x() > x)
            --             line_side = 1;
            --         else
            --             line_side = -1;
            --     }
            -- }
            
            self.arena_y = 190 + self.line_ypos
        end

        if arena == "RING" then
            self.circle_width = MathUtils.approach(self.circle_width, 75, 8 * DTMULT)
            self.circle_height = MathUtils.approach(self.circle_height, 75, 8 * DTMULT)
        end
        
        if arena == "SMALL_RING" then
            self.circle_width = MathUtils.approach(self.circle_width, 50, 8 * DTMULT)
            self.circle_height = MathUtils.approach(self.circle_height, 50, 8 * DTMULT)
        end

        if arena == "WALKER" then		
			self.arena_speed_x = self.arena_speed_x * 0.75 ^ DTMULT
			self.arena_speed_x = MathUtils.clamp(self.arena_speed_x + ((self.hand.mouse_x - self.arena_x) / self.walker_speed_x_division), -14, 14)
			self.arena_x = MathUtils.clamp(self.arena_x, 0, 640)
			self.x_target = self.arena_x + self.arena_speed_x * DTMULT
			self.arena_y = MathUtils.lerp(self.arena_y, (0.5 * SCREEN_HEIGHT) + MathUtils.clamp(0, -200, 8), 1 - (1 - 0.15) ^ DTMULT)
			self.arena_speed_y = self.arena_speed_y * 0.9 ^ DTMULT
			self.y_target = self.arena_y + self.arena_speed_y * DTMULT
			self.arena_x = MathUtils.lerp(self.arena_x, self.x_target, 1 - (1 - 0.3) ^ DTMULT)
			self.arena_y = MathUtils.lerp(self.arena_y, self.y_target, 1 - (1 - 0.3) ^ DTMULT)
		end
		
        if TableUtils.contains({"DEFAULT", "RING", "SMALL_RING"}, arena) then
            local new_volume = math.min(12, self.mic.mic_volume / 4)
            if new_volume > 1 then
                self.arena_new_dir = self.arena_new_dir - new_volume * DTMULT
            end

            self.arena_dir = self.arena_dir + ((self.arena_new_dir - self.arena_dir) * 0.25) * DTMULT
            self.arena_size2 = math.max(13, new_volume * 2)

            if arena == "DEFAULT" then
                self.arena_size2 = math.max(13, 0 * 2)
            else
                self.arena_x = (SCREEN_WIDTH/2) + lengthDirX(self.circle_width, -math.rad(self.arena_dir))
                self.arena_y = (SCREEN_HEIGHT/2) + lengthDirY(self.circle_height, -math.rad(self.arena_dir)) + self.circle_offset
            end
        end
    end
    
    if Game.battle:getState() == "MIKEPARTYTURN" then
        self.hand_dist = MathUtils.approach(self.hand_dist, 220, 8 * DTMULT)
    end

    if self.hand then
        self.hand_x = self.arena_x
        self.hand_y = self.arena_y

        if self.hand.hand_type == 1 and Game.battle:getState() == "MIKEPARTYTURN" then
            self.hand.juggle = false
        end

        if self.allow_sensitivity_adjust then
            local mx, my = 100, 0
            local mwidth, mheight = 440, 100
            local ly = my + (mheight / 2) + 32
            local lw = MathUtils.dist(mx + 96, 0, mx + mwidth - 96, 0)
            local lx = mx + 96 + (lw * (self.mic.mic_sensitivity/4))

            if self.hand.hand_type == 3 or self.sensitivity_collider:collidesWith(self.hand.collider) then
                self.hand.juggle = true

                if self.left_click_down then
                    self.hand.hand_type = 3
                    self.mic.mic_sensitivity = MathUtils.clamp(inverseLerp(mx + 86, mx + mwidth - 96, self.hand.mouse_x - 12) * 4, 0.1, 4)
                end
            end
        end

        if self.hand.hand_type == 3 and not self.left_click_down and Game.battle:getState() == "MIKEPARTYTURN" then
            self.hand.hand_type = 1
            self.hand.juggle = false
        end

        self.hand.hand_x = self.hand_x
        self.hand.hand_y = self.hand_y
        self.hand.hand_distance = self.hand_dist
    end
end

local function drawRectangle(x, y, w, h, outline)
    Draw.rectangle(outline, x, y, w - x + 1, h - y + 1)
end

function MikeController:draw()
    super.draw(self)

    if self:canDisplayFakeArena() then
        local arena = self:getArenaMode()

        -- dotted rings (unused code from Switch 2)
        if TableUtils.contains({"RING", "SMALL_RING"}, arena) then
            for i = 1, 36 do
                local current_time = (Kristal.getTime() * 1000) / 30
                local dir_dist = MathUtils.dist(self.arena_new_dir, 0, self.arena_dir, 0) / 10

                local circle_x = (SCREEN_WIDTH/2) + lengthDirX(self.circle_width + (math.sin(i + current_time) * dir_dist), 
                -math.rad((i / 36) * 360))
                local circle_y = (SCREEN_HEIGHT/2) + lengthDirY(self.circle_height + (math.sin(i + current_time) * dir_dist), 
                -math.rad((i / 36) * 360)) + self.circle_offset

                Draw.setColor(ColorUtils.mergeColor({0, 192/255, 0}, COLORS.black, MathUtils.clamp(MathUtils.dist(circle_x, circle_y, self.arena_x, self.arena_y) / 200, 0, 1)))
                if (MathUtils.dist(circle_x, circle_y, self.arena_x, self.arena_y) > 24) then
                    love.graphics.circle("fill", circle_x, circle_y, 1)
                end
            end
        end

        if TableUtils.contains({"YSLIDER"}, arena) then
            Draw.setColor(ColorUtils.mergeColor(COLORS.lime, COLORS.black, 0.5))
			local line_y = 190 - self.line_height
			local line_s = self.line_height / 18
			self.line_x[1] = self.arena_x
			self.line_x[36] = self.arena_x
			for i = 2, 36-1 do
                if (i < 36) then
                    local current_time = (Kristal.getTime() * 1000) / 30
                    self.line_x[i] = self.arena_x + MathUtils.clamp(math.sin(i + (current_time * -self.line_side)) * math.floor(self.mic.mic_volume) * 0.1, -16, 16)
                end
                    
                love.graphics.setLineWidth(1)
                love.graphics.line(self.line_x[i - 1], line_y + ((i - 1) * line_s), self.line_x[i], line_y + (i * line_s))
            end
				
            Draw.setColor(COLORS.lime)
            Draw.draw(Assets.getTexture("player/mike/littlearrow"), self.arena_x + math.max(0, self.line_side), self.arena_y + ((self.arena_size1 + 3) * self.line_side), -math.rad(90 + (math.max(0, self.line_side) * 180)), 1, 1, 0, 5)
            Draw.setColor(COLORS.black)
            drawRectangle(self.arena_x - self.arena_size1 - 1, self.arena_y - self.arena_size1 - 1, self.arena_x + self.arena_size1, self.arena_y + self.arena_size1, "fill")
            --self.line_height = MathUtils.lerp(self.line_height, 110, 1 - (1 - 0.5) ^ DTMULT)
        end

        if TableUtils.contains({"XSLIDER"}, arena) then
            Draw.setColor(ColorUtils.mergeColor(COLORS.lime, COLORS.black, 0.5))  
			local line_x = ((self.line_width / 36) + (SCREEN_WIDTH / 2)) - self.line_width
			local line_s = self.line_width / 18
			self.line_y[1] = self.line_ypos + (SCREEN_HEIGHT / 2)
			self.line_y[36] = self.line_ypos + (SCREEN_HEIGHT / 2)
            for i = 2, 36-1 do
                if (i < 36) then
                    local current_time = (Kristal.getTime() * 1000) / 30
                    self.line_y[i] = self.line_ypos + (SCREEN_HEIGHT / 2) + MathUtils.clamp(math.sin(i + (current_time * -self.line_side)) * math.floor(self.mic.mic_volume) * 0.1, -16, 16)
                end
                    
                love.graphics.setLineWidth(1)
                love.graphics.line(line_x + ((i - 1) * line_s), self.line_y[i - 1], line_x + (i * line_s), self.line_y[i])
            end
                
            Draw.setColor(COLORS.lime)
            Draw.draw(Assets.getTexture("player/mike/littlearrow"), self.arena_x + ((self.arena_size1 + 3) * self.line_side), self.arena_y, -math.rad(0), self.line_side, 1, 0, 5)
            Draw.setColor(COLORS.black)
            drawRectangle(self.arena_x - self.arena_size1 - 1, self.arena_y - self.arena_size1 - 1, self.arena_x + self.arena_size1, self.arena_y + self.arena_size1, "fill")
        end

        if TableUtils.contains({"WINGBOX", "XSLIDER", "YSLIDER"}, arena) then
            Draw.setColor(COLORS.lime)
            love.graphics.setLineWidth(1)
            drawRectangle(self.arena_x - self.arena_size1 - 1, self.arena_y - self.arena_size1 - 1, self.arena_x + self.arena_size1,     self.arena_y + self.arena_size1,     "line")
            drawRectangle(self.arena_x - self.arena_size1 - 2, self.arena_y - self.arena_size1 - 2, self.arena_x + self.arena_size1 + 1, self.arena_y + self.arena_size1 + 1, "line")
            
            if ((arena == "WINGBOX") and self.wing_angle1 ~= 270) then
                love.graphics.setLineWidth(2)
                love.graphics.line(
                    self.arena_x - self.arena_size1 - 3, 
                    self.arena_y - self.arena_size1 - 2, 
                    (self.arena_x - self.arena_size1 - 3) + lengthDirX(self.arena_size1 * 2, -math.rad(self.wing_angle1)), 
                    (self.arena_y - self.arena_size1 - 2) + lengthDirY(self.arena_size1 * 2, -math.rad(self.wing_angle1))
                )
                love.graphics.line(
                    self.arena_x + self.arena_size1 + 1, 
                    self.arena_y - self.arena_size1 - 2, 
                    (self.arena_x + self.arena_size1 + 1) - lengthDirX(self.arena_size1 * 2, -math.rad(self.wing_angle1)), 
                    (self.arena_y - self.arena_size1 - 2) + lengthDirY(self.arena_size1 * 2, -math.rad(self.wing_angle1))
                )
                love.graphics.setLineWidth(1)
            end
        end

        -- main arena shape (PC)
        if TableUtils.contains({"DEFAULT", "WALKER"}, arena) then
            local center_x = self.arena_x
            local center_y = self.arena_y
            
            for i = 1, 35 do
                local mydir = (Kristal.getTime() * 1000) / 300
                local dir_dist = MathUtils.dist(self.arena_new_dir, 0, self.arena_dir, 0) / 10
                
                local circle_x = center_x + lengthDirX(math.max(16, self.arena_size1) + (math.sin(i + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
                -math.rad(mydir + ((i / 36) * 360)))
                local circle_y = center_y + lengthDirY(math.max(16, self.arena_size1) + (math.sin(i + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
                -math.rad(mydir + ((i / 36) * 360)))
                local circle_x2 = center_x + lengthDirX(math.max(16, self.arena_size1) + (math.sin((i - 1) + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
                -math.rad(mydir + (((i - 1) / 36) * 360)))
                local circle_y2 = center_y + lengthDirY(math.max(16, self.arena_size1) + (math.sin((i - 1) + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
                -math.rad(mydir + (((i - 1) / 36) * 360)))
                
                Draw.setColor(COLORS.lime)

                if i == 1 then
                    local n = 35
                    circle_x2 = center_x + lengthDirX(math.max(16, self.arena_size1) + (math.sin(n + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
                    -math.rad(mydir + ((n / 36) * 360)))
                    circle_y2 = center_y + lengthDirY(math.max(16, self.arena_size1) + (math.sin(n + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
                    -math.rad(mydir + ((n / 36) * 360)))
                end

                love.graphics.setLineWidth(2)
                love.graphics.line(circle_x, circle_y, circle_x2, circle_y2)
            end
        end

        -- main arena shape (Switch 2)
        if TableUtils.contains({"RING", "SMALL_RING"}, arena) then
            Draw.setColor(ColorUtils.mergeColor(COLORS.lime, COLORS.black, 0))
            love.graphics.circle("fill", self.arena_x, self.arena_y, self.arena_size1 + 2)
            Draw.setColor(COLORS.black)
            love.graphics.circle("fill", self.arena_x, self.arena_y, self.arena_size1)
        end

        self.arena_size1 = self.arena_size1 + ((self.arena_size2 - self.arena_size1) * 0.25) * DTMULT
        self.arena_size2 = self.arena_size2 + ((self.arena_size3 - self.arena_size2) * 0.25) * DTMULT
        self.arena_size1 = MathUtils.approach(self.arena_size1, self.arena_size2, 0.01 * DTMULT)
        self.arena_size2 = MathUtils.approach(self.arena_size2, self.arena_size3, 0.01 * DTMULT)

        if arena == "WALKER" then
            local bottomY = 326
            local _phase = self.arena_x / 18
            local yOffset = math.sin(_phase) * 4
            self.arena_y = self.arena_y + yOffset * DTMULT
            
            for ii = -1, 1, 2 do
                local xx = self.arena_x + (math.sin(_phase) * -32) + (32 * ii)
                local yy = bottomY + math.min(0, math.cos(_phase) * 16)
                Draw.setColor(COLORS.lime)
                
                for i = 1, (MathUtils.dist(xx, yy, self.arena_x, self.arena_y) / 16) do
                    local x1 = xx + lengthDirX(i * 16, MathUtils.angle(xx, yy, self.arena_x, self.arena_y))
                    local y1 = yy + lengthDirY(i * 16, MathUtils.angle(xx, yy, self.arena_x, self.arena_y))
                    if MathUtils.dist(x1, y1, self.arena_x, self.arena_y) > 32 then
                        love.graphics.setLineWidth(1)
                        love.graphics.circle("line",
                            xx + MathUtils.randomInt(1+1, -1-1) + lengthDirX(i * 16, MathUtils.angle(xx, yy, self.arena_x, self.arena_y)), 
                            yy + MathUtils.randomInt(1+1, -1-1) + lengthDirY(i * 16, MathUtils.angle(xx, yy, self.arena_x, self.arena_y)), 
                            2
                        )
                    end
                end
                
                _phase = (self.arena_x + (32 * ii)) / 20
                Draw.setColor(1, 1, 1, 1)
                Draw.draw(Assets.getFrames("minigame/bullets/mike/shoe")[1], xx, yy, -math.rad(math.sin(_phase) * 5 * ii), ii, 1, 12, 28)
            end
        end
        
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, self.arena_x - 10, self.arena_y - 10)
    end

    if self.allow_sensitivity_adjust then
        local mx, my = 100, 0
        local mwidth, mheight = 440, 100

        Draw.setColor(1, 1, 1)
        love.graphics.setFont(self.font)    
        love.graphics.print("Adjust Sensitivity", mx + (mwidth / 2) - self.font:getWidth("Adjust Sensitivity")/4, my + 30, 0, 0.5, 0.5)

        local ly = my + (mheight / 2) + 32
        local lw = MathUtils.dist(mx + 96, 0, mx + mwidth - 96, 0) 
        local lx = mx + 96 + (lw * (self.mic.mic_sensitivity/4))

        Draw.setColor(COLORS["dkgray"])
        local tri_points = {mx + 86, ly, mx + mwidth - 96}
        love.graphics.polygon("fill", tri_points[1], tri_points[2], tri_points[3], tri_points[2], tri_points[3], tri_points[2] - 16)
        Draw.setColor(1, 1, 1)
        love.graphics.rectangle("fill", lx - 2, ly - 24, 5, 33)

        if DEBUG_RENDER then
            self.sensitivity_collider:draw(1, 0, 0)
        end
    end
end

return MikeController