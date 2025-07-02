local FunnyStanchion, super = Class(Event)

function FunnyStanchion:init(data)
    super.init(self, data)

    self.front_left_sprite = Assets.getFrames("world/events/funny_stanchion/front_left")
    self.front_middle_sprite = Assets.getFrames("world/events/funny_stanchion/front_middle")
    self.front_right_sprite = Assets.getFrames("world/events/funny_stanchion/front_right")
    self.back_left_sprite = Assets.getTexture("world/events/funny_stanchion/back_left")
    self.back_middle_sprite = Assets.getTexture("world/events/funny_stanchion/back_middle")
    self.back_right_sprite = Assets.getTexture("world/events/funny_stanchion/back_right")

    local properties = data.properties or {}

    self.dir = properties["dir"] or "front"
	if self.dir == "front" then
		self:setHitbox(4, 30, self.width-10, 12)
	else
		self:setHitbox(4, 36, self.width-10, 12)
	end
    self.solid = properties["solid"] ~= false
	
	self.stanchion_frame = {}
    self:updateSize()
	self.animate_stanchions = true
	local can_kill = Game:getFlag("can_kill", false)
	if can_kill then
		self.animate_stanchions = false
	end
end

function FunnyStanchion:updateSize()
    self.start_x = math.min(20, self.width/2)
    self.start_y = self.height/2

    self.end_x = self.width - self.start_x
    self.end_y = self.start_y
	
	local mid_size = self.end_x - self.start_x
    local mid_count = math.ceil(mid_size / 40)
	mid_count = mid_count + 1
    for i = 1, mid_count do
		self.stanchion_frame[i] = 1
    end
end

function FunnyStanchion:update()
    if self.world and self.world.player and self.animate_stanchions then
        local player = self.world.player

        local dist_x, dist_y = 0, 0

		local mid_size = self.end_x - self.start_x
		local mid_count = math.ceil(mid_size / 40)
		mid_count = mid_count + 1
		local px = player.x+player.width/2
		for i = 1, mid_count do
			if px >= (self.x + i*40) - 60 and px < (self.x + i*40) - 40 then
				self.stanchion_frame[i] = 2
			elseif px >= (self.x + i*40) - 40 and px < (self.x + i*40) - 20 then
				self.stanchion_frame[i] = 3
			elseif px >= (self.x + i*40) - 20 and px <= (self.x + i*40) + 20 then
				self.stanchion_frame[i] = 4
			elseif px <= (self.x + i*40) + 40 and px > (self.x + i*40) + 20 then
				self.stanchion_frame[i] = 5
			elseif px <= (self.x + i*40) + 60 and px > (self.x + i*40) + 40 then
				self.stanchion_frame[i] = 6
			else
				self.stanchion_frame[i] = 1
			end
		end
    end

    super.update(self)
end

function FunnyStanchion:draw()
    if self.dir == "front" then
        local mid_size = self.end_x - self.start_x
        mid_size = mid_size - 40
        local mid_count = math.ceil(mid_size / 40)
        local mid_scale = (mid_size / mid_count) / 40
		local left_sprite = self.front_left_sprite[self.stanchion_frame[1]]
		local right_sprite = self.front_right_sprite[self.stanchion_frame[mid_count+2]]
		
        for i = 1, mid_count do
			local middle_sprite = self.front_middle_sprite[1]
			if self.stanchion_frame[i+1] then
				middle_sprite = self.front_middle_sprite[self.stanchion_frame[i+1]]
			end
            local mid_x, mid_y = self.start_x, self.start_y
            local sx, sy = 2 * mid_scale, 2
            mid_x = self.start_x + 20 + (20 * mid_scale) + ((i - 1) * 40 * mid_scale)
            Draw.draw(middle_sprite, mid_x, mid_y, rot, sx, sy, middle_sprite:getWidth()/2, middle_sprite:getHeight()/2)
        end

        Draw.draw(left_sprite, self.start_x, self.start_y, 0, 2, 2, left_sprite:getWidth()/2, left_sprite:getHeight()/2)
        Draw.draw(right_sprite, self.end_x, self.end_y, 0, 2, 2, right_sprite:getWidth()/2, right_sprite:getHeight()/2)
    else
        local left_sprite = self.back_left_sprite
        local right_sprite = self.back_right_sprite
        local middle_sprite = self.back_middle_sprite

        local mid_size = self.end_x - self.start_x
        mid_size = mid_size - 40

        local mid_count = math.ceil(mid_size / 40)
        local mid_scale = (mid_size / mid_count) / 40

        for i = 1, mid_count do
            local mid_x, mid_y = self.start_x, self.start_y
            local sx, sy = 2 * mid_scale, 2
            mid_x = self.start_x + 20 + (20 * mid_scale) + ((i - 1) * 40 * mid_scale)
            Draw.draw(middle_sprite, mid_x, mid_y, rot, sx, sy, middle_sprite:getWidth()/2, middle_sprite:getHeight()/2)
        end

        Draw.draw(left_sprite, self.start_x, self.start_y, 0, 2, 2, left_sprite:getWidth()/2, left_sprite:getHeight()/2)
        Draw.draw(right_sprite, self.end_x, self.end_y, 0, 2, 2, right_sprite:getWidth()/2, right_sprite:getHeight()/2)
    end

    super.draw(self)
end

return FunnyStanchion