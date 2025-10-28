---@class Textbox : Textbox
local Textbox, super = Utils.hookScript(Textbox)

function Textbox:init(x, y, width, height, default_font, default_font_size, battle_box)
	super.init(self, x, y, width, height, default_font, default_font_size, battle_box)
	self.tenna = false
	self.battletimer = -1
end

function Textbox:update()
	if self.battletimer >= 0 then
		self.battletimer = self.battletimer + DTMULT
	end
	if self.battle_box and self.actor then
		self.actor:onBattleUpdate(nil)
	end
    super.update(self)
end

function Textbox:setFace(face, ox, oy)
    super.setFace(self, face, ox, oy)
	self.tenna = false
	if not self.tenna and self.actor and self.actor.id == "tenna" and face == "battle" then
		self.tenna = Assets.getTexture("world/npcs/tenna/point_up")
		if self.battletimer <= 0 then
			self.battletimer = 0
		end
	end
end

function Textbox:setActor(actor)
    super.setActor(self, actor)
	self.tenna = false
end

function Textbox:draw()
    super.draw(self)
	if self.tenna then
		local sinsoff = math.sin(self.battletimer / 2) * 2
		local xoffset = 60
		local prog = MathUtils.clamp(self.battletimer / 10, 0, 1)
		local yoffset = MathUtils.lerpEaseIn(440, 224, prog, 2)
        Draw.draw(self.tenna, xoffset, yoffset, math.rad(sinsoff), 2, 2, 30, 118)
	end
end

return Textbox
