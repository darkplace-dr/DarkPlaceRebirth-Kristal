local ChurchPianoHint, super = Class(Event, "pianohint")

function ChurchPianoHint:init(data)
    super.init(self, data)
	
    local properties = data.properties or {}
	
	self.hint = properties["hint"] or "777"
	self.silent = properties["silent"] or false
	self.stafftype = properties["staff"] or "start"
	self.hint_units = {}
	self.staffspr = Assets.getFrames("world/events/pianohint/musicstaff")
	self.midspr = Assets.getTexture("world/events/pianohint/slurmid")
	self.arrowspr = Assets.getTexture("world/events/pianohint/arrow")
	self.circlespr = Assets.getTexture("ui/circle_7x7")
	self.hintcol = ColorUtils.hexToRGB("#698DE6FF")
	self.hintactive = false
	self.hintalpha = 0
	self.trigger = properties["alreadyactive"] or false
	self.group = properties["group"] or nil
	self.siner = 0
    self.create_light = properties["light"] ~= false
    self.lightsize = properties["lightsize"] or 120
    self.once = properties["once"] ~= false
end

function ChurchPianoHint:onLoad()
    super.onLoad(self)
    if self.once and self:getFlag("used_once", false) then
		if self.create_light then
			local xx, yy = self:getRelativePos(self.width/2, self.height/2)
			local light = Registry.createLegacyEvent("lightfollowing", {x = xx, y = yy})
			light.target = nil
			light.size = 1
			self.world.timer:lerpVar(light, "size", 1, self.lightsize, 30, -1, "out")
			self.world:spawnObject(light)
		end
		self.world.timer:lerpVar(self, "hintalpha", 0, 1, 30, 2, "out")
		self.hintactive = true
    end
end

function ChurchPianoHint:onAdd(parent)
    super.onAdd(self,parent)
    local i = 1
    while i <= StringUtils.len(self.hint) do
        local hint_num = tonumber(StringUtils.sub(self.hint, i, i))
		table.insert(self.hint_units, {note = hint_num})
        i = i + 1
    end
	if self.hintactive then
		Game.world.timer:tween(30/30, self, {hintalpha = 1}, 'out-quad')
	end
end

function ChurchPianoHint:update()
	super.update(self)
	if self.group then
		for _, button in ipairs(Game.world.map:getEvents("tilebutton")) do
			if button.group == self.group then
				if button.pressed then
					self.trigger = true
				end
			end
		end
		for _, button in ipairs(Game.world.map:getEvents("churchtilebutton")) do
			if button.group == self.group then
				if button.pressed then
					self.trigger = true
				end
			end
		end
	end
	if self.trigger and not self.hintactive then
		if not self.silent then
			Assets.playSound("spearappear", 0.45, 1.2)
			Assets.playSound("spearappear", 0.65, 1.3)
			Assets.playSound("spearappear", 0.85, 1.4)
		end
		if self.create_light then
			local xx, yy = self:getRelativePos(self.width/2, self.height/2)
			local light = Registry.createLegacyEvent("lightfollowing", {x = xx, y = yy})
			light.target = nil
			light.size = 1
			self.world.timer:lerpVar(light, "size", 1, self.lightsize, 30, -1, "out")
			self.world:spawnObject(light)
		end
		self.world.timer:lerpVar(self, "hintalpha", 0, 1, 30, 2, "out")
		self.hintactive = true
        if self.once then
            self:setFlag("used_once", true)
        end
	end
end

function ChurchPianoHint:draw()
	super.draw(self)
	if self.hintactive then
		self.siner = self.siner + 1 * DTMULT
		local count = #self.hint_units
		local drawspace = 8
		local spwid = 22
		local width = (count - 1) * (drawspace * spwid)
		for i, unit in ipairs(self.hint_units) do
			local sprangle = 0
			local scale = 2
			local spr = self.arrowspr
			local offx, offy = 5, 5
			local num = unit.note or 0
			local xloc = (spwid + drawspace) * i
			local yloc = (math.sin((self.siner + (i * 4)) / 8) * 4) + 20
			local col = ColorUtils.mergeColor(self.hintcol, COLORS.white, MathUtils.clamp(0.5 + (math.sin((self.siner - (i * 30)) / 15) * 0.25), 0, 1))
			if num ~= 0 then
				sprangle = math.rad(-(num * 45 - 180 - 45))
			else
				spr = self.circlespr
				offx, offy = 3, 3
				scale = 2
			end
			love.graphics.setColor(col[1], col[2], col[3], self.hintalpha)
			Draw.draw(spr, xloc, yloc, sprangle, scale, scale, offx, offy)
			if i == 1 and self.stafftype == "start" then
				Draw.draw(self.staffspr[1], xloc - 40, (math.sin((self.siner + ((i - 1) * 4)) / 8) * 4) - 28 + 20, 0, 2, 2, 0, 0)
			end
			if i == #self.hint_units and self.stafftype == "end" then
				Draw.draw(self.staffspr[2], xloc + 40 - 22, (math.sin((self.siner + ((i + 1) * 4)) / 8) * 4) - 28 + 20, 0, 2, 2, 0, 0)
			end
		end
	end
	love.graphics.setColor(1,1,1,1)
end

return ChurchPianoHint