---@class Event.bellplayable : Event
local BellPlayable, super = Class(Event, "BellPlayable")

function BellPlayable:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
	self.mypitch = properties["pitch"] or 1
    self.script = properties["script"]
    self.climb_obstacle = properties["climb"] or false
	self.bellcordlength = properties["length"] or 50
	self.bellcordfadelength = properties["fadewidth"] or 2
	self.sndtoplay = properties["sound"] or "playablebell"
    self:setSprite("world/events/bell_small")
	self.sprite:setOriginExact(9, 2)
	self.sprite.x = 20
	self.fill_tex = Assets.getTexture("bubbles/fill")
	self.gradient_tex = Assets.getTexture("backgrounds/gradient40")
	self.con = 0
	self.timer = 0
	self.rung = 0
	self.canring = properties["interactable"] ~= false
	self:setHitbox(5, 5, 30, 30)
	self.dont_draw_on_tower = true
	if self.climb_obstacle and Game.world.map.cyltower then
		self.visible = false
		self.bellcordlength = properties["length"] or 150
	end
end

function BellPlayable:update()
    super.update(self)
	local collider = Hitbox(self, 5, 5, 30, 30)
	if self.con == 0 then
		self.sprite.rotation = 0
		if Game.world.player:collidesWith(collider) and Game.world.player.state == "CLIMB" then
			if self.con == 0 then
				self.con = 1
			end
		end
		Object.endCache()
	end
	if self.con == 1 then
		self.rung = self.rung + 1
		Assets.playSound(self.sndtoplay, 1, self.mypitch)
        if self.script then
            Registry.getEventScript(self.script)(self)
        end
		self.con = 2
		self.timer = 0
	end
	if self.con == 2 then
		self.timer = self.timer + DTMULT
		self.sprite.rotation = self.sprite.rotation - math.rad((math.sin(self.timer) * 8) * DTMULT)
		
		if self.timer >= 10 then
			self.con = 0
		end
	end
end

function BellPlayable:onInteract(player)
	if self.con == 0 and self.canring then
		self.con = 1
		return true
	end
	return false
end

function BellPlayable:draw()
	Draw.setColor(ColorUtils.hexToRGB("#B4D6CA"))
    Draw.draw(self.fill_tex, 20, 0, 0, 2, -self.bellcordlength)
    Draw.draw(self.gradient_tex, 20, -self.bellcordlength - (40 * self.bellcordfadelength), 0, 0.05, self.bellcordfadelength)
	Draw.setColor(COLORS.white)
    super.draw(self)
end

return BellPlayable