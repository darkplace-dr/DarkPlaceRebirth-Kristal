---@class Copy_block : Event
---@field target             number
---@field offset_x           number
---@field offset_y           number
local Copy_block, super = Class(Event)
---@param properties table

function Copy_block:init(x, y, shape, properties)
    super.init(self, x, y, shape)
    self.properties = properties or {}
    self.solid = false
    self.siner = 0
    self.y = self.y
    self.init_x = self.x
    self.init_y = self.y
    self.spritething = Assets.getTexture("world/copy_block")
    self.reset = 0
end
function Copy_block:postLoad()
    self.target = Game.world.map:getEvent(self.data.properties.target.id)
    self.target_y = self.target.y
    self.target_x = self.target.x
    self.x_offset = self.x - self.target_x
    self.y_offset = self.y - self.target_y
    self.init_x_offset = self.x_offset
    self.init_y_offset = self.y_offset
end

function Copy_block:update()
    super.update(self)
    self.prevx = self.x
    self.prevy = self.y
    self.target_y = self.target.y
    self.target_x = self.target.x
    self.siner = self.siner + 1
    self.y = self.target_y
    self.x = self.target_x + self.x_offset
    self.y = self.y + self.y_offset
            self.storedx = self.prevx
        self.storedy = self.prevy

    if self.reset >= 0 then
        self.reset = self.reset - 1
        self.x = self.init_x
    self.y = self.init_y
    self.x_offset = self.init_x_offset
    self.y_offset = self.init_y_offset
            self.storedx = self.prevx
        self.storedy = self.prevy
end

        if self.particle == true then
                self.particle = false
                Assets.playSound("poofnoise")
            obj = Game.world:spawnObject(poof())
            obj.copy = true
            obj.x = self.storedx+20
            obj.y = self.storedy+20
            for i = 0, 5 do
            obj = Game.world:spawnObject(poofbig())
            obj.x = self.x+20
            obj.copy = true
            obj.y = self.y+20
            obj:setScale(1.25)
                obj.physics.direction = math.rad(60 * i)
                obj.physics.speed = 8
                obj.physics.friction = 0.4
            end
    end

    Object.startCache()
    for _, objstuck in ipairs(Game.stage:getObjects(n)) do
        if self:meetsObject(objstuck) then
            self.x = self.prevx
            self.y = self.prevy
    self.x_offset = self.x - self.target_x
    self.y_offset = self.y - self.target_y
        end
    end
    Object.endCache()

end


function Copy_block:draw()
    super.draw(self)
    Draw.draw(self.spritething,0,math.sin(self.siner/5)*3 + 6, 0, 2)
end


return Copy_block
