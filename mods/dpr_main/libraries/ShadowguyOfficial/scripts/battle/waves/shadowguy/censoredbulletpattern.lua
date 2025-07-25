local ShadowguyCaption, super = Class(Wave)

function ShadowguyCaption:init()
    super.init(self)

	self.time = 70/30
end

function ShadowguyCaption:onStart()
    local caption = self:spawnSprite("bullets/shadowguy/caption", 320, 170, BATTLE_LAYERS["above_soul"])
    caption:setScale(1)
end

return ShadowguyCaption