local GMParticleSystem, super = Class(Object)

function GMParticleSystem:init()
    super.init(self, 0, 0)
	self.emitters = {}
	self.particle_types = {}
	self.auto_update = true
	self.auto_draw = true
	self.acount = 0
end

function GMParticleSystem:initEmitter()
	return {
		particles = {},
		to_remove = {},
		created = true,
		zombie = false,
		enabled = true,
		mode = nil,
		number = 0,
		relative = false,
		delay_min = 0,
		delay_max = 0,
		delay_current = 0,
		delay_unit = 1,
		interval_min = 0,
		interval_max = 0,
		interval_current = 0,
		interval_unit = 1,
		part_type = "",
		xmin = 0,
		xmax = 0,
		ymin = 0,
		ymax = 0,
		shape = "rectangle",
		posdistr = "linear",
	}
end

function GMParticleSystem:myRandom(minval, maxval, distr)
	local range = maxval - minval
	if range <= 0 then return minval end
	local xx = 0
	local result = 0
	if distr == "linear" then result = minval + MathUtils.random(1) * range
	elseif distr == "gaussian" then
		local xx = (MathUtils.random(1)-0.5)*6
		while ((math.exp(-(xx*xx)*0.5) <= MathUtils.random(1))) do
			xx = (MathUtils.random(1)-0.5)*6
		end
		result = minval + ((xx+3) * 1/6) * range
	elseif distr == "invgaussian" then
		local xx = (MathUtils.random(1)-0.5)*6
		while (not (math.exp(-(xx*xx)*0.5) > MathUtils.random(1))) do
			xx = (MathUtils.random(1)-0.5)*6
		end
		if xx < 0 then xx = xx + 6 end
		result = minval + (xx * (1/6)) * range
	else result = minval + MathUtils.random(1) * range end
	return result
end

function GMParticleSystem:createEmitter(emitter)
	if emitter then
		table.insert(self.emitters, emitter)
	end
end

function GMParticleSystem:removeEmitter(emitter)
	if emitter then
		emitter.created = false
		emitter.zombie = true
	end
end

function GMParticleSystem:initType()
	return {
		created = true,
		sprite = nil,
		sprite_start = 1,
		sprite_anim = false,
		sprite_stretch = false,
		sprite_random = false,
		frame_spd = 1,
		shape = "pixel",
		size_min_x = 1,
		size_max_x = 1,
		size_min_y = 1,
		size_max_y = 1,
		size_incr_x = 0,
		size_incr_y = 0,
		size_rand_x = 0,
		size_rand_y = 0,
		xscale = 1,
		yscale = 1,
		life_min = 100,
		life_max = 100,
		step_type = nil,
		step_number = 0,
		death_type = nil,
		death_number = 0,
		spd_min = 0,
		spd_max = 0,
		spd_incr = 0,
		spd_rand = 0,
		dir_min = 0,
		dir_max = 0,
		dir_incr = 0,
		dir_rand = 0,
		ang_min = 0,
		ang_max = 0,
		ang_incr = 0,
		ang_rand = 0,
		ang_dir = 0,
		grav = 0,
		grav_dir = -math.rad(270),
		col_mode = "one",
		col_par = {COLORS.white, COLORS.white, COLORS.white},
		alpha_start = 1,
		alpha_middle = 1,
		alpha_end = 1,
		additive_blend = false,
		xorigin = 0,
		yorigin = 0,
	}
end

function GMParticleSystem:createType(ptype)
	if ptype then
		table.insert(self.particle_types, ptype)
	end
end

function GMParticleSystem:removeType(ptype)
	if ptype then
		TableUtils.removeValue(self.particle_types, ptype)
	end
end

function GMParticleSystem:createParticle(x, y, part_type)
	local rand = MathUtils.random()
	local particle = {
		alive = true,
		part_type = part_type,
		x = x,
		y = y,
		speed = MathUtils.random(part_type.spd_min, part_type.spd_max),
		dir = MathUtils.random(part_type.dir_min, part_type.dir_max),
		ang = MathUtils.random(part_type.ang_min, part_type.ang_max),
		lifetime = MathUtils.random(part_type.life_min, part_type.life_max),
		age = 0,
		color = COLORS.white,
		colmode = part_type.col_mode,
		colpar = part_type.col_par,
		alpha = part_type.alpha_start,
		xsize = part_type.size_min_x + ((part_type.size_max_x - part_type.size_min_x) * rand),
		ysize = part_type.size_min_y + ((part_type.size_max_y - part_type.size_min_y) * rand),
		additiveblend = part_type.additive_blend,
		spritestart = (part_type.sprite_random and MathUtils.randomInt(1, 10000) or part_type.sprite_start),
		frame = part_type.sprite_start,
		ran = MathUtils.randomInt(100000)
	}
	particle.color = self:computeColor(particle)
	return particle
end

function GMParticleSystem:emitParticles(emitter, x, y, part_type, number, override_color, color)
	if not emitter then return end
	local override_color = override_color and override_color or false
	local color = color and color or COLORS.white
	for i = 1, number do
		local particle = self:createParticle(x, y, part_type)
		if override_color then
			particle.colmode = "one"
			particle.colpar = {color}
		end
		table.insert(emitter.particles, particle)
	end
end

function GMParticleSystem:emitterBurstImpl(emitter, x, y, width, height, shape, distr, part_type, number)
	if not emitter then return end
	local numb = number
	if emitter.relative then
		numb = width * height * number * 0.00003
	end
	if numb < 0 then
		if MathUtils.randomInt(0, -numb) == 0 then
			numb = 1
		else
			return
		end
	end
	local fract = numb - math.floor(numb)
	numb = math.floor(numb)
	if fract > 0 and MathUtils.random(0, 1) <= fract then
		numb = numb + 1
	end
	if numb == 0 then return end
	local right = width
	local down = height
	for i = 1, numb do
		local xx, yy
		local do_break = false
		while not do_break do
			xx = self:myRandom(0, 1, distr)
			yy = self:myRandom(0, 1, distr)
			if distr == "invgaussian" and shape ~= "line" then
				if MathUtils.random(0, 1) < 0.5 then
					xx = self:myRandom(0, 1, "linear")
				else
					yy = self:myRandom(0, 1, "linear")
				end
			end
			if shape == "ellipse" then
				local dx = xx - 0.5
				local dy = yy - 0.5
				if (dx * dx) + (dy * dy) <= 0.25 then do_break = true end
			elseif shape == "diamond" then
				if math.abs(xx - 0.5) + math.abs(yy - 0.5) <= 0.5 then do_break = true end
			elseif shape == "rectangle" or shape == "line" or not shape then
				do_break = true
			end
		end
		local particle_x
		local particle_y
		if shape == "line" then
			particle_x = x + right * xx
			particle_y = y + down * xx
		else
			particle_x = x + right * xx
			particle_y = y + down * yy
		end
		self:emitParticles(emitter, particle_x, particle_y, part_type, 1)
	end
end

function GMParticleSystem:emitterBurst(emitter, part_type, number)
	if not emitter then return end
	if not emitter.enabled then return end
	local emitter_width = emitter.xmax - emitter.xmin
	local emitter_height = emitter.ymax - emitter.ymin
	self:emitterBurstImpl(emitter, emitter.xmin, emitter.ymin, emitter_width, emitter_height, emitter.shape, emitter.posdistr, part_type, number)
end

function GMParticleSystem:computeColor(part)
	if not part then return end
	if part.age <= 0 or part.lifetime <= 0 then
		if part.colmode == "one" then part.color = part.colpar[1]
		elseif part.colmode == "two" then part.color = part.colpar[1]
		elseif part.colmode == "three" then part.color = part.colpar[1]
		elseif part.colmode == "rgb" then
			local r = MathUtils.random(part.colpar[1], part.colpar[2])
			local g = MathUtils.random(part.colpar[3], part.colpar[4])
			local b = MathUtils.random(part.colpar[5], part.colpar[6])
			part.color = {r, g, b}
		elseif part.colmode == "hsv" then
			local h = MathUtils.random(part.colpar[1], part.colpar[2])
			local s = MathUtils.random(part.colpar[3], part.colpar[4])
			local v = MathUtils.random(part.colpar[5], part.colpar[6])
			part.color = ColorUtils.HSVToRGB(h, s, v)
		elseif part.colmode == "mix" then part.color = ColorUtils.mergeColor(part.colpar[1], part.colpar[2], MathUtils.random()) end
	else	
		if part.colmode == "one" then part.color = part.colpar[1]
		elseif part.colmode == "two" then
			local val = part.age/part.lifetime
			if val > 1 then val = 1 end
			part.color = ColorUtils.mergeColor(part.colpar[1], part.colpar[2], val)
		elseif part.colmode == "three" then
			local val = 2*(part.age/part.lifetime)
			if val > 2 then val = 2 end
			if val < 1 then
				part.color = ColorUtils.mergeColor(part.colpar[1], part.colpar[2], val)
			else
				part.color = ColorUtils.mergeColor(part.colpar[2], part.colpar[3], val - 1)
			end
		end
	end
end

function GMParticleSystem:handleLife(emitter, part_type, part)
	if part then
		part.age = part.age + DTMULT
		if part.age >= part.lifetime then
			if part_type then
				local numb = part_type.death_number
				if numb < 0 then
					if MathUtils.randomInt(0, -numb) == 0 then numb = 1 end
				end
				if numb > 0 then
					self:emitParticles(emitter, part.x, part.y, part_type.death_type, numb)
				end
			end
			table.insert(emitter.to_remove, part)
		else
			if part_type then
				local numb = part_type.step_number
				if numb < 0 then
					if MathUtils.randomInt(0, -numb) == 0 then numb = 1 end
				end
				if numb > 0 then
					self:emitParticles(emitter, part.x, part.y, part_type.step_type, numb)
				end
			end
		end
	end
end

function GMParticleSystem:handleMotion(part_type, part)
	if part then
		part.speed = part.speed + part_type.spd_incr * DTMULT
		if part.speed < 0 then part.speed = 0 end
		part.dir = part.dir + part_type.dir_incr * DTMULT
		part.ang = part.ang + part_type.ang_incr * DTMULT
		local xspd = 0
		local yspd = 0
		local xspdtemp = 0
		local yspdtemp = 0
		if part_type.grav ~= 0 or self.acount > 0 then
			xspd = part.speed * math.cos(part.dir)
			yspd = part.speed * math.sin(part.dir)
			if part_type.grav ~= 0 then
				local h2 = part_type.grav * math.cos(part_type.grav_dir)
				local v2 = part_type.grav * math.sin(part_type.grav_dir)
				xspd = xspd + h2 * DTMULT
				yspd = yspd + v2 * DTMULT
			end
			part.dir = MathUtils.angle(0, 0, xspd, yspd)
			part.speed = MathUtils.dist(0, 0, xspd, yspd)
		end
		local rd = ((part.age+3+part.ran) % 24) / 6
		if rd > 2 then
			rd = 4 - rd
		end
		rd = rd - 1
		local rs = ((part.age+4+part.ran) % 20) / 4
		if rs > 2 then
			rs = 4 - rs
		end
		rs = rs - 1
		xspd = math.cos((part.dir+rd * part_type.dir_rand)) * (part.speed+rs * part_type.spd_rand)
		yspd = math.sin((part.dir+rd * part_type.dir_rand)) * (part.speed+rs * part_type.spd_rand)
		part.x = part.x + (xspd + xspdtemp) * DTMULT
		part.y = part.y + (yspd + yspdtemp) * DTMULT
	end
end

function GMParticleSystem:handleShape(part_type, part)
	if part then
		part.xsize = part.xsize + part_type.size_incr_x * DTMULT
		if part.xsize < 0 then part.xsize = 0 end
		part.ysize = part.ysize + part_type.size_incr_y * DTMULT
		if part.ysize < 0 then part.ysize = 0 end
		self:computeColor(part)
		local passed = 1
		if part.lifetime > 0 then passed = 2 * part.age/part.lifetime end
		if passed < 1 then
			part.alpha = part_type.alpha_start*(1-passed) + part_type.alpha_middle*passed
		else		
			part.alpha = part_type.alpha_middle*(2-passed) + part_type.alpha_end*(passed-1)
		end
		if part_type.sprite_stretch then
			part.frame = part.spritestart + #part_type.sprite * part.age/part.lifetime
		elseif part_type.sprite_anim and part_type.frame_spd > 0 then
			part.frame = part.frame + part_type.frame_spd
		else
			part.frame = part.spritestart
		end
	end
end

function GMParticleSystem:emitterRegion(emitter, xmin, xmax, ymin, ymax, shape, posdistr)
	if emitter then
		emitter.xmin = xmin
		emitter.xmax = xmax
		emitter.ymin = ymin
		emitter.ymax = ymax
		emitter.shape = shape
		emitter.posdistr = posdistr
	end
end

function GMParticleSystem:emitterStream(emitter, ptype, numb)
	if emitter then
		emitter.part_type = ptype
		emitter.number = numb
	end
end

function GMParticleSystem:emitterDelay(emitter, delaymin, delaymax, delayunit)
	if emitter then
		emitter.delay_min = delaymin
		emitter.delay_max = delaymax
		emitter.delay_unit = delayunit
		self:emitterRandomizeDelay(emitter)
	end
end

function GMParticleSystem:emitterRandomizeDelay(emitter)
	if emitter then
		if emitter.delay_min == 0 and emitter.delay_max == 0 then
			emitter.delay_current = 0
			return
		end
		emitter.delay_current = (emitter.delay_unit == 1 and MathUtils.randomInt(math.floor(emitter.delay_min), math.floor(emitter.delay_max)) or MathUtils.random(emitter.delay_min, emitter.delay_max))
	end
end

function GMParticleSystem:emitterRandomizeInterval(emitter)
	if emitter then
		if emitter.interval_min == 0 and emitter.interval_max == 0 then
			emitter.interval_current = 0
			return
		end
		emitter.interval_current = (emitter.interval_unit == 1 and MathUtils.randomInt(math.floor(emitter.interval_min), math.floor(emitter.interval_max)) or MathUtils.random(emitter.interval_min, emitter.interval_max))
	end
end

function GMParticleSystem:partTypeSprite(part_type, sprite, anim, stretch, rand, fspd)
	if part_type then
		part_type.sprite = sprite
		part_type.sprite_anim = anim
		part_type.sprite_stretch = stretch
		part_type.sprite_random = rand
		part_type.frame_spd = fspd or 1
	end
end

function GMParticleSystem:partTypeOrigin(part_type, xorigin, yorigin)
	if part_type then
		part_type.xorigin = xorigin
		part_type.yorigin = yorigin
	end
end

function GMParticleSystem:partTypeFrame(part_type, frame)
	if part_type then
		part_type.sprite_start = frame
	end
end

function GMParticleSystem:partTypeSize(part_type, sizemin, sizemax, sizeincr, sizerand)
	if part_type then
		part_type.size_min_x = sizemin
		part_type.size_max_x = sizemax
		part_type.size_incr_x = sizeincr
		part_type.size_rand_x = sizerand
		part_type.size_min_y = sizemin
		part_type.size_max_y = sizemax
		part_type.size_incr_y = sizeincr
		part_type.size_rand_y = sizerand
	end
end

function GMParticleSystem:partTypeSizeX(part_type, sizemin, sizemax, sizeincr, sizerand)
	if part_type then
		part_type.size_min_x = sizemin
		part_type.size_max_x = sizemax
		part_type.size_incr_x = sizeincr
		part_type.size_rand_x = sizerand
	end
end

function GMParticleSystem:partTypeSizeY(part_type, sizemin, sizemax, sizeincr, sizerand)
	if part_type then
		part_type.size_min_y = sizemin
		part_type.size_max_y = sizemax
		part_type.size_incr_y = sizeincr
		part_type.size_rand_y = sizerand
	end
end

function GMParticleSystem:partTypeScale(part_type, xscale, yscale)
	if part_type then
		part_type.xscale = xscale
		part_type.yscale = yscale
	end
end

function GMParticleSystem:partTypeLife(part_type, lifemin, lifemax)
	if part_type then
		part_type.life_min = lifemin
		part_type.life_max = lifemax
	end
end

function GMParticleSystem:partTypeStep(part_type, stepnumber, steptype)
	if part_type then
		part_type.step_number = stepnumber
		part_type.step_type = steptype
	end
end

function GMParticleSystem:partTypeDeath(part_type, deathnumber, deathtype)
	if part_type then
		part_type.death_number = deathnumber
		part_type.death_type = deathtype
	end
end

function GMParticleSystem:partTypeSpeed(part_type, spmin, spmax, spincr, sprand)
	if part_type then
		part_type.spd_min = spmin
		part_type.spd_max = spmax
		part_type.spd_incr = spincr
		part_type.spd_rand = sprand
	end
end

function GMParticleSystem:partTypeDirection(part_type, dirmin, dirmax, dirincr, dirrand)
	if part_type then
		part_type.dir_min = dirmin
		part_type.dir_max = dirmax
		part_type.dir_incr = dirincr
		part_type.dir_rand = dirrand
	end
end

function GMParticleSystem:partTypeGravity(part_type, grav, gravdir)
	if part_type then
		part_type.grav = grav
		part_type.grav_dir = gravdir
	end
end

function GMParticleSystem:partTypeOrientation(part_type, angmin, angmax, angincr, angrand, angdir)
	if part_type then
		part_type.ang_min = angmin
		part_type.ang_max = angmax
		part_type.ang_incr = angincr
		part_type.ang_rand = angrand
		part_type.ang_dir = angdir
	end
end

function GMParticleSystem:partTypeColorRGB(part_type, rmin, rmax, gmin, gmax, bmin, bmax)
	if part_type then
		part_type.col_mode = "rgb"
		part_type.col_par = {rmin, rmax, gmin, gmax, bmin, bmax}
	end
end

function GMParticleSystem:partTypeColorMix(part_type, col1, col2)
	if part_type then
		part_type.col_mode = "mix"
		part_type.col_par[1] = col1
		part_type.col_par[2] = col2
	end
end

function GMParticleSystem:partTypeColorHSV(part_type, hmin, hmax, smin, smax, vmin, vmax)
	if part_type then
		part_type.col_mode = "hsv"
		part_type.col_par = {hmin, hmax, smin, smax, vmin, vmax}
	end
end

function GMParticleSystem:partTypeColorOne(part_type, colstart)
	if part_type then
		part_type.col_mode = "one"
		part_type.col_par[1] = colstart
	end
end

function GMParticleSystem:partTypeColorTwo(part_type, colstart, colend)
	if part_type then
		part_type.col_mode = "two"
		part_type.col_par[1] = colstart
		part_type.col_par[2] = colend
	end
end

function GMParticleSystem:partTypeColorThree(part_type, colstart, colmiddle, colend)
	if part_type then
		part_type.col_mode = "three"
		part_type.col_par[1] = colstart
		part_type.col_par[2] = colmiddle
		part_type.col_par[3] = colend
	end
end

function GMParticleSystem:partTypeAlphaOne(part_type, alphastart)
	if part_type then
		part_type.alpha_start = alphastart
		part_type.alpha_middle = alphastart
		part_type.alpha_end = alphastart
	end
end

function GMParticleSystem:partTypeAlphaTwo(part_type, alphastart, alphaend)
	if part_type then
		part_type.alpha_start = alphastart
		part_type.alpha_middle = (alphastart+alphaend)/2
		part_type.alpha_end = alphaend
	end
end

function GMParticleSystem:partTypeAlphaThree(part_type, alphastart, alphamiddle, alphaend)
	if part_type then
		part_type.alpha_start = alphastart
		part_type.alpha_middle = alphamiddle
		part_type.alpha_end = alphaend
	end
end

function GMParticleSystem:partTypeBlend(part_type, additive)
	if part_type then
		part_type.additive_blend = additive
	end
end

function GMParticleSystem:update()
	super.update(self)
	if not self.auto_update then return end
	for i, emitter in ipairs(self.emitters) do
		if not emitter.enabled then return end
		if not emitter.created and not emitter.zombie then return end
		emitter.to_remove = {}
		for _, part in ipairs(emitter.particles) do
			if part then
				self:handleLife(emitter, part.part_type, part)
				self:handleMotion(part.part_type, part)
				self:handleShape(part.part_type, part)
			end
		end
		if emitter.delay_current > 0 then
			emitter.delay_current = emitter.delay_current - (emitter.delay_unit == 1 and DT or DTMULT)
			if emitter.delay_current <= 0 then
				self:emitterBurst(emitter, emitter.part_type, emitter.number)
			end
			goto continue
		end
		if emitter.mode ~= "burst" then
			emitter.interval_current = emitter.interval_current - (emitter.interval_unit == 1 and DT or DTMULT)
			if emitter.interval_current <= 0 then
				self:emitterBurst(emitter, emitter.part_type, emitter.number)
				self:emitterRandomizeInterval(emitter)
			end
		end
		if #emitter.particles == 0 then
			local was_zombie = emitter.zombie
			emitter.zombie = false
			if was_zombie then
				TableUtils.removeValue(self.emitters, emitter)
			end
		end
		::continue::
		for _,part in ipairs(emitter.to_remove) do
			TableUtils.removeValue(emitter.particles, part)
		end
	end
end


function GMParticleSystem:drawIt()
	super.draw(self)
	if self.auto_draw then
		self:drawIt()
	end
end

function GMParticleSystem:drawIt()
	love.graphics.push()
	for i, emitter in ipairs(self.emitters) do
		for _, part in ipairs(emitter.particles) do
			if part then
				local r = ((part.age+2+part.ran) % 16) / 4
				if r > 2 then
					r = 4 - r
				end
				r = r - 1
				local aa = part.ang
				if part.part_type.ang_dir ~= 0 then aa = aa + part.dir * DTMULT end
				aa = aa + math.rad(r*part.part_type.ang_rand)
				r = ((part.age+part.ran) % 16) / 4
				if r > 2 then
					r = 4 - r
				end
				r = r - 1
				local sx = part.xsize + r*part.part_type.size_rand_x
				local sy = part.ysize + r*part.part_type.size_rand_y
				sx = sx * part.part_type.xscale
				sy = sy * part.part_type.yscale
				self:computeColor(part)
				if part.additiveblend then
					love.graphics.setBlendMode("add")
				end
				Draw.setColor(part.color, part.alpha * self.alpha)
				if part.part_type.sprite_anim or part.part_type.sprite_random then
					Draw.draw(part.part_type.sprite[math.floor((part.frame - 1) % #part.part_type.sprite) + 1], part.x, part.y, aa, sx, sy, part.part_type.xorigin, part.part_type.yorigin)
				else
					Draw.draw(part.part_type.sprite, part.x, part.y, aa, sx, sy, part.part_type.xorigin, part.part_type.yorigin)
				end
				love.graphics.setBlendMode("alpha")
			end
		end
	end
	love.graphics.pop()
end

return GMParticleSystem