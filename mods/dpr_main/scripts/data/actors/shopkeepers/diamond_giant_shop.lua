local actor, super = Class(Actor, "diamond_giant_shop")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Diamond"
    self.voice = nil
    self.width = 164
    self.height = 202

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 0, 164, 202}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 1, 1}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = 0

    -- Path to this actor's sprites (defaults to "")
    self.path = "shopkeepers/diamond_giant"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Table of sprite animations
    self.animations = {
        ["idle"] = {"torso"},
        ["talk"] = {"torso"},
        ["huh"] = {"torso"},
        ["talk_huh"] = {"torso"},
        ["blink"] = {"torso"},
        ["talk_blink"] = {"torso"},
        ["look_left"] = {"torso"},
        ["talk_look_left"] = {"torso"},
        ["lookdown"] = {"torso"},
        ["talk_lookdown"] = {"torso"},
    }
    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["torso"] = {0, 130},
        ["blink"] = {0, 130},
        ["talk"] = {0, 130},
        ["talk_3"] = {0, 130},
        ["huh"] = {0, 130},
        ["lookdown"] = {0, 130},
        ["look_left"] = {0, 130},
    }
end

function actor:onSpriteInit(sprite)
    super.onSpriteInit(sprite)
    sprite.alpha = 0

    sprite.head = Sprite(self.path.."/head")
    sprite.head.x = 79
    sprite.head.y = 92 - 3
    sprite.head:setOrigin(0.5, 1)
    sprite:addChild(sprite.head)

    sprite.c_1 = Sprite(self.path.."/circle")
    sprite.c_1.x = 55
    sprite.c_1.y = 73
    sprite.c_1:setOrigin(0.5, 0.5)
    sprite:addChild(sprite.c_1)

    sprite.c_2 = Sprite(self.path.."/circle")
    sprite.c_2.x = 103
    sprite.c_2.y = 73
    sprite.c_2:setOrigin(0.5, 0.5)
    sprite:addChild(sprite.c_2)

    sprite.e_1 = Sprite(self.path.."/eye")
    sprite.e_1.x = 58
    sprite.e_1.y = 66
    sprite.e_1:setOrigin(0.5, 1)
    sprite:addChild(sprite.e_1)

    sprite.e_2 = Sprite(self.path.."/eye")
    sprite.e_2.x = 98
    sprite.e_2.y = 66
    sprite.e_2:setOrigin(0.5, 1)
    sprite:addChild(sprite.e_2)

    sprite.e_1_b = Sprite(self.path.."/eye_bright_shadow")
    sprite.e_1_b.x = 58
    sprite.e_1_b.y = 66
	sprite.e_1_b.visible = false
    sprite.e_1_b:setOrigin(0.5, 1)
    sprite:addChild(sprite.e_1_b)

    sprite.e_2_b = Sprite(self.path.."/eye_bright_shadow")
    sprite.e_2_b.x = 98
    sprite.e_2_b.y = 66
	sprite.e_2_b.visible = false
    sprite.e_2_b:setOrigin(0.5, 1)
    sprite:addChild(sprite.e_2_b)

    sprite.torso = Sprite(self.path.."/torso")
    sprite.torso.x = -3
    sprite.torso.y = 90 - 3
    sprite:addChild(sprite.torso)

    sprite.timer = 0
    sprite.next_time = (os.date("%S") + self:pickRandomDigit())

	sprite.eye_tween_1 = nil
	sprite.eye_tween_2 = nil
	sprite.blinked = false
	sprite.talky_1 = 0
	sprite.talktimer_1 = -DT
	sprite.talkcon_1 = 0
	sprite.talk_tween_1 = nil
	sprite.talky_2 = 0
	sprite.talktimer_2 = -DT
	sprite.talkcon_2 = 0
	sprite.talk_tween_2 = nil
	sprite.talk_ended = true
	sprite.transition_timer = 1
end

function actor:pickRandomDigit()
    local number = "82352941176471"
    local index = math.random(1, #number)
    return number:sub(index, index)
end

function actor:onSetSprite(sprite, texture, keep_anim)
	sprite.transition_timer = 0
end

local function undoBlink(s)
    local e1 = s.e_1
    local e2 = s.e_2
	if s.blinked then
		if s.eye_tween_1 then
			Game.shop.timer:cancel(s.eye_tween_1)
			s.eye_tween_1 = nil
		end
		if s.eye_tween_2 then
			Game.shop.timer:cancel(s.eye_tween_2)
			s.eye_tween_2 = nil
		end
		s.eye_tween_1 = Game.shop.timer:tween(0.1, e1, {scale_x = 1, scale_y = 1})
		s.eye_tween_2 = Game.shop.timer:tween(0.1, e2, {scale_x = 1, scale_y = 1})
	end
end

local function doBlink(s)
    local e1 = s.e_1
    local e2 = s.e_2
    e1:setScale(2, 0.2)
    e2:setScale(2, 0.2)
	if s.eye_tween_1 then
		Game.shop.timer:cancel(s.eye_tween_1)
		s.eye_tween_1 = nil
	end
	if s.eye_tween_2 then
		Game.shop.timer:cancel(s.eye_tween_2)
		s.eye_tween_2 = nil
	end
	s.blinked = true
end

function actor:onSpriteUpdate(sprite)
    super.onSpriteUpdate(sprite)
    local h = sprite.head
    local max = 0.09
    local s = sprite
    
    local spx = math.sin(love.timer.getTime()) * max
    s.head.rotation = spx/2

    s.timer = sprite.timer + DT
    if s.timer >= 6.3 then
        s.spin1 = nil
        s.spin2 = nil
        s.timer = 0
        s.c_1.rotation = 0
        s.c_2.rotation = 0
    elseif s.timer >= 2.2 and not s.spin2 then 
        s.spin2 = true
        local b = s.c_2
        Game.shop.timer:tween(1, b, {rotation = math.pi*2}, "out-sine")
    elseif sprite.timer >= 2 and not sprite.spin1 then 
        s.spin1 = true
        local w = sprite.c_1
        Game.shop.timer:tween(1, w, {rotation = math.pi*2}, "out-sine")
    end
    local sp = spx
    if sp > 0 then sp = sp*-1 end
	
	s.transition_timer = MathUtils.lerpEaseOut(s.transition_timer, 1, 0.25*DTMULT, 1)

    if s.anim == "talk" or s.anim == "talk_huh" or s.anim == "talk_blink" or s.anim == "talk_look_left" or s.anim == "talk_lookdown" then
		if s.talk_tween_end then
			Game.shop.timer:cancel(s.talk_tween_end)
			s.talk_tween_end = nil
		end
		if s.talktimer_1 >= 0.25*2 then
			s.talktimer_1 = 0
			s.talkcon_1 = 0
		elseif s.talktimer_1 >= 0.25 and s.talkcon_1 == 1 then
			if s.talk_tween_1 then
				Game.shop.timer:cancel(s.talk_tween_1)
				s.talk_tween_1 = nil
			end
			s.talk_tween_1 = Game.shop.timer:tween(0.25, s, {talky_1 = 0}, "in-sine")
			s.talkcon_1 = 2
		elseif s.talktimer_1 >= 0 and s.talkcon_1 == 0 then
			if s.talk_tween_1 then
				Game.shop.timer:cancel(s.talk_tween_1)
				s.talk_tween_1 = nil
			end
			s.talk_tween_1 = Game.shop.timer:tween(0.25, s, {talky_1 = -6}, "out-cubic")
			s.talkcon_1 = 1
		end	
		if s.talktimer_2 >= 0.075 + 0.25*2 then
			s.talktimer_2 = 0.075
			s.talkcon_2 = 0
		elseif s.talktimer_2 >= 0.075 + 0.25 and s.talkcon_2 == 1 then
			if s.talk_tween_2 then
				Game.shop.timer:cancel(s.talk_tween_2)
				s.talk_tween_2 = nil
			end
			s.talk_tween_2 = Game.shop.timer:tween(0.25, s, {talky_2 = 0}, "in-sine")
			s.talkcon_2 = 2
		elseif s.talktimer_2 >= 0.075 and s.talkcon_2 == 0 then
			if s.talk_tween_2 then
				Game.shop.timer:cancel(s.talk_tween_2)
				s.talk_tween_2 = nil
			end
			s.talk_tween_2 = Game.shop.timer:tween(0.25, s, {talky_2 = -10}, "out-cubic")
			s.talkcon_2 = 1
		end
		s.talktimer_1 = sprite.talktimer_1 + DT
		s.talktimer_2 = sprite.talktimer_2 + DT
		s.talk_ended = false
	else
		if not s.talk_ended then
			if s.talktimer_1 >= 0.25 and s.talkcon_1 == 1 then
				if s.talk_tween_1 then
					Game.shop.timer:cancel(s.talk_tween_1)
					s.talk_tween_1 = nil
				end
				s.talk_tween_1 = Game.shop.timer:tween(0.25, s, {talky_1 = 0}, "in-sine")
				s.talkcon_1 = 2
			end	
			if s.talktimer_2 >= 0.075 + 0.25*2 then
				s.talk_ended = true
			elseif s.talktimer_2 >= 0.075 + 0.25 and s.talkcon_2 == 1 then
				if s.talk_tween_2 then
					Game.shop.timer:cancel(s.talk_tween_2)
					s.talk_tween_2 = nil
				end
				s.talk_tween_2 = Game.shop.timer:tween(0.25, s, {talky_2 = 0}, "in-sine")
				s.talkcon_2 = 2
			end
			s.talktimer_1 = sprite.talktimer_1 + DT
			s.talktimer_2 = sprite.talktimer_2 + DT
		else
			if s.talk_tween_1 then
				Game.shop.timer:cancel(s.talk_tween_1)
				s.talk_tween_1 = nil
			end
			if s.talk_tween_2 then
				Game.shop.timer:cancel(s.talk_tween_2)
				s.talk_tween_2 = nil
			end
			s.talky_1 = 0
			s.talky_2 = 0
			s.talktimer_1 = -DT
			s.talkcon_1 = 0
			s.talktimer_2 = -DT
			s.talkcon_2 = 0
		end
	end
	s.head.y = s.talky_2 + 92 - 3
	s.torso.y = s.talky_1 + 90 - 3
    s.head:setOrigin(0.5 + -spx/6, 1 + sp/6)
    s.torso:setOrigin(-spx/10, 0 + sp/10)

    s.c_1.x = 56 + spx*25
    s.c_1.y = s.talky_2 + 73 - sp*25

    s.c_2.x = 103 + spx*25
    s.c_2.y = s.talky_2 + 73 - sp*25
    
    local e1 = s.e_1
    local e2 = s.e_2
    local e1b = s.e_1_b
    local e2b = s.e_2_b
    if s.anim == "huh" or s.anim == "talk_huh" then
		e1:setSprite(self.path.."/eye_huh_1")
		e2:setSprite(self.path.."/eye_huh_2")
		undoBlink(s)
		e1.rotation = MathUtils.angleLerp(e1.rotation, spx*1.1, s.transition_timer)
		e1.x = MathUtils.lerp(e1.x, 60 + spx*40, s.transition_timer)
		e1.y = MathUtils.lerp(e1.y, s.talky_2 + 66 - sp*25, s.transition_timer)

		e2.rotation = MathUtils.angleLerp(e2.rotation, spx*1.1, s.transition_timer)
		e2.x = MathUtils.lerp(e2.x, 98 + spx*40, s.transition_timer)
		e2.y = MathUtils.lerp(e2.y, s.talky_2 + 66 - sp*25, s.transition_timer)
		
		e1b.rotation = MathUtils.angleLerp(e1b.rotation, spx*1.1, s.transition_timer)
		e1b.x = MathUtils.lerp(e1b.x, 60 + spx*40, s.transition_timer)
		e1b.y = MathUtils.lerp(e1b.y, s.talky_2 + 66 - sp*25, s.transition_timer)

		e2b.rotation = MathUtils.angleLerp(e2b.rotation, spx*1.1, s.transition_timer)
		e2b.x = MathUtils.lerp(e2b.x, 98 + spx*40, s.transition_timer)
		e2b.y = MathUtils.lerp(e2b.y, s.talky_2 + 66 - sp*25, s.transition_timer)
	elseif s.anim == "blink" or s.anim == "talk_blink" then
		e1:setSprite(self.path.."/eye")
		e2:setSprite(self.path.."/eye")
		doBlink(s)
		e1.rotation = MathUtils.angleLerp(e1.rotation, spx*1.5, s.transition_timer)
		e1.x = MathUtils.lerp(e1.x, 60 + spx*40, s.transition_timer)
		e1.y = MathUtils.lerp(e1.y, s.talky_2 + 66 - sp*25, s.transition_timer)

		e2.rotation = MathUtils.angleLerp(e2.rotation, spx*1.5, s.transition_timer)
		e2.x = MathUtils.lerp(e2.x, 98 + spx*40, s.transition_timer)
		e2.y = MathUtils.lerp(e2.y, s.talky_2 + 66 - sp*25, s.transition_timer)
		
		e1b.rotation = MathUtils.angleLerp(e1b.rotation, spx*1.5, s.transition_timer)
		e1b.x = MathUtils.lerp(e1b.x, 60 + spx*40, s.transition_timer)
		e1b.y = MathUtils.lerp(e1b.y, s.talky_2 + 66 - sp*25, s.transition_timer)

		e2b.rotation = MathUtils.angleLerp(e2b.rotation, spx*1.5, s.transition_timer)
		e2b.x = MathUtils.lerp(e2b.x, 98 + spx*40, s.transition_timer)
		e2b.y = MathUtils.lerp(e2b.y, s.talky_2 + 66 - sp*25, s.transition_timer)
	elseif s.anim == "lookdown" or s.anim == "talk_lookdown" then
		e1:setSprite(self.path.."/eye")
		e2:setSprite(self.path.."/eye")
		undoBlink(s)
		e1.rotation = MathUtils.angleLerp(e1.rotation, spx*1.5, s.transition_timer)
		e1.x = MathUtils.lerp(e1.x, 60 + spx*40, s.transition_timer)
		e1.y = MathUtils.lerp(e1.y, s.talky_2 + 71 - sp*25, s.transition_timer)

		e2.rotation = MathUtils.angleLerp(e2.rotation, spx*1.5, s.transition_timer)
		e2.x = MathUtils.lerp(e2.x, 98 + spx*40, s.transition_timer)
		e2.y = MathUtils.lerp(e2.y, s.talky_2 + 71 - sp*25, s.transition_timer)
		
		e1.rotation = MathUtils.angleLerp(e1b.rotation, spx*1.5, s.transition_timer)
		e1.x = MathUtils.lerp(e1b.x, 60 + spx*40, s.transition_timer)
		e1.y = MathUtils.lerp(e1b.y, s.talky_2 + 71 - sp*25, s.transition_timer)

		e2b.rotation = MathUtils.angleLerp(e2b.rotation, spx*1.5, s.transition_timer)
		e2b.x = MathUtils.lerp(e2b.x, 98 + spx*40, s.transition_timer)
		e2b.y = MathUtils.lerp(e2b.y, s.talky_2 + 71 - sp*25, s.transition_timer)
	elseif s.anim == "look_left" or s.anim == "talk_look_left" then
		e1:setSprite(self.path.."/eye")
		e2:setSprite(self.path.."/eye")
		undoBlink(s)
		e1.rotation = MathUtils.angleLerp(e1.rotation, spx*1.25, s.transition_timer)
		e1.x = MathUtils.lerp(e1.x, 70 + sp*20, s.transition_timer)
		e1.y = MathUtils.lerp(e1.y, s.talky_2 + 74 - sp*25, s.transition_timer)

		e2.rotation = MathUtils.angleLerp(e2.rotation, spx*1.25, s.transition_timer)
		e2.x = MathUtils.lerp(e2.x, 109 + sp*20, s.transition_timer)
		e2.y = MathUtils.lerp(e2.y, s.talky_2 + 74 - sp*25, s.transition_timer)
		
		e1b.rotation = MathUtils.angleLerp(e1b.rotation, spx*1.25, s.transition_timer)
		e1b.x = MathUtils.lerp(e1b.x, 70 + sp*20, s.transition_timer)
		e1b.y = MathUtils.lerp(e1b.y, s.talky_2 + 74 - sp*25, s.transition_timer)

		e2b.rotation = MathUtils.angleLerp(e2b.rotation, spx*1.25, s.transition_timer)
		e2b.x = MathUtils.lerp(e2b.x, 109 + sp*20, s.transition_timer)
		e2b.y = MathUtils.lerp(e2b.y, s.talky_2 + 74 - sp*25, s.transition_timer)
	else
		e1:setSprite(self.path.."/eye")
		e2:setSprite(self.path.."/eye")
		undoBlink(s)
		e1.rotation = MathUtils.angleLerp(e1.rotation, spx*1.5, s.transition_timer)
		e1.x = MathUtils.lerp(e1.x, 60 + spx*40, s.transition_timer)
		e1.y = MathUtils.lerp(e1.y, s.talky_2 + 66 - sp*25, s.transition_timer)

		e2.rotation = MathUtils.angleLerp(e2.rotation, spx*1.5, s.transition_timer)
		e2.x = MathUtils.lerp(e2.x, 98 + spx*40, s.transition_timer)
		e2.y = MathUtils.lerp(e2.y, s.talky_2 + 66 - sp*25, s.transition_timer)
	end
	e1b.rotation = e1.rotation
	e1b.scale_x = e1.scale_x
	e1b.scale_y = e1.scale_y
	e1b.x = e1.x
	e1b.y = e1.y

	e2b.rotation = e2.rotation
	e2b.scale_x = e2.scale_x
	e2b.scale_y = e2.scale_y
	e2b.x = e2.x
	e2b.y = e2.y
	
    s.second = os.date("%S") + 0
    if s.next_time <= s.second then
        s.next_time = self:pickRandomDigit() + os.date("%S")
        if s.next_time > (59) then
            s.next_time = (s.next_time - 59)
        end
		s.head:setSprite(self.path.."/shine")
		s.head:play(1/15, false, function(ss) ss:setSprite(self.path.."/head") end)
		if s.anim ~= "blink" and s.anim ~= "talk_blink" then
			doBlink(s)
			undoBlink(s)
		end
    end
end

function actor:onSpriteDraw(sprite)
    local s = sprite
    local c1 = s.c_1
    local c2 = s.c_2
    local e1b = s.e_1_b
    local e2b = s.e_2_b
    Draw.setColor(1, 1, 1)
	
    if s.anim ~= "huh" and s.anim ~= "talk_huh" then
		love.graphics.stencil(function()
			local last_shader = love.graphics.getShader()
			love.graphics.setShader(Kristal.Shaders["Mask"])
			c1:fullDraw()
			c2:fullDraw()
			love.graphics.setShader(last_shader)
		end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		e1b:fullDraw()
		e2b:fullDraw()
		love.graphics.setStencilTest()
	end
end

return actor