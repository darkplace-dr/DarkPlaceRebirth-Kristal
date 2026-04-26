local actor, super = Class(Actor, "arlee_shop")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "*+arlee*+"
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
    self.path = "world/npcs/arlee/shop"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "face"
	self.voice = "arlee"

    -- Table of sprite animations
    self.animations = {
        ["face"] = {"torso"},
        ["angry"] = {"torso"},
        ["happy"] = {"torso"},
        ["happyClosed"] = {"torso"},
        ["blink"] = {"torso"},
        ["sad"] = {"torso"},
    }

	self.offsets = {
        ["torso"] = {0, 128},
    }
end

function actor:onSpriteInit(sprite)
    super.onSpriteInit(sprite)
    sprite.alpha = 0

	sprite.antenna = Sprite(self.path.."/antenna")
    sprite.antenna.x = 64
    sprite.antenna.y = 16
    sprite.antenna:setOrigin(1, 1)
	sprite:addChild(sprite.antenna)

	sprite.antennaB = Sprite(self.path.."/antennab")
    sprite.antennaB.x = 64
    sprite.antennaB.y = 16
    sprite.antennaB:setOrigin(0, 1)
	sprite:addChild(sprite.antennaB)

    sprite.head = Sprite(self.path.."/head")
    sprite.head.x = 79
    sprite.head.y = 104
    sprite.head:setOrigin(0.5, 1)
    sprite:addChild(sprite.head)

	sprite.face = Sprite(self.path.."/face")
    sprite.face.x = 80
    sprite.face.y = 80
    sprite.face:setOrigin(0.5, 1)
	sprite:addChild(sprite.face)

    sprite.e_1 = Sprite(self.path.."/eye")
    sprite.e_1.x = 58
    sprite.e_1.y = 50
    sprite.e_1:setOrigin(0.5, 0.5)
	sprite:addChild(sprite.e_1)

    sprite.e_2 = Sprite(self.path.."/eyeB")
    sprite.e_2.x = 98
    sprite.e_2.y = 50
    sprite.e_2:setOrigin(0.5, 0.5)
	sprite:addChild(sprite.e_2)

    sprite.torso = Sprite(self.path.."/torso")
    sprite.torso.x = 80
    sprite.torso.y = 40
	sprite.torso:setOrigin(0.5, 0)
    sprite:addChild(sprite.torso)

	sprite.ziper = Sprite(self.path.."/ziper")
    sprite.ziper.x = 80
    sprite.ziper.y = 92
	sprite.ziper:setOrigin(0.5, 0)
    sprite:addChild(sprite.ziper)

	sprite.hand = Sprite(self.path.."/handL")
    sprite.hand.x = 28
    sprite.hand.y = 128
	sprite.hand:setOrigin(0.5, 0)
    sprite:addChild(sprite.hand)

	sprite.handB = Sprite(self.path.."/handR")
    sprite.handB.x = 132
    sprite.handB.y = 128
	sprite.handB:setOrigin(0.5, 0)
    sprite:addChild(sprite.handB)

    sprite.timer = 0
    sprite.next_time = (os.date("%S") + self:pickRandomDigit())
	sprite.next_shake = (os.date("%S") + self:pickRandomDigit())

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

    sprite.shake = 0
	sprite.target_head_rot = 0
	sprite.dart_timer = 0
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
    e1:setScale(1, 1)
    e2:setScale(1, 1)
end

local function doBlink(s)
    local e1 = s.e_1
    local e2 = s.e_2
    e1:setScale(1, 0)
    e2:setScale(1, 0)

	s.blinked = true
end

function actor:onSpriteUpdate(sprite)
    super.onSpriteUpdate(sprite)
    local h = sprite.head
    local max = 0.09
    local s = sprite
    
    local spx = math.sin(love.timer.getTime()) * max

	local sx = 0
    local sy = 0

    if sprite.shake > 0 then
        sx = math.random(-sprite.shake, sprite.shake)
        sy = math.random(-sprite.shake, sprite.shake)
    end

	s.head_timer = (s.head_timer or 0) - DT
    if s.head_timer <= 0 then
        s.target_head_rot = (math.random() - 0.5) * 0.16
        s.head_timer = math.random(15, 35) * 0.1 
    end

	s.head.rotation = MathUtils.lerpEaseOut(s.head.rotation, s.target_head_rot, 0.1 * DTMULT, 1)
	s.ziper.rotation = spx*2
	s.face.rotation = MathUtils.lerpEaseOut(s.head.rotation, s.target_head_rot, 0.1 * DTMULT, 1)

	s.face.x = 79 + sx
    s.face.y = 80 + sy

    s.timer = sprite.timer + DT

    local sp = spx
    if sp > 0 then sp = sp*-1 end
	
	s.transition_timer = MathUtils.lerpEaseOut(s.transition_timer, 1, 0.25*DTMULT, 1)

    s.head:setOrigin(0.5, 1 + sp/6)
    
    local e1 = s.e_1
    local e2 = s.e_2
	local antenna = s.antenna
	local antennaB = s.antennaB
	local hand = s.hand
	local handB = s.handB
	local torso = s.torso
	local ziper = s.ziper

	e1:setSprite(self.path.."/eye")
	e2:setSprite(self.path.."/eyeB")
	undoBlink(s)

	s.dart_timer = s.dart_timer - DT
    if s.dart_timer <= 0 then
        s.dart_x = math.random(-3, 3)
        s.dart_y = math.random(-2, 2)
        s.dart_timer = math.random(4, 16) * 0.1
    end

    e1.x = MathUtils.lerp(e1.x, 62 + spx*40 + s.dart_x, s.transition_timer)
    e1.y = MathUtils.lerp(e1.y, 50 - sp*25 + s.dart_y, s.transition_timer)

    e2.x = MathUtils.lerp(e2.x, 94 + spx*40 + s.dart_x, s.transition_timer)
    e2.y = MathUtils.lerp(e2.y, 50 - sp*25 + s.dart_y, s.transition_timer)

	antenna.rotation = MathUtils.angleLerp(antenna.rotation, spx, s.transition_timer)
	antenna.x = MathUtils.lerp(antenna.x, 96 + spx*40, s.transition_timer)
	antenna.y = MathUtils.lerp(antenna.y, -14 - sp*25, s.transition_timer)

	antennaB.rotation = MathUtils.angleLerp(antennaB.rotation, spx*2, s.transition_timer)
	antennaB.x = MathUtils.lerp(antennaB.x, 96 + spx*40, s.transition_timer)
	antennaB.y = MathUtils.lerp(antennaB.y, -14 - sp*25, s.transition_timer)

    hand.y = MathUtils.lerp(hand.y, 128 - sp*40, s.transition_timer)
	handB.y = MathUtils.lerp(handB.y, 128 - sp*40, s.transition_timer)

	torso.y = MathUtils.lerp(torso.y, 40 - sp*30, s.transition_timer)
	ziper.y = MathUtils.lerp(ziper.y, 92 - sp*30, s.transition_timer)
	
	if s.anim == "angry" then
		s.face:setSprite(self.path.."/angry")
	elseif s.anim == "happy" then
		s.face:setSprite(self.path.."/happy")
	elseif s.anim == "sad" then
		s.face:setSprite(self.path.."/sad")
	elseif s.anim == "happyClosed" then
		s.face:setSprite(self.path.."/happyClosed")
		e1:setScale(0, 0)
    	e2:setScale(0, 0)
	else
		s.face:setSprite(self.path.."/face")
	end

    s.second = os.date("%S") + 0
    if s.next_time <= s.second and not s.anim == "happyClosed" then
        s.next_time = self:pickRandomDigit() + os.date("%S")
        if s.next_time > (59) then
            s.next_time = (s.next_time - 59)
        end
		s.face:setSprite(self.path.."/blink")
		doBlink(s)
		s.face:play(1/15, false, function(ss) ss:setSprite(self.path.."/face") end)
    end

	if s.next_shake <= s.second then
		s.next_shake = self:pickRandomDigit() + os.date("%S")
        if s.next_shake > (59) then
            s.next_shake = (s.next_shake - 59)
        end
		
		s.shake = 1
	end

	sprite.shake = math.max(0, sprite.shake - DT * 5)
end

return actor