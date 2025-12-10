local StarLasers, super = Class(Wave)

function StarLasers:init()
    super.init(self)
    self.time = 8
    self:setArenaSize(160, 120)
end

function StarLasers:onStart()
end

function StarLasers:update()

    super.update(self)
end

return StarLasers