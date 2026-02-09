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

    sprite.torso = Sprite(self.path.."/torso")
    sprite.torso.x = -3
    sprite.torso.y = 90 - 3
    sprite:addChild(sprite.torso)

    sprite.timer = 0
    sprite.next_time = (os.date("%S") + self:pickRandomDigit())

	sprite.circle = Assets.getTexture(self.path.."/circle")
	sprite.eye_bright_shadow = Assets.getTexture(self.path.."/eye_bright_shadow")
	sprite.eye_tween_1 = nil
	sprite.eye_tween_2 = nil
	sprite.blinked = false
	sprite.talky_1 = 0
	sprite.talktimer_1 = 0
	sprite.talkcon_1 = 0
	sprite.talk_tween_1 = nil
	sprite.talky_2 = 0
	sprite.talktimer_2 = 0
	sprite.talkcon_2 = 0
	sprite.talk_tween_1 = nil
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

function actor:onSpriteDraw(sprite)
    super.onSpriteDraw(sprite)
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
	
	s.transition_timer = MathUtils.approach(s.transition_timer, 1, 0.25*DTMULT)

    if s.anim == "talk" or s.anim == "talk_huh" or s.anim == "talk_blink" or s.anim == "talk_look_left" or s.anim == "talk_lookdown" then
		s.talktimer_1 = sprite.talktimer_1 + DT
		s.talktimer_2 = sprite.talktimer_2 + DT
		if s.talktimer_1 >= 0.35*2 then
			s.talktimer_1 = 0
			s.talkcon_1 = 0
		elseif s.talktimer_1 >=  0.35 and s.talkcon_1 == 1 then
			if s.talk_tween_1 then
				Game.shop.timer:cancel(s.talk_tween_1)
				s.talk_tween_1 = nil
			end
			s.talk_tween_1 = Game.shop.timer:tween(0.35, s, {talky_1 = 0}, "in-sine")
			s.talkcon_1 = 2
		elseif s.talkcon_1 == 0 then
			if s.talk_tween_1 then
				Game.shop.timer:cancel(s.talk_tween_1)
				s.talk_tween_1 = nil
			end
			s.talk_tween_1 = Game.shop.timer:tween(0.35, s, {talky_1 = -6}, "out-cubic")
			s.talkcon_1 = 1
		end	
		if s.talktimer_2 >= 0.075 + 0.35*2 then
			s.talktimer_2 = 0.075
			s.talkcon_2 = 0
		elseif s.talktimer_2 >= 0.075 + 0.35 and s.talkcon_2 == 1 then
			if s.talk_tween_2 then
				Game.shop.timer:cancel(s.talk_tween_2)
				s.talk_tween_2 = nil
			end
			s.talk_tween_2 = Game.shop.timer:tween(0.35, s, {talky_2 = 0}, "in-sine")
			s.talkcon_2 = 2
		elseif s.talktimer_2 >= 0.075 and s.talkcon_2 == 0 then
			if s.talk_tween_2 then
				Game.shop.timer:cancel(s.talk_tween_2)
				s.talk_tween_2 = nil
			end
			s.talk_tween_2 = Game.shop.timer:tween(0.35, s, {talky_2 = -10}, "out-cubic")
			s.talkcon_2 = 1
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
		s.talk_tween_1 = Game.shop.timer:tween(0.35, s, {talky_1 = 0, talky_2 = 0}, "in-sine")
		s.talktimer_1 = 0
		s.talkcon_1 = 0
		s.talktimer_2 = 0
		s.talkcon_2 = 0
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
    if s.anim == "huh" or s.anim == "talk_huh" then
		e1:setSprite(self.path.."/eye_huh_1")
		e2:setSprite(self.path.."/eye_huh_2")
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
			s.blinked = false
		end
		e1.rotation = MathUtils.angleLerp(e1.rotation, spx*1.1, s.transition_timer)
		e1.x = MathUtils.lerp(e1.x, 60 + spx*40, s.transition_timer)
		e1.y = MathUtils.lerp(e1.y, s.talky_2 + 66 - sp*25, s.transition_timer)

		e2.rotation = MathUtils.angleLerp(e2.rotation, spx*1.1, s.transition_timer)
		e2.x = MathUtils.lerp(e2.x, 98 + spx*40, s.transition_timer)
		e2.y = MathUtils.lerp(e2.y, s.talky_2 + 66 - sp*25, s.transition_timer)
	elseif s.anim == "blink" or s.anim == "talk_blink" then
		e1:setSprite(self.path.."/eye")
        e1:setScale(2, 0.2)
		e2:setSprite(self.path.."/eye")
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
		e1.rotation = MathUtils.angleLerp(e1.rotation, spx*1.5, s.transition_timer)
		e1.x = MathUtils.lerp(e1.x, 60 + spx*40, s.transition_timer)
		e1.y = MathUtils.lerp(e1.y, s.talky_2 + 66 - sp*25, s.transition_timer)

		e2.rotation = MathUtils.angleLerp(e2.rotation, spx*1.5, s.transition_timer)
		e2.x = MathUtils.lerp(e2.x, 98 + spx*40, s.transition_timer)
		e2.y = MathUtils.lerp(e2.y, s.talky_2 + 66 - sp*25, s.transition_timer)
	elseif s.anim == "lookdown" or s.anim == "talk_lookdown" then
		e1:setSprite(self.path.."/eye")
		e2:setSprite(self.path.."/eye")
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
			s.blinked = false
		end
		e1.rotation = MathUtils.angleLerp(e1.rotation, spx*1.5, s.transition_timer)
		e1.x = MathUtils.lerp(e1.x, 60 + spx*40, s.transition_timer)
		e1.y = MathUtils.lerp(e1.y, s.talky_2 + 71 - sp*25, s.transition_timer)

		e2.rotation = MathUtils.angleLerp(e2.rotation, spx*1.5, s.transition_timer)
		e2.x = MathUtils.lerp(e2.x, 98 + spx*40, s.transition_timer)
		e2.y = MathUtils.lerp(e2.y, s.talky_2 + 71 - sp*25, s.transition_timer)
	elseif s.anim == "look_left" or s.anim == "talk_look_left" then
		e1:setSprite(self.path.."/eye")
		e2:setSprite(self.path.."/eye")
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
			s.blinked = false
		end
		e1.rotation = MathUtils.angleLerp(e1.rotation, spx*1.25, s.transition_timer)
		e1.x = MathUtils.lerp(e1.x, 70 + sp*20, s.transition_timer)
		e1.y = MathUtils.lerp(e1.y, s.talky_2 + 74 - sp*25, s.transition_timer)

		e2.rotation = MathUtils.angleLerp(e2.rotation, spx*1.25, s.transition_timer)
		e2.x = MathUtils.lerp(e2.x, 109 + sp*20, s.transition_timer)
		e2.y = MathUtils.lerp(e2.y, s.talky_2 + 74 - sp*25, s.transition_timer)
	else
		e1:setSprite(self.path.."/eye")
		e2:setSprite(self.path.."/eye")
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
			s.blinked = false
		end
		e1.rotation = MathUtils.angleLerp(e1.rotation, spx*1.5, s.transition_timer)
		e1.x = MathUtils.lerp(e1.x, 60 + spx*40, s.transition_timer)
		e1.y = MathUtils.lerp(e1.y, s.talky_2 + 66 - sp*25, s.transition_timer)

		e2.rotation = MathUtils.angleLerp(e2.rotation, spx*1.5, s.transition_timer)
		e2.x = MathUtils.lerp(e2.x, 98 + spx*40, s.transition_timer)
		e2.y = MathUtils.lerp(e2.y, s.talky_2 + 66 - sp*25, s.transition_timer)
	end
	
    Draw.setColor(1, 1, 1)
	
    if s.anim ~= "huh" and s.anim ~= "talk_huh" then
		love.graphics.stencil(function()
			local last_shader = love.graphics.getShader()
			love.graphics.setShader(Kristal.Shaders["Mask"])
			Draw.draw(s.circle, s.c_1.x, s.c_1.y, s.c_1.rotation, 1, 1, 8.5, 8.5)
			Draw.draw(s.circle, s.c_2.x, s.c_2.y, s.c_2.rotation, 1, 1, 8.5, 8.5)
			love.graphics.setShader(last_shader)
		end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		Draw.draw(s.eye_bright_shadow, e1.x, e1.y, e1.rotation, e1.scale_x, e1.scale_y, 8.5, 27)
		Draw.draw(s.eye_bright_shadow, e2.x, e2.y, e2.rotation, e2.scale_x, e2.scale_y, 8.5, 27)
		love.graphics.setStencilTest()
	end
	
    s.second = os.date("%S") + 0
    if s.next_time <= s.second then
        s.next_time = self:pickRandomDigit() + os.date("%S")
        if s.next_time > (59) then
            s.next_time = (s.next_time - 59)
        end
		s.head:setSprite(self.path.."/shine")
		s.head:play(1/15, false, function(ss) ss:setSprite(self.path.."/head") end)
		if s.anim ~= "blink" and s.anim ~= "talk_blink" then
			if s.eye_tween_1 then
				Game.shop.timer:cancel(s.eye_tween_1)
				s.eye_tween_1 = nil
			end
			if s.eye_tween_2 then
				Game.shop.timer:cancel(s.eye_tween_2)
				s.eye_tween_2 = nil
			end
			e1:setScale(2, 0.2)
			s.eye_tween_1 = Game.shop.timer:tween(0.1, e1, {scale_x = 1, scale_y = 1})
			e2:setScale(2, 0.2)
			s.eye_tween_2 = Game.shop.timer:tween(0.1, e2, {scale_x = 1, scale_y = 1})
		end
    end
end

return actor