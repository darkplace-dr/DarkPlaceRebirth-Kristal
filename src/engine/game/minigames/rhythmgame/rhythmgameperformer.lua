---@class RhythmGamePerformer: Class
local RhythmGamePerformer, super = Class(Object)

function RhythmGamePerformer:init(x, y, chart)
    super.init(self, x, y)
	self.chart = chart or nil
	self.party = chart.party or nil
	self.loop = false
	self.looped_frame = 1
	self.animspeed = 1
	self.animlead = 0
	self.main_speed = 0
	self.shakeamt = 0
	self.shakereduct = 2
	self.on = 1
	self.ontimer = 0
	self.visible = false
	self:setActor(self.party.actor)
	self.width = self.sprite.texture:getWidth()
	self.height = self.sprite.texture:getHeight()
    self:setOrigin(0.5, 1)
    self:setScale(2)
	self.idle = "rhythm_game/ready"
	self.mid = "rhythm_game/play"
end

function RhythmGamePerformer:setActor(actor)
    if type(actor) == "string" then
        actor = Registry.createActor(actor)
    end

    self.actor = actor

    if self.sprite then
        self.sprite:remove()
    end

    self.sprite = self.actor:createSprite()
    self.sprite.inherit_color = true
	self:setAnimation("rhythm_game/idle")
	self:setFrame(1)
    self:addChild(self.sprite)
	self.width = self.sprite.texture:getWidth()
	self.height = self.sprite.texture:getHeight()
end

function RhythmGamePerformer:setAnimation(animation, after)
    self.sprite:setAnimation(animation, after)
	self.sprite:stop()
end

function RhythmGamePerformer:getAnimation()
    return self.sprite.anim
end

function RhythmGamePerformer:setFrame(frame)
    self.sprite:setFrame(frame)
end

function RhythmGamePerformer:playedNote()
	if self.loop then return end
	self:setFrame(1)
	self.sprite:play(1 / 10, false, function()
		self.sprite:stop()
		self:setFrame(#self.sprite.frames)
	end)
end

function RhythmGamePerformer:update()
	super.update(self)
	if not TableUtils.contains(Game.minigame.rhythm_game_update_states, Game.minigame.state) then 
		return
	end
	if self.loop then
		if self.animspeed < 1 and Game.minigame.song.signature == 3 then
			self.looped_frame = (((Game.minigame.trackpos + self.animlead) / 3 / Game.minigame.song.notespacing) % 1) * #self.sprite.frames
		else
			self.looped_frame = ((((Game.minigame.trackpos + self.animlead) * self.animspeed) / Game.minigame.song.notespacing) % 1) * #self.sprite.frames
		end
		self:setFrame(math.floor(self.looped_frame) + 1)
	end
end

function RhythmGamePerformer:draw()
	if not TableUtils.contains(Game.minigame.rhythm_game_draw_states, Game.minigame.state) then 
		return
	end
	love.graphics.push()
	if self.shakeamt > 0 then
		love.graphics.translate((self.shakeamt * self.on) / 2, 0)
		self.shakeamt = self.shakeamt - self.shakereduct * DTMULT
		self.ontimer = self.ontimer + DTMULT
		if self.ontimer >= 1 then
			self.on = self.on * -1
			self.ontimer = 0
		end
	end
	super.draw(self)
	love.graphics.pop()
end

return RhythmGamePerformer