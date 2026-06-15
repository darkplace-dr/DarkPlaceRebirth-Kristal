local wave, super = Class(LightWave)

function wave:init()
    super.init(self)

    self:setArenaSize(155, 130)
    self.soul_offset_x = -4
end

function wave:canEnd()
    return false
end

return wave