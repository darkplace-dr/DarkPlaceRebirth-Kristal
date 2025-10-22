---@class Event.climbcoin : Event
local event, super = Class(Event, "climbcoin")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
	self.value = properties["value"] or 5
	self.sprite_tex = Assets.getFrames("world/events/climbcoins/coinbowl")
	self.silver_tex = Assets.getFrames("world/events/climbcoins/silvercoin")
	self.gold_tex = Assets.getFrames("world/events/climbcoins/goldcoin")
	self.con = 0
	self.siner = 0
	self.bowlindex = 0
end

function event:update()
    super.update(self)
	self.siner = self.siner + DTMULT
	local collider = Hitbox(self, 0, 0, 40, 40)
	if self.con == 0 then
		Object.startCache()
		if Game.world.player:collidesWith(collider) and Game.world.player.state == "CLIMB" then
			if self.con == 0 then
				self.con = 1
			end
		end
		Object.endCache()
	end
	if self.con == 1 then
		local pitch = 1.4
		if self.value > 5 then
			pitch = 1.15
		end
		Assets.playSound("coin", 0.7, pitch)
		if self.value > 5 then
			Game.world.timer:after(2/30, function()
				Assets.playSound("coin", 0.4, pitch * 0.75)
			end)
		end
		Game.money = Game.money + self.value
		local delaytime = 6
		local decay = 0.2
		local vol = 1
		local count = 1
		Assets.playSound("leaf_dodge", vol, 1.5)
		local timecount = 1
		local count = 1
		Game.world.timer:after((1+(delaytime * timecount)+1)/30, function()
			Assets.playSound("leaf_dodge", vol - (count * 0.2), 1.5 - (decay * count))
			count = count + 1
		end)
		timecount = timecount + 1
		Game.world.timer:after((2+(delaytime * timecount)+3)/30, function()
			Assets.playSound("leaf_dodge", vol - (count * 0.2), 1.5 - (decay * count))
			count = count + 1
		end)
		timecount = timecount + 1
		Game.world.timer:after((2+(delaytime * timecount)+5)/30, function()
			Assets.playSound("leaf_dodge", vol - (count * 0.2), 1.5 - (decay * count))
		end)
		local font = Assets.getFont("goldnumbers")
        local value_text = Text("+"..self.value,
            self.x + 20 - font:getWidth("+"..self.value)/2, self.y + 20, SCREEN_WIDTH, 20,
            {
                font = "goldnumbers"
            }
        )
        value_text.physics.speed_y = -4
        value_text.physics.friction = 0.25
        value_text:setLayer(Game.world.player.layer - 0.05)
		Game.world.timer:after(1, function()
			value_text:remove()
		end)
        Game.world:addChild(value_text)
		Game.world.timer:tween(40/30, self, {bowlindex = 15}, "out-quad")
		self.con = 2
	end
end

function event:draw()
	local sinamt = math.sin(self.siner / 20) * 6 * MathUtils.clamp(1 - (self.bowlindex / 7), 0, 1)
	Draw.setColor(ColorUtils.mergeColor(COLORS.white, COLORS.gray, self.bowlindex/15))
    Draw.draw(self.sprite_tex[(math.floor(self.bowlindex)%6)+1], 0, -sinamt, 0, 2, 2)
	Draw.setColor(COLORS.white)
	local spr = self.silver_tex[(math.floor(self.siner/4)%4)+1]
	local xoff = 4
	local yoff = 4
	if self.value > 5 then
		spr = self.gold_tex[(math.floor(self.siner/4)%4)+1]
		yoff = 5
	end
	if self.con == 0 then
	    Draw.draw(spr, 20, 20+math.sin(self.siner / 20) * 4, 0, 2, 2, xoff, yoff)
	end
    super.draw(self)
end

return event
