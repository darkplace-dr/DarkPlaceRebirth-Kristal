---@class Event.prophecy : Event
local event, super = Class(Event, "prophecy")

function event:init(data)
    super.init(self, data)
    self.container = Object(self.width/2,0)
    self:addChild(self.container)
    local properties = data and data.properties or {}
    if properties.texture then
        self:setSprite(properties.texture)
    end
    self.afx = self:addFX(AlphaFX(0))
    if properties.text then
        self:setText(properties.text)
    end
    self.text_offset_x = properties.toff_x or 0
    self.text_offset_y = properties.toff_y or 0
end

function event:getSortPosition()
    return self.x,self.y
end

function event:setSprite(texture)
    if self.sprite then self.sprite:remove() end
    if not texture then return end
    self.sprite = Sprite(texture)
    self.sprite:setOrigin(0.5,1)
    self.container:addChild(self.sprite)
    self.sprite:setScale(2)
    self.sprite:addFX(ProphecyScrollFX())
    self.sprite:addFX(ProphecyEchoFX())
end

function event:setText(text)
    if self.text then self.text:remove() end
    if not text then return end
    self.text = Text(nil, self.text_offset_x, -self.height, {auto_size = true})
    self.text.font = "legend"
    self.text.font_size = 32
    self.text:setText(text)
    self.text:setOrigin(0.5, 1)

    self.text:addFX(ProphecyScrollFX())
    self.container:addChild(self.text)
end

function event:update()
    super.update(self)
    self.container.y = Utils.wave(Kristal.getTime()*2, -10, 10)
    if self.sprite and self.text then
        self.text.y = -self.sprite:getScaledHeight() + self.text_offset_y
    else
        self.text.y = self.text_offset_y
    end
    Object.startCache()
    if self:collidesWith(self.world.player) then
        self.afx.alpha = Utils.approach(self.afx.alpha, 1, DT*4)
    else
        self.afx.alpha = Utils.approach(self.afx.alpha, 0, DT*2)
    end
    Object.endCache()
end

return event