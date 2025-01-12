local PressIndicator, super = Class(Object, "PressIndicator")

function PressIndicator:init(x, y)
    super.init(self, x, y)

    self.layer = BATTLE_LAYERS["above_ui"] + 5

    self.press_sprite = Sprite("ui/lightbattle/press")
    self.press_sprite:setOrigin(0.5)
    self:addChild(self.press_sprite)

    local key = Input.getPrimaryBind("confirm")

    key = string.gsub(key, "kp", "", 1)

    if Input.usingGamepad() then
        self.button_sprite = Sprite(Input.getTexture("confirm"), 2, 12)
        self.button_sprite:setScale(2)
        self.button_sprite:setOrigin(0.5)
    else
        local texture
        if Assets.getTexture("ui/lightbattle/pressindicator/" .. key) then
            texture = Assets.getTexture("ui/lightbattle/pressindicator/" .. key)
        else
            texture = Assets.getTexture("ui/lightbattle/pressindicator/why")
        end
        self.button_sprite = Sprite(texture)
        self.button_sprite:setOrigin(0.5)
    end
    self:addChild(self.button_sprite)

    self.timer = 3
end

function PressIndicator:update()
    self.timer = Utils.approach(self.timer, 0, DTMULT)

    if self.visible then
        if self.timer == 0 then
            self.timer = 6
            self.visible = false
        end
    else
        if self.timer == 0 then
            self.timer = 3
            self.visible = true
        end
    end
end

return PressIndicator