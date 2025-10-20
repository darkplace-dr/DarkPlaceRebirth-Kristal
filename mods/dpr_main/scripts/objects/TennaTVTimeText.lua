---@class TennaTVTimeText : Object
---@overload fun(...) : TennaTVTimeText
local TennaTVTimeText, super = Class(Object)

function TennaTVTimeText:init(x, y, width, height, battle_box)
    super.init(self, x, y, width, height)

    self.box = UIBox(0, 0, width, height)
    self.box.layer = -1
    self.box.debug_select = false
    self:addChild(self.box)

    self.battle_box = battle_box
    if battle_box then
        self.box.visible = false
    end

    self.done = false
	self.con = 0
	self.time = 0
	self.timestamp_ind = 1
	self.text_time = 0
    self.lights_texture = Assets.getFrames("funnytext/tv_time/lights")
	self.lights_frame = 0
	self.lights_max = 4
	self.tv_x = 6
	self.tv_y = -18
	self.tv_max = 0
    options = options or {}
	self.tv_pitch = options["pitch"] or 1
	
	self.tv_time_letters = {}
	table.insert(self.tv_time_letters, {timestamp = 0, tex = Assets.getTexture("funnytext/tv_time/its"), x = 97, y = 73, scale = 3, origin_x = 66, origin_y = 45})
	table.insert(self.tv_time_letters, {timestamp = 1.2, tex = Assets.getTexture("funnytext/tv_time/t"), x = 200, y = 64, scale = 3, origin_x = 24, origin_y = 35})
	table.insert(self.tv_time_letters, {timestamp = 2, tex = Assets.getTexture("funnytext/tv_time/v"), x = 231, y = 76, scale = 3, origin_x = 52, origin_y = 41})
	table.insert(self.tv_time_letters, {timestamp = 2.85, tex = Assets.getTexture("funnytext/tv_time/time"), x = 386, y = 71, scale = 3, origin_x = 89, origin_y = 47})
end

function TennaTVTimeText:update()
	super.update(self)

	self.time = self.time + DTMULT
	self.lights_frame = math.floor(self.time*0.2)
	if self.con == 0 then
		self.tv_sound = Assets.playSound("its_tv_time", 1, self.tv_pitch)
		self.con = 5
	end
	if self.con == 5 then
		self.text_time = self.text_time + DTMULT
		if self.text_time >= (self.tv_time_letters[self.timestamp_ind].timestamp * 30) / self.tv_pitch then
			self.con = 10
			self.timestamp_ind = self.timestamp_ind + 1
		end
	end
	if self.con == 10 then
		self.tv_max = self.tv_max + 1
		Game.stage.timer:after((4/self.tv_pitch)/30, function() self.lights_max = self.lights_max - 1 end)
		if self.tv_max >= 4 then
			self.con = 20
		else
			self.con = 5
		end
	end
	if self.con == 20 then
		self.con = 21
		Game.stage.timer:after(90/30, function() self.con = 22 end)
	end
	if self.con == 22 then
		self.con = 0
		self.timestamp_ind = 1
		self.done = true
        self.box.visible = false
		self:remove()
	end
	for i = 1, self.tv_max do
		self.tv_time_letters[i].scale = Utils.approach(self.tv_time_letters[i].scale, 1, (0.4 * self.tv_pitch) * DTMULT)
	end
end

function TennaTVTimeText:getBorder()
    if self.box.visible then
        return self.box:getBorder()
    else
        return 0, 0
    end
end

function TennaTVTimeText:draw()
    super.draw(self)
    Draw.draw(self.lights_texture[(self.lights_frame % #self.lights_texture) + 1], self.tv_x, self.tv_y)
	Draw.setColor(0,0,0,1)
	if self.lights_max == 4 then
		Draw.rectangle("fill", self.tv_x, self.tv_y, 165, 130)
	end
	if self.lights_max >= 3 then
		Draw.rectangle("fill", self.tv_x + 165, self.tv_y, 210-165, 130)
	end
	if self.lights_max >= 2 then
		Draw.rectangle("fill", self.tv_x + 210, self.tv_y, 310-210, 130)
	end
	if self.lights_max >= 1 then
		Draw.rectangle("fill", self.tv_x + 310, self.tv_y, 500-310, 130)
	end
	Draw.setColor(1,1,1,1)
	for i = 1, self.tv_max do
	    Draw.draw(self.tv_time_letters[i].tex, self.tv_x + self.tv_time_letters[i].x, self.tv_y + self.tv_time_letters[i].y, 0, self.tv_time_letters[i].scale, self.tv_time_letters[i].scale, self.tv_time_letters[i].origin_x, self.tv_time_letters[i].origin_y)
	end
end

return TennaTVTimeText