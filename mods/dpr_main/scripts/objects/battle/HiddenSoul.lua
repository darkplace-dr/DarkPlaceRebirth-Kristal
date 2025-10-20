local HiddenSoul, super = Class(Object)

function HiddenSoul:init()
    super.init(self, 0, 0)
	self:setOrigin(0.5, 0.5)
    self.color = {1,0,0}
	self.sprite = Sprite("player/up/heart_hidden") -- Creating this first so sprite_focus will be on top of it
    self.sprite:setOrigin(0.5, 0.5)
    self.sprite.inherit_color = true
    self.sprite.debug_select = false
    self:addChild(self.sprite)

	self.sprite_focus = Sprite("player/heart_dodge_focus")
    self.sprite_focus:setOrigin(0.5, 0.5)
    self.sprite_focus.inherit_color = false
	self.sprite_focus.alpha = 0
    self.sprite_focus.debug_select = false
    self:addChild(self.sprite_focus)
    self.layer = BATTLE_LAYERS["above_bullets"]+1
end

function HiddenSoul:update()
	if not Game.battle.soul then
		self:remove()
		return
	end
    if Game.battle.soul.inv_timer > 0 then
        local amt = math.floor(Game.battle.soul.inv_flash_timer / (4/30))
        if (amt % 2) == 1 then
            self.sprite:setColor(0.5, 0.5, 0.5)
        else
            self.sprite:setColor(1, 1, 1)
        end
    else
        self.sprite:setColor(1, 1, 1)
    end
	self.x = Game.battle.soul.x
	self.y = Game.battle.soul.y
	if Input.down("cancel") then
		self.sprite_focus.alpha = 1
	else
		self.sprite_focus.alpha = 0
	end
end

return HiddenSoul