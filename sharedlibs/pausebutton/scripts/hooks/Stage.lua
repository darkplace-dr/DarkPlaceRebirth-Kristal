local Stage, super = Class(Stage)

function Stage:isPaused()
    return self == Game.stage and PauseLib.paused
end

function Stage:fullUpdate()
    local old_timescale = self.timescale
    if self:isPaused() then self.timescale = 0 end
    super.fullUpdate(self)
    self.timescale = old_timescale
end

function Stage:fullDraw()
    local old_timescale = self.timescale
    if self:isPaused() then self.timescale = 0 end
    super.fullDraw(self)
    self.timescale = old_timescale
end

return Stage