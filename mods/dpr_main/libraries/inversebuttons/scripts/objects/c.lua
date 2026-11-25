---@class c : Event
local c, super = Class(Event)

function c:init(x, y, shape)
    super.init(self, x, y, shape)
    self.solid = true
            self.width = 40
        self.height = 40
        self:setHitbox(self.x,self.y,40,40)
end
function c:update()
    super.update(self)

    if self.scream == true then
        self.scream = false
        self.solid = true
    end
    
        Object.startCache()
    for _, obj in ipairs(Game.stage:getObjects(Inverse_block)) do
        if self:meetsObject(obj) then
            -- yeah we're colliding with object
            -- make sure that every `startCache` has a matching `endCache`! very important, especially if you return early
            self.solid = false
            self.scream = true
            break
        end
    end
    Object.endCache()
        Object.startCache()
    for _, obj in ipairs(Game.stage:getObjects(Copy_block)) do
        if self:meetsObject(obj) then
            -- yeah we're colliding with object
            -- make sure that every `startCache` has a matching `endCache`! very important, especially if you return early
            self.solid = false
            self.scream = true
            break
        end
    end
    Object.endCache()
end

return c
