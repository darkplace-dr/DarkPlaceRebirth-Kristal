local ProxyCandle, super = Class(Event, "proxycandle")

function ProxyCandle:init(data)
    super.init(self, data)

    self:setOrigin(0.5, 1)

    self.solid = false
    self.on = false
    local properties = data and data.properties or {}
	self.allowed_to_sound = properties["sound"] or true

    self.trigger_horz = properties["trigger_horz"] or -1
    self.trigger_vert = properties["trigger_vert"] or -1
    self.trigger_rad = properties["trigger_rad"] or -1

	self:setSprite("world/events/churchcandle/unlit")
    self.sprite:stop()
end

function ProxyCandle:lightUp()
    self.sprite:play(2/30, false, function()
		self:setSprite("world/events/churchcandle/lit")
		self.sprite:play(2/30, true)
	end)
	if self.allowed_to_sound then
		Assets.playSound("wing")
		Assets.playSound("wing", 1, 0.5)
	end
    self.lit = true
end

function ProxyCandle:update()
    if not self.lit and Game.world and Game.world.player then
        local player = Game.world.player

        local player_x, player_y = player:getRelativePos(player.width/2, player.height/2, Game.world)
        local left, top = self:getRelativePos(0, 0, Game.world)
        local right, bottom = self:getRelativePos(self.sprite.width*2, self.sprite.height*2, Game.world)
		local trig = false

        if self.trigger_horz ~= -1 and math.abs(player_x - self.x) < self.trigger_horz and (player_y > top and player_y < bottom) then
			trig = true
        end
        if self.trigger_vert ~= -1 and math.abs(player_y - self.y) < self.trigger_vert and (player_x > left and player_x < right) then
			trig = true
        end
        if self.trigger_rad ~= -1 and MathUtils.dist(self.x, self.y, player_x, player_y) < self.trigger_rad then
			trig = true
        end
		if trig == true then
			self:lightUp()
		end
    end

    super.update(self)
end

return ProxyCandle