local SakuraFubukiMini, super = Class(Event)

function SakuraFubukiMini:init(data)
	super.init(self, data)
	local properties = data and data.properties or {}
	self.pregen = properties["pregen"] ~= false
	self.rate = properties["rate"] or -4
end

function SakuraFubukiMini:onRemove(parent)
    super.onRemove(self,parent)
	self.ps:remove()
end

function SakuraFubukiMini:onAdd(parent)
    super.onAdd(self,parent)
    self:setLayer(WORLD_LAYERS["below_ui"])
    self:setPosition(0,0)
	self.ps = GMParticleSystem()
	self.ps.auto_draw = false
	self.ps:setLayer(self.layer)
	Game.world:addChild(self.ps)
	self.pe = self.ps:initEmitter()
	self.ps:createEmitter(self.pe)
	self.pt_petal = self.ps:initType()
	self.ps:partTypeSprite(self.pt_petal, Assets.getFrames("effects/particles/spin_petal_particlefps"), true, true, true)
	self.ps:partTypeLife(self.pt_petal, 140, 160)
	self.ps:partTypeDirection(self.pt_petal, -math.rad(225), -math.rad(225), 0, 0)
	self.ps:partTypeSpeed(self.pt_petal, 5, 6, 0, 0.5)
	self.ps:partTypeGravity(self.pt_petal, 0.1, -math.rad(160))
	self.ps:partTypeScale(self.pt_petal, 2, 2)
	local spread = 500
	local spreadhalf = spread * 0.5
	self.ps:emitterRegion(self.pe, 740 - spreadhalf, 740 + spreadhalf, -spreadhalf, spreadhalf + 50, "line", "linear")
	self.ps:emitterStream(self.pe, self.pt_petal, self.rate)
end

function SakuraFubukiMini:update()
    super.update(self)
	if self.pregen then
		self.pregen = false
		for i = 0, 240 do
			self.ps:update()
		end
	end
end

function SakuraFubukiMini:draw()
    super.draw(self)
	local cx, cy = Game.world.camera.x - SCREEN_WIDTH/2, Game.world.camera.y - SCREEN_HEIGHT/2
	local canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	love.graphics.clear()
	self.ps:drawIt()
	Draw.popCanvas()
	Draw.drawCanvas(canvas, cx, cy)
end

return SakuraFubukiMini