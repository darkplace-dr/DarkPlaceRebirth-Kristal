---@class DiscoBall : Object
local DiscoBall, super = Class(Object)

function DiscoBall:init()
    super.init(self, SCREEN_WIDTH/2, -120, 56*2, 60*2)

	self.draw_children_below = 0
	
    self.sprite = Sprite("battle/discoball")
    self.layer = BATTLE_LAYERS["below_battlers"]
    self.sprite:setScale(2)
    self:setOrigin(0.5, 0)
    self.sprite:play(1/5, true)
    self:addChild(self.sprite)
    self.back_sprite = Sprite("battle/discoball_back")
    self.back_sprite:setScale(2)
	self.back_sprite.layer = -1
    self:addChild(self.back_sprite)

	self.siner = 0
	self.hsv_color = COLORS.white
	self.persist_to_world = false
	self.discoball_original_x = nil
	self.discoball_original_y = nil
end

function DiscoBall:onRemoveFromStage(stage)
    super.onRemoveFromStage(self, stage)
    if self.persist_to_world and self.parent and self.parent:includes(Battle) and Game.world then
        local x, y = self:getScreenPos()
        self:setParent(Game.world)
		if self.discoball_original_x then
			x = self.discoball_original_x
		end
		if self.discoball_original_y then
			y = self.discoball_original_y
		end
        self:setScreenPos(x, y)
		Game.world.discoball = self
    end
end

function DiscoBall:update()
    super.update(self)

    local function fcolor(h, s, v)
        self.hue = (h / 255) % 1
        return ColorUtils.HSVToRGB((h / 255) % 1, s / 255, v / 255)
    end

	self.siner = self.siner + DTMULT
    self.hsv_color = {fcolor(self.siner / 4, 255, 220 + (math.sin(self.siner / 15) * 30))}
	self.back_sprite:setColor(self.hsv_color)
end

return DiscoBall