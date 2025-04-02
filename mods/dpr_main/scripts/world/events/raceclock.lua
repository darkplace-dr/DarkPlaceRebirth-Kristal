local Clock10, super = Class(Event)

function Clock10:init(data)
    super:init(self, data.center_x, data.center_y, data.width, data.height)

    self:setOrigin(0.5, 0.5)
    self:setSprite("clockoff")
    self.timer = 0
    Game:setFlag("tl_clock", false)
end

function Clock10:onInteract()
    Assets.playSound("squeak")
    self:setSprite("clock")
    self.sprite:play(1)
    Game:setFlag("tl_clock", true)
    self.timer = 12 -- set the timer to 5 seconds
end
  
function Clock10:update()
    super:update(self)
    if self.timer > 0 then -- only subtract from the timer if it's currently active
        self.timer = self.timer - DT -- subtract time from the timer
        if self.timer <= 0 then -- the timer reached 0 this frame
            Assets.playSound("squeak")
            self:setSprite("clockoff")
            Game:setFlag("tl_clock", false)
        end
    end
end

return Clock10