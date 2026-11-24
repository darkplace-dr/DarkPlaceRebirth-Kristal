---@class cmaker : Event
local cmaker, super = Class(Event)

function cmaker:init(x, y, shape)
    super.init(self, x, y, shape)
    self.solid = false
end
function cmaker:postLoad()
    for i2=0,self.height/40-1 do
        for i=0,self.width/40-1 do
            obj = Game.world:spawnObject(c())
            obj.x = self.x + i*40
            obj.y = self.y + i2*40
        end
    end
    self:remove()
end

return cmaker
