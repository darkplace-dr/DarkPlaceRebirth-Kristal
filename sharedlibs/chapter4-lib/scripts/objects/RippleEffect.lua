local RippleEffect, super = Class(Object)

function RippleEffect:init()
    super.init(self, 0, 0)
    self.shader = Assets.getShader("ripple")
	self.ripples = {}
	self.layer = WORLD_LAYERS["bottom"]
end

function RippleEffect:makeRipple(x, y, life, color, radmax, radstart, thickness, depth, hsp, vsp, fric, curve)
	life = life or 60
    color = color or ColorUtils.hexToRGB("#4A91F6")
	radstart = radstart or 1
	radmax = radmax or 160
	thickness = thickness or 15
	hsp = hsp or 0
	vsp = vsp or 0
	fric = fric or 0.1
	curve = curve or Ch4Lib.ripple_curve["norm"]
	table.insert(self.ripples, {
		x = x,
		y = y,
		life = life,
		lifemax = life,
		color = color,
		rad = radstart,
		radmax = radmax,
		radstart = radstart,
		thickness = thickness,
		hsp = hsp,
		vsp = vsp,
		fric = fric,
		curve = curve
	})
end

function RippleEffect:evaluate(curve, time)
	if time < 0 then
		time = 0
	end
	if time > 1 then
		time = 1
	end
	local cmax = #curve
	local cstart = 0
	local cend = cmax  - 1
	local cmid = math.floor(cend / 2)
	while (cmid ~= cstart) do
		if curve[math.min(cmid + 1, #curve)].x > time then
			cend = cmid
		else
			cstart = cmid
		end
		cmid = math.floor((cstart + cend) / 2)
	end
	local x1 = curve[math.min(cmid + 1, cmax)].x
	local x2 = curve[math.min(cmid + 2, cmax)].x
	
	if x1 == x2 then
		return curve[math.min(cmid + 1, cmax)].value
	end
	
	local val1 = curve[math.min(cmid + 1, cmax)].value
	local val2 = curve[math.min(cmid + 2, cmax)].value
	
	local ratio = (time - x1) / (x2 - x1)
	local val = ((val2 - val1) * ratio) + val1
	
	return val
end

function RippleEffect:draw()
    super.draw(self)
	local cx, cy = Game.world.camera.x - SCREEN_WIDTH/2, Game.world.camera.y - SCREEN_HEIGHT/2
	local to_remove = {}
	local ripple_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	love.graphics.clear()
	love.graphics.setShader(self.shader)
	for _, ripple in ipairs(self.ripples) do
		ripple.life = math.max(0, ripple.life - DTMULT)
		ripple.x = ripple.x + ripple.hsp * DTMULT
		ripple.y = ripple.y + ripple.vsp * DTMULT
		
		if ripple.hsp > 0 then
			ripple.hsp = MathUtils.approach(ripple.hsp, 0, ripple.fric*DTMULT)
		end
		if ripple.vsp > 0 then
			ripple.vsp = MathUtils.approach(ripple.vsp, 0, ripple.fric*DTMULT)
		end
		
		local xx = ripple.x - cx
		local yy = ripple.y - cy
		ripple.rad = MathUtils.lerp(ripple.radstart, ripple.radmax, self:evaluate(ripple.curve, 1 - (ripple.life / ripple.lifemax)))
		if ripple.rad > 0 then
			love.graphics.setShader(self.shader)
			self.shader:send("rippleCenter", {xx, yy})
			self.shader:send("rippleRad", {ripple.rad, ripple.radmax, ripple.thickness})
			Draw.setColor(ripple.color)
			love.graphics.rectangle("fill", xx - ripple.rad, yy - ripple.rad, ripple.rad*2, ripple.rad*2)
			if ripple.life == 0 then
				table.insert(to_remove, ripple)
			end
		end
	end
	for _,ripple in ipairs(to_remove) do
        TableUtils.removeValue(self.ripples, ripple)
	end
	love.graphics.setShader()
	Draw.popCanvas()
	
	Draw.setColor(1,1,1,1)
	Draw.draw(ripple_canvas, cx, cy)
end

return RippleEffect