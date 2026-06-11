local RentDoor, super = Class(Event)

function RentDoor:init(data)
    super.init(self, data)

    local spr = "world/events/floor2/door/empty"
    self.sprite = Sprite(spr)
    self.sprite:setScale(2)
    self:addChild(self.sprite)

    self.solid = true
end

function RentDoor:setSprite(path)
    self.sprite:setSprite(path)
    self:setFlag("sprite", path)
end

function RentDoor:onInteract(player, dir)
    Game.world:startCutscene("floor2.rentdoor", self)
    return true
end

function RentDoor:onAdd(parent)
    super.onAdd(self, parent)

    local spr = self:getFlag("sprite")
    if spr then
        self.sprite:setSprite(spr)
    end

    local solid = self:getFlag("solid")
    if solid ~= nil then
        self.solid = solid
    end
end

function RentDoor:onRemove(parent)
    super.onRemove(self, parent)

    -- self:setFlag("sprite", self.sprite:getTexture()) This method bricks your savefile, use RentDoor:setSprite(path) if you need to change the sprite instead
    self:setFlag("solid", self.solid)
end

return RentDoor