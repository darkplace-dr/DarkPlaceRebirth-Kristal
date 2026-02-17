local TileButtonPuzzleClock, super = Class(Event)

function TileButtonPuzzleClock:init(data)
    super.init(self, data)

    self:setSprite("world/events/hourglass_switch/off")
	
    properties = data and data.properties or {}

	self.wonamt = 1
	self.wonmax = properties["amount"]
	self.puzzactive = 0
	self.failtimer = 0
	self.failmax = properties["time"] or 200
	self.funbuffer = 0
	self.funbufferdt = 0
	self.tilebuttons = {}
	self.flags = {}
	for i = 1, self.wonmax do
		self.tilebuttons[i] = TiledUtils.parsePropertyList("puz"..i.."button", properties)
		self.flags[i] = properties["puz"..i.."flag"]
	end
    self.flag = properties["flag"]
    self.once = properties["once"]
end

function TileButtonPuzzleClock:onLoad()
    for _,obj in ipairs(self.world.map:getEvents("tilebutton")) do
		obj.player_activated = false
		obj.npc_activated = false
		obj.pressed = false
		obj:setSprite("world/events/glowtile/off")
    end
	if self.once and self:getFlag("solved") then
		self.puzzactive = 2
	end
end

function TileButtonPuzzleClock:onInteract()
	if self.puzzactive ~= 0 then return false end
	Assets.playSound("noise")
	self.puzzactive = 1
	self.failtimer = 0
    self:setSprite("world/events/hourglass_switch/on")
	self.sprite:setFrame(1)
    self:resetFlags()
    self:nextPuzzle()
	return true
end

function TileButtonPuzzleClock:resetFlags()
	for i = 1, self.wonmax do
		Game:setFlag(self.flags[i], false)
	end
	self.wonamt = 1
end

function TileButtonPuzzleClock:nextPuzzle()
	self.funbuffer = 0
	for _,obj in ipairs(self.world.map:getEvents("tilebutton")) do
		obj.player_activated = false
		obj.npc_activated = false
		obj.pressed = false
		obj:setSprite("world/events/glowtile/off")
    end
	if self.wonamt < self.wonmax + 1 then
		for _, obj in ipairs(self.tilebuttons[self.wonamt]) do
			local target = self.world.map:getEvent(obj.id)
			target.player_activated = true
			target.npc_activated = true
			target:setSprite(target.idle_sprite, 5/30)
		end
	end
end

function TileButtonPuzzleClock:update()
	local curtotal = 0
	self.funbufferdt = self.funbufferdt + DTMULT
	if self.funbufferdt >= 1 then
		self.funbuffer = self.funbuffer - 1
		self.funbufferdt = 0
	end
	if self.wonamt < self.wonmax + 1 then
		for _, obj in ipairs(self.tilebuttons[self.wonamt]) do
			local target = self.world.map:getEvent(obj.id)
			if target.pressed then
				curtotal = curtotal + 1
			end
		end
		if curtotal == #self.tilebuttons[self.wonamt] and self.funbuffer < -1 then
			if self.flags[self.wonamt] then
				Game:setFlag(self.flags[self.wonamt], true)
			end
			self.wonamt = self.wonamt + 1
			Assets.playSound("break1")
			self.funbuffer = 7
			if self.wonamt == self.wonmax + 1 then
				self.puzzactive = 2
				self:setSprite("world/events/hourglass_switch/off")
				self.funbuffer = -1
				self:setFlag("solved", true)
				if self.flag then
					Game:setFlag(self.flag, true)
				end
				for _,obj in ipairs(self.world.map:getEvents("tilebutton")) do
					obj.player_activated = false
					obj.npc_activated = false
					obj.pressed = false
					obj:setSprite("world/events/glowtile/off")
				end
			end
		end
	end
	if self.funbuffer == 4 then
		for _,obj in ipairs(self.world.map:getEvents("tilebutton")) do
			obj.player_activated = false
			obj.npc_activated = false
			obj.pressed = false
			obj:setSprite("world/events/glowtile/off")
		end
	end
	if self.funbuffer == 1 then
		self:nextPuzzle()
	end
	if self.puzzactive == 1 then
		self.failtimer = self.failtimer + DTMULT
		self.sprite:setFrame(math.floor(self.failtimer / (self.failmax / 8)) + 1)
		if self.failtimer >= self.failmax then
			self.puzzactive = 0
			self:setSprite("world/events/hourglass_switch/off")
			Assets.playSound("noise")
			for _,obj in ipairs(self.world.map:getEvents("tilebutton")) do
				obj.player_activated = false
				obj.npc_activated = false
				obj.pressed = false
				obj:setSprite("world/events/glowtile/off")
			end
		end
	end
end

return TileButtonPuzzleClock