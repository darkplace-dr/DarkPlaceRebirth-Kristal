---@class Player : Player
---@field world World
local Player, super = HookSystem.hookScript(Player)

function Player:init(chara, x, y)
    super.init(self, chara, x, y)
    self.onrotatingtower = false
    self.falseloop = false
	self.falseloopx = {}
    self.lastx, self.lasty = self.x, self.y
end

function Player:beginClimbMount(last_state, settings)
    if Game.world.map.cyltower then
        self.onrotatingtower = true
		self.falseloop = true
		self.falseloopx = {}
		self.falseloopx[1] = 0
		self.falseloopx[2] = self.world.map.cyltower.tower_circumference
    end
    super.beginClimbMount(self, last_state, settings)
end

function Player:beginClimbDismount(last_state, settings)
    super.beginClimbDismount(self, last_state, settings)
    if Game.world.map.cyltower then
        self.onrotatingtower = false
		self.falseloop = false
    end
    self.x = self.lastx
    self.y = self.lasty
end

function Player:preDraw()
	self.lastx, self.lasty = self.x, self.y
	if self.onrotatingtower then
		self.x = Game.world.map.cyltower.krisx
		self.y = Game.world.map.cyltower.krisy
	end
	super.preDraw(self)
end

function Player:postDraw()
	super.postDraw(self)
	self.x = self.lastx
	self.y = self.lasty
    if self.onrotatingtower then
		self.x = MathUtils.wrap(self.x, self.falseloopx[1], self.falseloopx[2])
	end
end

return Player