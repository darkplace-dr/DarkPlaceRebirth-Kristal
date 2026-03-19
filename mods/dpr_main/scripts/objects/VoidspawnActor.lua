local VoidspawnActorSprite, super = Class(ActorSprite)

function VoidspawnActorSprite:init(actor)
    super.init(self, actor)

    self.animsiner = 0

    self.body = Assets.getTexture(self:getTexturePath("body"))
    self.squash = Assets.getFrames(self:getTexturePath("squash"))
    self.iris = Assets.getTexture(self:getTexturePath("iris"))
    self.eye = Assets.getTexture(self:getTexturePath("eye"))
    self.trail_ball = Assets.getTexture(self:getTexturePath("fountain_ball"))
    self.trail_ball_dissolve = Assets.getFrames(self:getTexturePath("fountain_ball_dissolve"))
	
	self.eye_init_x = self.body:getWidth()/2
	self.eye_init_y = self.body:getHeight()/2

    self.max_dist_x = 300
    self.max_dist_y = 200

	self.body_state = "CAMO" -- DARKTRAIL, ENCOUNTER, CAMO
    self.eye_state = "CAMO" -- FOLLOWING, SET, CAMO
    self.body_alpha = 0

    self.eye_x = 0
    self.eye_y = 0
    self.iris_x = 0
    self.iris_y = 0
    self.eye_draw_x = 31
    self.eye_draw_y = 31
    self.iris_draw_x = 31
    self.iris_draw_y = 31
	
	self.fly_siner = 0
	
	self.trail_x = 0
	self.trail_y = 0
	self.trail_dir = math.rad(0)
	self.trail_timer = 0
	self.trail_speed = 0
	
	self.eye_aim_x = 0
	self.eye_aim_y = 0
	self.eye_center = false
	self.trails = {}
	self.wave_timer = 0
    self.wave = self:addFX(ShaderFX("darkshape_wave", {
        ["wave_timer"] = function() return self.wave_timer end,
        ["wave_mag"] = function() return (self.eye_state == "CAMO" and 0 or 8 - (self.body_alpha * 8)) end,
        ["texsize"] = {SCREEN_WIDTH, SCREEN_HEIGHT}
    }), "wave")
	self.squash_body = false
	self.squash_frame = 0

	self.death_scale = 2
	self.eye_deathtimer = 0
end

function VoidspawnActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function VoidspawnActorSprite:setAnimation(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function VoidspawnActorSprite:setEyeState(state, x, y)
    if self.eye_state ~= state then
        if self.eye_state == "CAMO" then
            Game.stage.timer:tween(10/30, self, {body_alpha = 1})
        end
        if state == "CAMO" then
            Game.stage.timer:tween(10/30, self, {body_alpha = 0})
        end
        self.eye_state = state
    end
    if state == "SET" then
        if x == nil then x = 0 end
        if y == nil then y = 0 end
		if Game.state == "BATTLE" then
			self.eye_aim_x = x
			self.eye_aim_y = y
		else
			local eye_dist = MathUtils.dist(self.parent.x + self.eye_init_x, self.parent.y + self.eye_init_y, x, y)
			local eye_angle = MathUtils.angle(self.parent.x + self.eye_init_x, self.parent.y + self.eye_init_y, x, y)
			self.eye_x = MathUtils.lengthDirX(math.min(eye_dist, 18), -eye_angle)
			self.eye_y = MathUtils.lengthDirY(math.min(eye_dist, 18), -eye_angle)
			self.iris_x = MathUtils.lengthDirX(math.min(eye_dist, 19.5), -eye_angle)
			self.iris_y = MathUtils.lengthDirY(math.min(eye_dist, 18), -eye_angle)
		end
    end
end

function VoidspawnActorSprite:setBodyState(state)
    if state == "HURT" then
		for i = 0, MathUtils.randomInt(1, 2) do
			local angle = math.rad(MathUtils.random(360))
			local spd = MathUtils.random(3, 4)
			local trail = {
				x = self.trail_x + MathUtils.lengthDirX(8, -angle),
				y = self.trail_y + MathUtils.lengthDirY(8, -angle),
				radius = MathUtils.random(0.3, 0.4),
				speed_x = spd * math.cos(angle),
				speed_y = spd * math.sin(angle),
				angle = angle,
				friction = 0.25,
				fade = true,
				mode = 1,
				frame = 1,
				lifetime = 15 + MathUtils.randomInt(10),
				easetype = TableUtils.pick({1, 2}),
				con = 0,
			}
			table.insert(self.trails, trail)
		end
		for i = 0, MathUtils.randomInt(2, 3) do
			local angle = math.rad(MathUtils.random(360))
			local trail = {
				x = self.trail_x + MathUtils.random(-8, 8),
				y = self.trail_y - 8,
				radius = MathUtils.random(0.2, 0.3),
				speed_x = MathUtils.random(-2.5, 2.5),
				speed_y = -MathUtils.random(3, 5),
				angle = 0,
				friction = 0.125,
				fade = true,
				mode = 0,
				frame = 1,
				lifetime = 15 + MathUtils.randomInt(10),
				easetype = TableUtils.pick({1, 2}),
				con = 0,
			}
			table.insert(self.trails, trail)
		end
		self.squash_body = true
		Game.stage.timer:lerpVar(self, "squash_frame", 0, 7*3, 60, 1, "out")
		Game.stage.timer:after(1, function()
			self.squash_body = false
			self.squash_frame = 0
		end)
    end 
	if state == "CRITHURT" then
		for i = 0, 16 do
			local angle = math.rad((i / 16) * 360)
			local spd = MathUtils.random(4, 5)
			local trail = {
				x = self.trail_x + MathUtils.lengthDirX(8, -angle),
				y = self.trail_y + MathUtils.lengthDirY(8, -angle),
				radius = MathUtils.random(0.3, 0.4),
				speed_x = spd * math.cos(angle),
				speed_y = spd * math.sin(angle),
				angle = angle,
				friction = 0.25,
				fade = true,
				mode = TableUtils.pick({0, 1}),
				frame = 1,
				lifetime = 15 + MathUtils.randomInt(10),
				easetype = TableUtils.pick({1, 2}),
				con = 0,
			}
			table.insert(self.trails, trail)
		end
		for i = 0, MathUtils.randomInt(5, 7) do
			local angle = math.rad(MathUtils.random(360))
			local trail = {
				x = self.trail_x + MathUtils.random(-8, 8),
				y = self.trail_y - 8,
				radius = MathUtils.random(0.2, 0.3),
				speed_x = MathUtils.random(-2.5, 2.5),
				speed_y = -MathUtils.random(3, 5),
				angle = 0,
				friction = 0.125,
				fade = true,
				mode = 0,
				frame = 1,
				lifetime = 15 + MathUtils.randomInt(10),
				easetype = TableUtils.pick({1, 2}),
				con = 0,
			}
			table.insert(self.trails, trail)
		end
		self.squash_body = true
		Game.stage.timer:lerpVar(self, "squash_frame", 0, 7*5, 60, 2, "out")
		Game.stage.timer:after(1, function()
			self.squash_body = false
			self.squash_frame = 0
		end)
    end
    if self.body_state ~= state then
		self.body_state = state
	end
end

function VoidspawnActorSprite:kill()
	self:setEyeState("AGONY")
	self:setBodyState("DEATHEXPLOSION")
	self.squash_body = true
	Game.stage.timer:tween(3, self, {death_scale = 0.01}, "linear", function()
		self:remove()
	end)
end

function VoidspawnActorSprite:update()
    super.update(self)

    self.wave_timer = self.wave_timer + DTMULT
    local origin_x, origin_y = self.parent:getOrigin()
    if origin_y ~= 0.5 then self.parent:setOrigin(0.5, 0.5) end

	if Game.state == "BATTLE" then
		local eye_dist, eye_angle
		if self.eye_state == "FOLLOWING" then
			local px, py = Game.battle.soul and Game.battle.soul.x or self.eye_aim_x, Game.battle.soul and Game.battle.soul.y or self.eye_aim_y
			eye_dist = MathUtils.dist(self.parent.x + self.x + self.eye_init_x, self.parent.y + self.y + self.eye_init_y, px, py)
			eye_angle = MathUtils.angle(self.parent.x + self.x + self.eye_init_x, self.parent.y + self.y + self.eye_init_y, px, py)
		else
			eye_dist = MathUtils.dist(self.parent.x + self.x + self.eye_init_x, self.parent.y + self.y + self.eye_init_y, self.eye_aim_x, self.eye_aim_y)
			eye_angle = MathUtils.angle(self.parent.x + self.x + self.eye_init_x, self.parent.y + self.y + self.eye_init_y, self.eye_aim_x, self.eye_aim_y)
		end
        self.eye_x = MathUtils.lengthDirX(math.min(eye_dist, 18), -eye_angle)
		self.eye_y = MathUtils.lengthDirY(math.min(eye_dist, 18), -eye_angle)
        self.iris_x = MathUtils.lengthDirX(math.min(eye_dist, 19.5), -eye_angle)
        self.iris_y = MathUtils.lengthDirY(math.min(eye_dist, 18), -eye_angle)
		self.trail_x = self.body:getWidth()/2
        self.trail_y = self.body:getHeight()/2
	else
		if Game.world.player and self.eye_state == "FOLLOWING" then
			local px, py = Game.world.player.x + (Game.world.player.width), Game.world.player.y
			local eye_dist = MathUtils.dist(self.parent.x + self.eye_init_x, self.parent.y + self.eye_init_y, px, py)
			local eye_angle = MathUtils.angle(self.parent.x + self.eye_init_x, self.parent.y + self.eye_init_y, px, py)
			local trail_angle
			self.eye_x = MathUtils.lengthDirX(math.min(eye_dist, 18), -eye_angle)
			self.eye_y = MathUtils.lengthDirY(math.min(eye_dist, 18), -eye_angle)
			self.iris_x = MathUtils.lengthDirX(math.min(eye_dist, 19.5), -eye_angle)
			self.iris_y = MathUtils.lengthDirY(math.min(eye_dist, 18), -eye_angle)
			if self.body_state == "CHASETRAIL" then
				trail_angle = MathUtils.angle(self.parent.x, self.parent.y, px, py) - math.rad(180)
				self.trail_dir = trail_angle
			end
			self.trail_x = self.body:getWidth()/2
			self.trail_y = self.body:getHeight()/2
		elseif Game.world.player and self.eye_state == "CAMO" then
			local px, py = Game.world.player.x + (Game.world.player.width), Game.world.player.y
			local eye_angle = MathUtils.angle(self.parent.x + self.eye_init_x, self.parent.y + self.eye_init_y, px, py)
			self.eye_x = MathUtils.lengthDirX(30 - 16, -eye_angle)
			self.eye_y = MathUtils.lengthDirY(10 - 6, -eye_angle)
			self.iris_x = self.eye_x
			self.iris_y = self.eye_y
		end
	end
	if self.eye_center then
        self.eye_x = 0
		self.eye_y = 0
        self.iris_x = 0
        self.iris_y = 0
	end
	local to_remove = {}
    for _, trail in ipairs(self.trails) do
		if trail then
			if trail.fade then
				if trail.con == 0 then
					Game.stage.timer:lerpVar(trail, "radius", trail.radius, 0, trail.lifetime, easetype, "out")
					if trail.mode == 1 then
						Game.stage.timer:lerpVar(trail, "frame", 1, 8, trail.lifetime, trail.easetype, "out")
					end
					trail.con = 1
				end
				if trail.con == 1 then
					if trail.radius <= 0 then
						table.insert(to_remove, trail)
					end
				end
			end
			if self.body_state ~= "ENCOUNTER" then
				trail.speed_x = MathUtils.approach(trail.speed_x, 0, trail.friction * DTMULT)
				trail.speed_y = MathUtils.approach(trail.speed_y, 0, trail.friction * DTMULT)
				trail.x = trail.x + trail.speed_x * DTMULT
				trail.y = trail.y + trail.speed_y * DTMULT
			end
		end
    end
    for _, trail in ipairs(to_remove) do
		TableUtils.removeValue(self.trails, trail)
	end
	if self.body_state == "DARKTRAIL" or self.body_state == "CHASETRAIL" then
		self.trail_timer = self.trail_timer - DTMULT
		if self.trail_timer <= 0 then 
			local pos = MathUtils.random(-15, 15)
			local spd = self.trail_speed * MathUtils.random(1.2, 2)
			local trail = {
				x = self.trail_x + (pos * math.sin(self.trail_dir)),
				y = self.trail_y + (pos * math.cos(self.trail_dir)),
				radius = MathUtils.random(0.4, 0.5),
				speed_x = spd * math.cos(self.trail_dir),
				speed_y = spd * math.sin(self.trail_dir),
				angle = angle,
				friction = -0.005,
				fade = true,
				mode = 0,
				frame = nil,
				lifetime = 40 + MathUtils.randomInt(50),
				easetype = TableUtils.pick({1, 2}),
				con = 0,
			}
			table.insert(self.trails, trail)
			if self.body_state == "CHASETRAIL" then
				self.trail_timer = 1
			else
				self.trail_timer = MathUtils.randomInt(1, 8)
			end
		end
	end
	if self.body_state == "DEATHEXPLOSION" then
		if self.squash_body ~= true then self.squash_body = true end
		self.parent:setScale(self.death_scale)
		local angle = math.rad(MathUtils.random(360))
		local spd = MathUtils.random(4, 5)
		local trail = {
			x = self.trail_x + MathUtils.random(-8, 8),
			y = self.trail_y - 8,
			radius = MathUtils.random(0.2, 0.3),
			speed_x = spd * math.cos(angle),
			speed_y = spd * math.sin(angle),
			angle = angle,
			friction = 0.125,
			fade = true,
			mode = 0,
			frame = 1,
			lifetime = 15 + MathUtils.randomInt(10),
			easetype = TableUtils.pick({1, 2}),
			con = 0,
		}
		table.insert(self.trails, trail)
	end
	if self.eye_state == "AGONY" then
		self.eye_deathtimer = self.eye_deathtimer + DT
		if self.eye_deathtimer > 5/30 then
			self.eye_deathtimer = 0
			self.eye_aim_x = self.parent.x + (self.x + 31) + MathUtils.random(-5, 5) * (self.death_scale/2)
			self.eye_aim_y = self.parent.y + (self.y + 31) + MathUtils.random(-5, 5) * (self.death_scale/2)
		end
	end
end

function VoidspawnActorSprite:draw()
	local sprite_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	
    self.eye_draw_x = MathUtils.lerp(self.eye_draw_x, self.eye_init_x + self.eye_x, 0.25*DTMULT)
    self.eye_draw_y = MathUtils.lerp(self.eye_draw_y, self.eye_init_y + self.eye_y, 0.25*DTMULT)

    local eye_scale_x = 0 + (self.iris_draw_x - 31)/31
    local eye_scale_y = 0 + (self.iris_draw_y - 31)/31
    if eye_scale_x < 0 then eye_scale_x = -eye_scale_x end
    if eye_scale_y < 0 then eye_scale_y = -eye_scale_y end
    local eye_sx, eye_sy = (2 - eye_scale_x/1.5)/2, (2 - eye_scale_y/1.5)/2
	local iris_sx, iris_sy = 1, 1
    if self.eye_state ~= "CAMO" then
        iris_sx, iris_sy = (2 - eye_scale_x/1.5)/2, (2 - eye_scale_y/1.5)/2
        self.iris_draw_x = MathUtils.lerp(self.iris_draw_x, self.eye_init_x + self.iris_x, 0.25*DTMULT)
        self.iris_draw_y = MathUtils.lerp(self.iris_draw_y, self.eye_init_y + self.iris_y, 0.25*DTMULT)
    else
        self.iris_draw_x = self.eye_init_x + self.iris_x
        self.iris_draw_y = self.eye_init_y + self.iris_y
    end
	Draw.setColor(COLORS.white)

	local body = self.squash_body == true and self.squash[math.floor(self.squash_frame % 7) + 1] or self.body
	Draw.draw(body, SCREEN_WIDTH/2 - 1, SCREEN_HEIGHT/2, 0, 1, 1, 0, 0)
	Draw.draw(body, SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 1, 0, 1, 1, 0, 0)
	Draw.draw(body, SCREEN_WIDTH/2 + 1, SCREEN_HEIGHT/2, 0, 1, 1, 0, 0)
	Draw.draw(body, SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + 1, 0, 1, 1, 0, 0)
    for _, trail in ipairs(self.trails) do
		if trail then
			if trail.radius >= 0 then
				if trail.mode == 1 then
					Draw.draw(self.trail_ball_dissolve[math.floor(trail.frame)], SCREEN_WIDTH/2 + trail.x, SCREEN_HEIGHT/2 + trail.y, trail.angle - math.rad(180), trail.radius + 0.05, trail.radius + 0.05, 59, 34)
				else
					Draw.draw(self.trail_ball, SCREEN_WIDTH/2 + trail.x, SCREEN_HEIGHT/2 + trail.y, 0, trail.radius + 0.05, trail.radius + 0.05, 24, 24)
				end
			end
		end
	end
	Draw.setColor(COLORS.black)
	Draw.draw(body, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 1, 1, 0, 0)
    for _, trail in ipairs(self.trails) do
		if trail then
			if trail.radius >= 0 then
				if trail.mode == 1 then
					Draw.draw(self.trail_ball_dissolve[math.floor(trail.frame)], SCREEN_WIDTH/2 + trail.x, SCREEN_HEIGHT/2 + trail.y, trail.angle - math.rad(180), trail.radius, trail.radius, 59, 34)
				else
					Draw.draw(self.trail_ball, SCREEN_WIDTH/2 + trail.x, SCREEN_HEIGHT/2 + trail.y, 0, trail.radius, trail.radius, 24, 24)
				end
			end
		end
	end
    local r, g, b, a = self:getDrawColor()
	Draw.setColor(r,g,b,a)
	Draw.popCanvas()
	
    if sprite_canvas and self.run_away then
        local r, g, b, a = self:getDrawColor()
		a = a * self.body_alpha
        for i = 0, 80 do
            local alph = a * 0.4
            Draw.setColor(r, g, b, ((alph - (self.run_away_timer / 8)) + (i / 200)))
            Draw.draw(sprite_canvas, i * 2, 0, 0, 1, 1, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        end
        return
    end

    if sprite_canvas and self.aura then
        -- Use additive blending if the enemy is not being drawn to a canvas
        if love.graphics.getCanvas() == SCREEN_CANVAS then
            love.graphics.setBlendMode("add")
        end

        local sprite_width = SCREEN_WIDTH/2 + sprite_canvas:getWidth()
        local sprite_height = SCREEN_HEIGHT/2 + sprite_canvas:getHeight()

        for i = 1, 5 do
            local aura = (i * 9) + ((self.aura_siner * 3) % 9)
            local aurax = (aura * 0.75) + (math.sin(aura / 4) * 4)
            --var auray = (45 * scr_ease_in((aura / 45), 1))
            local auray = 45 * Ease.inSine(aura / 45, 0, 1, 1)
            local aurayscale = math.min(1, 80 / sprite_height)

            Draw.setColor(1, 0, 0, ((1 - (auray / 45)) * 0.5) * self.body_alpha)
            Draw.draw(sprite_canvas, -((aurax / 180) * sprite_width), -((auray / 82) * sprite_height * aurayscale), 0, 1 + ((aurax / 36) * 0.5), 1 + (((auray / 36) * aurayscale) * 0.5))
        end

        love.graphics.setBlendMode("alpha")

        local xmult = math.min((70 / sprite_width) * 4, 4)
        local ymult = math.min((80 / sprite_height) * 5, 5)
        local ysmult = math.min((80 / sprite_height) * 0.2, 0.2)

        Draw.setColor(1, 0, 0, 0.2 * self.body_alpha)
        Draw.draw(sprite_canvas, (sprite_width / 2) + (math.sin(self.aura_siner / 5) * xmult) / 2, (sprite_height / 2) + (math.cos(self.aura_siner / 5) * ymult) / 2, 0, 1, 1 + (math.sin(self.aura_siner / 5) * ysmult) / 2, sprite_width / 2, sprite_height / 2)
        Draw.draw(sprite_canvas, (sprite_width / 2) - (math.sin(self.aura_siner / 5) * xmult) / 2, (sprite_height / 2) - (math.cos(self.aura_siner / 5) * ymult) / 2, 0, 1, 1 - (math.sin(self.aura_siner / 5) * ysmult) / 2, sprite_width / 2, sprite_height / 2)

        local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["AddColor"])

        Kristal.Shaders["AddColor"]:send("inputcolor", { 1, 0, 0 })
        Kristal.Shaders["AddColor"]:send("amount", 1)

        Draw.setColor(1, 1, 1, 0.3 * self.body_alpha)
        Draw.draw(sprite_canvas, 1, 0, 0, 1, 1, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        Draw.draw(sprite_canvas, -1, 0, 0, 1, 1, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        Draw.draw(sprite_canvas, 0, 1, 0, 1, 1, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        Draw.draw(sprite_canvas, 0, -1, 0, 1, 1, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)

        love.graphics.setShader(last_shader)

        Draw.setColor(self:getDrawColor())
    end
	local shakex, shakey = 0, 0
	if self.body_state == "HURT" then
		shakex = MathUtils.random(-2, 2)
		shakey = MathUtils.random(-2, 2)
	end
	if self.body_state == "CRITHURT" then
		shakex = MathUtils.random(-4, 4)
		shakey = MathUtils.random(-4, 4)
	end
    local r, g, b, a = self:getDrawColor()
	Draw.setColor(r,g,b,a * self.body_alpha)
    Draw.draw(sprite_canvas, 0, 0, 0, 1, 1, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
	Draw.draw(self.eye, self.eye_draw_x + shakex, self.eye_draw_y + shakey, 0, eye_sx, eye_sy, self.eye:getWidth()/2, self.eye:getHeight()/2)
	Draw.setColor(r,g,b,a)
	Draw.draw(self.iris, self.iris_draw_x + shakex, self.iris_draw_y + shakey, 0, iris_sx, iris_sy, 3, 3)

    if sprite_canvas and self.frozen then
        if self.freeze_progress < 1 then
            Draw.pushScissor()
            Draw.scissorPoints(nil, sprite_canvas:getHeight() * (1 - self.freeze_progress), nil, nil)
        end

        local last_shader = love.graphics.getShader()
        local shader = Kristal.Shaders["AddColor"]
        love.graphics.setShader(shader)
        shader:send("inputcolor", { 0.8, 0.8, 0.9 })
        shader:send("amount", 1)

        local r, g, b, a = self:getDrawColor()

        Draw.setColor(0, 0, 1, (a * 0.8) * self.body_alpha)
        Draw.draw(sprite_canvas, -1, -1, 0, 1, 1, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        Draw.setColor(0, 0, 1, (a * 0.4) * self.body_alpha)
        Draw.draw(sprite_canvas, 1, -1, 0, 1, 1, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        Draw.draw(sprite_canvas, -1, 1, 0, 1, 1, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        Draw.setColor(0, 0, 1, (a * 0.8) * self.body_alpha)
        Draw.draw(sprite_canvas, 1, 1, 0, 1, 1, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)

        love.graphics.setShader(last_shader)

        love.graphics.setBlendMode("add")
        Draw.setColor(0.8, 0.8, 0.9, (a * 0.4) * self.body_alpha)
        Draw.draw(sprite_canvas, 0, 0, 0, 1, 1, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        love.graphics.setBlendMode("alpha")

        if self.freeze_progress < 1 then
            Draw.popScissor()
        end
    end

    self.actor:onSpriteDraw(self)
end

return VoidspawnActorSprite