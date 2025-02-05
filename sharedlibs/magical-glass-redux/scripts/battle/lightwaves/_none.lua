local wave, super = Class(LightWave)

function wave:init()
    super.init(self)
    
    self.time = 0
end

return wave