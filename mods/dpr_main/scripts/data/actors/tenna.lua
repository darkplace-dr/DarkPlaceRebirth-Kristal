local actor, super = Class(Actor, "tenna")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Tenna"

    -- Width and height for this actor, used to determine its center
    self.width = 58
    self.height = 135

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/tenna"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "dance_cabbage"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {
        -- Looping animation with 0.25 seconds between each frame
        -- (even though there's only 1 idle frame)
        ["point_up"] = {"point_up", 1, true},
		["laugh_pose"] = {"laugh_pose", 1, true},
		["pose_podium"] = {"pose_podium", 1, true},
		["bow"] = {"bow", 1/2, true},
		["bow_slow"] = {"bow", 1/4, true},
		["grasp_anim"] = {"grasp_anim", 1/3, true},
		["grasp_anim_b"] = {"grasp_anim_b", 1/2, true},
		["dance_cane"] = {"dance_cane/dance_cane", 1/30, true},
		["dance_cabbage"] = {"dance_cabbage/dance_cabbage", 1/30, true},
		["point_at_screen"] = {"point_at_screen", 1, true},
		["pose"] = {"pose", 1, true},
		["hooray"] = {"hooray", 1, true},
		["twirl"] = {"twirl", 1/30, true},
		["bulletin"] = {"bulletin", 1/7, true},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["point_up"] = {0, 0},
		["laugh_pose"] = {42-47, 92-133},
		["pose_podium"] = {77-47, 136-133},
		["bow"] = {49-47, 131-133},
		["grasp_anim"] = {46-47, 119-133},
		["grasp_anim_b"] = {46-47, 119-133},
		["dance_cane/dance_cane"] = {55-47, 132-133},
		["dance_cabbage/dance_cabbage"] = {30-47, 118-133},
		["point_at_screen"] = {48-47, 114-133},
		["pose"] = {35-47, 129-133},
		["hooray"] = {55-47, 103-133},
		["twirl"] = {35-47, 138-133},
		["bulletin"] = {43-47, 113-133},
    }
    self.disallow_replacement_texture = true
	self.wobblestate = 0
	self.wobbleamt = 8
	self.wobbletime = 4
	self.drawtype = 0
	self.reversal = 0
	self.speedscale = 1
	self.animchangetimer = 0
	self.changespeed = 0
	self.shakey = 0
	self.bounce = 0
	self.pointcon = 0
	self.rate = 0
	self.shtimer = 0
	self.siner = 0
end

function actor:onSpriteInit(sprite)
    super.onSpriteInit(sprite)
	
    sprite:setScale(1)
	sprite.xscale = 2
	sprite.yscale = 2
	if sprite.texture then
		sprite.vertices = {
			{0, 0,
			0, 0,
			1, 1, 1},
			{sprite.texture:getWidth(), 0,
			1, 0,
			1, 1, 1},
			{sprite.texture:getWidth(), sprite.texture:getHeight(),
			1, 1,
			1, 1, 1},
			{0, sprite.texture:getHeight(),
			0, 1,
			1, 1, 1}
		}
		sprite.mesh = love.graphics.newMesh(sprite.vertices, "fan")
		sprite.mesh:setTexture(sprite.texture)
	end
end

function actor:resetMesh(sprite)
	if sprite.texture then
		sprite.vertices = {
			{0, 0,
			0, 0,
			1, 1, 1},
			{sprite.texture:getWidth(), 0,
			1, 0,
			1, 1, 1},
			{sprite.texture:getWidth(), sprite.texture:getHeight(),
			1, 1,
			1, 1, 1},
			{0, sprite.texture:getHeight(),
			0, 1,
			1, 1, 1}
		}
		sprite.mesh = love.graphics.newMesh(sprite.vertices, "fan")
		sprite.mesh:setTexture(sprite.texture)
	end
end

function actor:setPreset(preset)
	local preset = preset or 0
	
	self.drawtype = 0
	if preset == 0 then -- disable wobbling
		self.wobblestate = 0
		self.wobbletime = 0
		self.wobbleamt = 0
		self.drawtype = 1
	end
	if preset == 1 then
		self.wobblestate = 1
		self.wobbletime = 4
		self.wobbleamt = 10
	end
	if preset == 2 then -- tenna point up
		self.wobblestate = 1
		self.wobbletime = 4
		self.wobbleamt = 8
	end
	if preset == 3 then -- tenna listening
		self.wobblestate = 1
		self.wobbletime = 4
		self.wobbleamt = 30
	end
	if preset == 4 then -- tenna laugh pose
		self.wobblestate = 3
		self.wobbletime = 3
		self.wobbleamt = 15
	end
	if preset == 5 then
		self.reversal = 0
		self.wobblestate = 4
		self.animchangetimer = 8
		self.changespeed = 20
		self.wobbletime = 4
		self.wobbleamt = 40
	end
	if preset == 6 then -- tenna bow 1
		self.wobblestate = 5
		self.wobbletime = 3
		self.wobbleamt = 10
	end
	if preset == 7 then -- tenna sad 1
		self.wobblestate = 6
		self.wobbletime = 12
		self.wobbleamt = 20
	end
	if preset == 8 then
		self.wobblestate = 6
		self.wobbletime = 1
		self.wobbleamt = 2
	end
	if preset == 8 then
		self.wobblestate = 6
		self.wobbletime = 1
		self.wobbleamt = 2
	end
	if preset == 9 then
		self.wobblestate = 7
		self.wobbletime = 0.5
		self.wobbleamt = 2
	end
	if preset == 11 then -- tenna bow 2
		self.wobblestate = 8
		self.wobbletime = 1
		self.wobbleamt = 10
	end
	if preset == 12 then -- tenna grasp anim
		self.wobblestate = 1
		self.wobbletime = 2
		self.wobbleamt = 20
	end
	if preset == 13 then -- tenna grasp anim b
		self.wobblestate = 6
		self.wobbletime = 2
		self.wobbleamt = 20
		self.drawtype = 1
	end
	if preset == 14 then -- tenna evil
		self.wobblestate = 7
		self.wobbletime = 1
		self.wobbleamt = 2
	end
	if preset == 15 then
		self.wobblestate = 6
		self.wobbletime = 0.5
		self.wobbleamt = 6
	end
	if preset == 16 then
		self.wobblestate = 10
		self.wobbletime = 3
		self.wobbleamt = 30
	end
	if preset == 18 then
		self.reversal = 0
		self.wobblestate = 4
		self.animchangetimer = 4
		self.wobbletime = 4
		self.wobbleamt = 40
	end
	if preset == 19 then
	end
	if preset == 20 then
		self.wobblestate = 5
		self.wobbletime = 3
		self.wobbleamt = 30
	end
	if preset == 21 then
		self.wobblestate = 12
		self.wobbletime = 4.5
		self.wobbleamt = 7
	end	
	if preset == 22 then -- tenna pose
		self.wobblestate = 7
		self.wobbletime = 2.4
		self.wobbleamt = 5.9
	end
	if preset == 23 then -- tenna dance cabbage
		self.wobblestate = 8
		self.wobbletime = 6
		self.wobbleamt = 7.7
	end
	if preset == 26 then 
		self.wobblestate = 5.5
		self.wobbletime = 10
		self.wobbleamt = 40
		self.siner = 1.5707963267948966 * self.wobbletime
	end
	if preset == 27 then
		self.bounce = 0
	end
	if preset == 28 then 
		self.wobblestate = 1
		self.wobbletime = 10
		self.wobbleamt = 30
		self.bounce = 1
	end
	if preset == 31 then 
		self.wobblestate = 12
		self.wobbletime = 5
		self.wobbleamt = 15
		self.bounce = 0
	end
	if preset == 32 then 
		self.wobblestate = 12
		self.wobbletime = 4.5
		self.wobbleamt = 7
	end
	if preset == 33 then 
		self.reversal = 0
		self.wobblestate = 8
		self.wobbletime = 4
		self.wobbleamt = 40
	end
	if preset == 34 then 
		self.reversal = 0
		self.wobblestate = 13
		self.changespeed = 15
		self.animchangetimer = 0
		self.pointcon = 0
		self.wobbletime = 4
		self.wobbleamt = 10
	end
	if preset == 35 then 
		self.reversal = 0
		self.wobblestate = -1
		self.rate = 2
		self.shtimer = 0
		self.pointcon = 0
		self.drawtype = 2
	end
	if preset == 36 then 
		self.reversal = 0
		self.siner = 0
		self.wobbletime = 10
		self.wobbleamt = 16
	end
	if preset == 36 then 
		self.reversal = 0
		self.siner = 0
		self.wobbletime = 10
		self.wobbleamt = 14
	end
	if preset == 69 then 
		self.wobblestate = 6
		self.wobbletime = 4
		self.wobbleamt = 20
	end
end

function actor:onSet(sprite)
    super.onSet(sprite)
	
    self:resetMesh(sprite)
end

function actor:onSetSprite(sprite)
    super.onSetSprite(sprite)
	
    self:resetMesh(sprite)
end

function actor:onSetAnimation(sprite)
    super.onSetAnimation(sprite)
	
    self:resetMesh(sprite)
end

function actor:onResetSprite(sprite)
    super.onResetSprite(sprite)
	
    self:resetMesh(sprite)
end

function actor:preSpriteDraw(sprite)
    super.preSpriteDraw(sprite)
	
	sprite.actor.siner = sprite.actor.siner + sprite.actor.speedscale * DTMULT
	if sprite.texture and sprite.mesh then
		sprite.mesh:setTexture(sprite.texture)
		sprite.x1 = 0
		sprite.y1 = 0
		sprite.x2 = sprite.texture:getWidth()
		sprite.y2 = 0
		sprite.x3 = sprite.texture:getWidth()
		sprite.y3 = sprite.texture:getHeight()
		sprite.x4 = 0
		sprite.y4 = sprite.texture:getHeight()
		local reversalsign = 1
		if sprite.actor.reversal == 1 then
			reversalsign = -1
		end
		local wobblestate = sprite.actor.wobblestate
		local wobbleamt = sprite.actor.wobbleamt
		local wobbletime = sprite.actor.wobbletime
		if sprite.actor.wobblestate == 1 then
			sprite.x1 = sprite.x1 + (math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt) * reversalsign)
			sprite.x2 = sprite.x2 + (math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt) * reversalsign)
			sprite.y1 = sprite.y1 - math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt)
			sprite.y2 = sprite.y2 + math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt)
		end
		if sprite.actor.wobblestate == 2 then
			sprite.x1 = sprite.x1 + (math.sin(sprite.actor.siner / wobbletime) * 10) * reversalsign
			sprite.x2 = sprite.x2 + (math.sin(sprite.actor.siner / wobbletime) * 10) * reversalsign
			sprite.y1 = sprite.y1 - math.abs(math.sin(sprite.actor.siner / wobbletime) * 0.9) * 14
			sprite.y2 = sprite.y2 + math.abs(math.sin(sprite.actor.siner / wobbletime) * 1.1) * 14
		end
		if sprite.actor.wobblestate == 3 then
			if math.sin(sprite.actor.siner / wobbletime) < 0 then
				sprite.actor.reversal = 1
			else
				sprite.actor.reversal = 0
			end
			local addamt = math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt)
			local addamt2 = addamt
			if sprite.actor.reversal == 1 then
				addamt = -addamt
			end
			sprite.x1 = sprite.x1 + addamt
			sprite.x2 = sprite.x2 + addamt
			sprite.y1 = sprite.y1 - addamt2
			sprite.y2 = sprite.y2 + addamt2
		end
		if sprite.actor.wobblestate == 4 then
			if math.sin(sprite.actor.siner / wobbletime) < 0 then
				sprite.actor.reversal = 1
			else
				sprite.actor.reversal = 0
			end
			local addamt = math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt)
			local addamt2 = addamt
			if sprite.actor.reversal == 1 then
				addamt = -addamt
			end
			sprite.x1 = sprite.x1 + addamt
			sprite.x2 = sprite.x2 + addamt
			sprite.y1 = sprite.y1 - addamt2
			sprite.y2 = sprite.y2 + addamt2
		end
		if sprite.actor.wobblestate == 5 then
			if math.sin(sprite.actor.siner / wobbletime) < 0 then
				sprite.actor.reversal = 1
			else
				sprite.actor.reversal = 0
			end
			local addamt = math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt)
			local addamt2 = addamt
			if sprite.actor.reversal == 1 then
				addamt = -addamt
			end
			sprite.x1 = sprite.x1 + addamt
			sprite.x2 = sprite.x2 + addamt
			sprite.y1 = sprite.y1 - addamt2
			sprite.y2 = sprite.y2 + addamt2
		end
		if sprite.actor.wobblestate == 6 then
			sprite.x1 = sprite.x1 + ((math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt) - wobbleamt) * reversalsign)
			sprite.x2 = sprite.x2 + ((math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt) - wobbleamt) * reversalsign)
			sprite.y1 = sprite.y1 - (math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt) - wobbleamt)
			sprite.y2 = sprite.y2 + (math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt) - wobbleamt) / 2
		end
		if sprite.actor.wobblestate == 7 then
			sprite.x1 = sprite.x1 + ((math.sin(sprite.actor.siner / wobbletime) * wobbleamt) * reversalsign)
			sprite.x2 = sprite.x2 + ((math.sin(sprite.actor.siner / wobbletime) * wobbleamt) * reversalsign)
			sprite.y1 = sprite.y1 - ((math.sin((sprite.actor.siner / wobbletime) * 0.5) - wobbleamt) / 2) * -1
			sprite.y2 = sprite.y2 + (math.sin((sprite.actor.siner / wobbletime) * 0.5) * wobbleamt) / 3
		end
		if sprite.actor.wobblestate == 8 then
			local addamt = math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt)
			local addamt2 = addamt
			if sprite.actor.reversal == 1 then
				addamt = -addamt
			end
			sprite.x1 = sprite.x1 + addamt
			sprite.x2 = sprite.x2 + addamt
			sprite.y1 = sprite.y1 - addamt2
			sprite.y2 = sprite.y2 + addamt2
		end
		if sprite.actor.wobblestate == 9 then
			sprite.y1 = sprite.y1 - math.abs(math.sin(sprite.actor.siner / wobbletime) * 0.9) * 14
			sprite.y2 = sprite.y2 + math.abs(math.sin(sprite.actor.siner / wobbletime) * 1.1) * 14
		end
		if sprite.actor.wobblestate == 5 then
			local localReverse = 0
			
			if math.sin(sprite.actor.siner / wobbletime) < 0 then
				localReverse = 1
			else
				localReverse = 0
			end
			local addamt = math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt)
			local addamt2 = addamt
			if localReverse == 1 then
				addamt = -addamt
			end
			sprite.x1 = sprite.x1 + addamt
			sprite.x2 = sprite.x2 + addamt
			sprite.y1 = sprite.y1 - addamt2
			sprite.y2 = sprite.y2 + addamt2
		end
		if sprite.actor.wobblestate == 12 then
			local amt = math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt)
			local amt2 = math.abs(math.cos(sprite.actor.siner / wobbletime) * wobbleamt)
			sprite.x1 = sprite.x1 + amt
			sprite.x2 = sprite.x2 + amt2 /2
			sprite.y1 = sprite.y1 + amt
			sprite.y2 = sprite.y2 + amt
		end
		if sprite.actor.wobblestate == 17 then
			sprite.x1 = sprite.x1 - ((math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt) - wobbleamt) * reversalsign)
			sprite.x2 = sprite.x2 - ((math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt) - wobbleamt) * reversalsign)
			sprite.y1 = sprite.y1 + (math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt) - wobbleamt)
			sprite.y2 = sprite.y2 - (math.abs(math.sin(sprite.actor.siner / wobbletime) * wobbleamt) - wobbleamt) / 2
		end
		if sprite.actor.drawtype == 0 then
			if sprite.xscale ~= 2 then
				sprite.x1 = sprite.x1 * (sprite.xscale / 2)
				sprite.x2 = sprite.x2 * (sprite.xscale / 2)
				sprite.x3 = sprite.x3 * (sprite.xscale / 2)
				sprite.x4 = sprite.x4 * (sprite.xscale / 2)
			end
			if sprite.yscale ~= 2 then
				sprite.y1 = sprite.y1 * (sprite.yscale / 2)
				sprite.y2 = sprite.y2 * (sprite.yscale / 2)
				sprite.y3 = sprite.y3 * (sprite.yscale / 2)
				sprite.y4 = sprite.y4 * (sprite.yscale / 2)
			end
			if sprite.actor.shakey ~= 0 then
				sprite.y1 = sprite.y1 + sprite.actor.shakey
				sprite.y2 = sprite.y2 + sprite.actor.shakey
				sprite.y3 = sprite.y3 + sprite.actor.shakey
				sprite.y4 = sprite.y4 + sprite.actor.shakey
			end
			sprite.mesh:setVertex(1, sprite.x1, sprite.y1, 0, 0, 1, 1, 1, 1)
			sprite.mesh:setVertex(2, sprite.x2, sprite.y2, 1, 0, 1, 1, 1, 1)
			sprite.mesh:setVertex(3, sprite.x3, sprite.y3, 1, 1, 1, 1, 1, 1)
			sprite.mesh:setVertex(4, sprite.x4, sprite.y4, 0, 1, 1, 1, 1, 1)
			love.graphics.draw(sprite.mesh, 0, 0)
			return true
		elseif sprite.actor.drawtype == 1 then
			return false
		end
	end
end

return actor