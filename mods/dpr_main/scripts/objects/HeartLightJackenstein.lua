local HeartLightJackenstein, super = Class(Object)

function HeartLightJackenstein:init(x, y, color)
    super.init(self, x, y)
	self.radius = 40
	self.current_radius = 0
	self.biggerrad = 12
    self.radius_big = 0
    self.radius_small = 0
    self.color = color or {1,1,1}
    self.alpha = 1
    self.inherit_color = false
	self.siner = 0
	self.supercharged = false
	self.super_timer = 3
	self.light_beams = {}
    -- don't allow debug selecting
    self.debug_select = false
end

local function scr_approach_curve(val, target, amount, curve)
	return MathUtils.approach(val, target, math.max(curve, math.abs(target - val) / amount) * DTMULT)
end

function HeartLightJackenstein:update()
	super.update(self)
	if Game.battle and Game.battle.soul then
		local soul = Game.battle.soul
		if soul.inv_timer > 15/30 then
			self.siner = self.siner + MathUtils.clamp(((soul.inv_timer/30)-15), 1, 30)
		else
			self.siner = self.siner + DTMULT
		end
	else
		self.siner = self.siner + DTMULT
	end
	self.radius_small = math.max(0, math.sin((self.siner / 30) * 10) + self.current_radius)
	self.radius_big = math.max(0, math.sin(((self.siner - 10) / 30) * 10) + self.current_radius) + (self.biggerrad * (self.current_radius / self.radius))
	if Game.battle and self.supercharged then
		self.super_timer = self.super_timer + DTMULT
		if self.super_timer > 12 + MathUtils.random(5) then
			self.super_timer = 0
			table.insert(self.light_beams, {dir = MathUtils.random(360), width = 13, length = 0})
		end
	end
	if Game.battle.soul then
		self.current_radius = MathUtils.approach(self.current_radius, self.radius, (self.radius / 15) * DTMULT)
	else
		self.current_radius = MathUtils.approach(self.current_radius, -40, (self.radius / 15) * DTMULT)
	end
	local succ = 0.35
	if Game.battle.encounter.treasure_hunt then
		succ = succ + 0.3
	end
    for _,dot in ipairs(Game.stage:getObjects(GhostHouseDot)) do
		if MathUtils.dist(dot.x, dot.y, Game.battle.soul.x, Game.battle.soul.y) < 48 * succ and dot.suck == 0 then
			dot.suck = 1
			dot.physics.friction = 0.5
		end
	end
    local to_remove = {}
    for _,beam in ipairs(self.light_beams) do
		beam.width = scr_approach_curve(beam.width, 0, 60 - math.ceil(beam.length / 8.5), 0.1)
		beam.length = scr_approach_curve(beam.length, 500, 18 - math.ceil(beam.length / 50), 1)
        if beam.width < 0.15 then
            table.insert(to_remove, beam)
        end
    end

    for _,beam in ipairs(to_remove) do
        TableUtils.removeValue(self.light_beams, beam)
    end
end

function HeartLightJackenstein:getRadius()
    return self.radius_big/2, self.radius_small/2
end

function HeartLightJackenstein:draw()
	super.draw(self)
	if self.supercharged then
		local i = 0.25
		while i <= 0.5 do
			Draw.setColor(self.color[1], self.color[2], self.color[3], 1 - (i * 1.8))
            love.graphics.circle("fill", 0, 0, self.radius_small * i)
			i = i + math.max(0.025, 0.1 - (((math.pow(i * 10, 1.035) / 10) - 0.25) / 3))
		end
	end
end

return HeartLightJackenstein