---@class Inverse_block : Event
local Inverse_block, super = Class(Event)

function Inverse_block:init(x, y, shape)
    super.init(self, x, y, shape)
    self.solid = false
    self.siner = 0
    self.y = self.y
    self.init_x = self.x
    self.init_y = self.y
    self.spritething = Assets.getTexture("world/inverse_block")
    self.reset = 0
end

function Inverse_block:update()
    super.update(self)
    self.prevx = self.x
    self.prevy = self.y
    self.target_y = Game.world.map:getEvent(self.data.properties.target.id).y
    self.target_x = Game.world.map:getEvent(self.data.properties.target.id).x
    self.x_offset = (self.data.properties.x_offset)*40 or 0
    self.y_offset = (self.data.properties.y_offset)*40 or 0
    self.siner = self.siner + 1
    self.y = self.target_y
    self.x = self.target_x + self.x_offset
    self.y = self.y + self.y_offset

    if self.reset >= 0 then
        self.reset = self.reset - 1
    self.prevx = self.init_x
    self.prevy = self.init_y
        self.x = self.init_x
    self.y = self.init_y
end

        if self.particle == true and (self.x == self.prevx and self.y == self.prevy) then
                self.particle = false
                Assets.playSound("poofnoise")
            obj = Game.world:spawnObject(poof())
            obj.x = self.prevx+20
            obj.y = self.prevy+20
            for i = 0, 5 do
            obj = Game.world:spawnObject(poofbig())
            obj.x = self.x+20
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
            if not (self.x == self.prevx and self.y == self.prevy) then
                self.particle = true
            end
            self.y = self.prevy
            self.x = self.target_x + self.x_offset
        end
    end
    Object.endCache()

Object.startCache()
    for _, objstuck in ipairs(Game.stage:getObjects(n)) do
        if self:meetsObject(objstuck) then
            if not (self.x == self.prevx and self.y == self.prevy) then
                self.particle = true
            end
            self.x = self.prevx
            self.y = self.target_y + self.y_offset
        end
    end
    Object.endCache()

    Object.startCache()
    for _, objstuck in ipairs(Game.stage:getObjects(n)) do
        if self:meetsObject(objstuck) then
            if not (self.x == self.prevx and self.y == self.prevy) then
                self.particle = true
            end
            self.x = self.prevx
            self.y = self.prevy
        end
    end
    Object.endCache()

end


function Inverse_block:draw()
    super.draw(self)
    Draw.draw(self.spritething,0,math.sin(self.siner/5)*3 + 6, 0, 2)
end


return Inverse_block
