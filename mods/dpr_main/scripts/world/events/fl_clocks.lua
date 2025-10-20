local fl_Clock, super = Class(Event)

function fl_Clock:init(data)
    super.init(self, data)

    self.clock = Sprite("world/events/tower/clock") --sprite object
    self:addChild(self.clock) --add sprite object to self
    self.y_hold = self.clock.y --the original y coords
    self.clock:setOrigin(0.3, 0.4)
    self.siner = 0
    self.x = data.x
    self.y = data.y

    local properties = data and data.properties or {}
    if properties.flip == true then
        self:setScale(-1)
    end
end

function fl_Clock:update()
    super.update(self)

    self.siner = self.siner + DTMULT
    local offset_y = math.sin(self.siner / 30) * 12
    self.clock.y = self.y_hold + offset_y
end

function fl_Clock:draw()
    super.draw(self)
end

return fl_Clock