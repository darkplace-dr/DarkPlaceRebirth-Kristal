local RentTable, super = Class(Event)

function RentTable:init(data)
    super.init(self, data)

    local spr = "world/events/floor2/rentTable/station"
    self.sprite = Sprite(spr)
    self.sprite:setScale(2)
    self:addChild(self.sprite)

    local spr = "world/events/floor2/rentTable/star"
    local w, h = self.sprite:getSize()
    self.star = Sprite(spr)
    self.star:setOrigin(0.5, 0.5)
    self.star:setScale(2)
    self.star:setPosition(w / 2, h / 2)
    self:addChild(self.star)

    self.solid = true
    self.timer = 0
end

function RentTable:update()
    super.update(self)

    local sin = math.sin(self.timer) / 8
    self.star.rotation = self.star.rotation + sin
    self.timer = self.timer + DT
end

function RentTable:setSprite(path)
    self.sprite:setSprite(path)
    self:setFlag("sprite", path)
end

function RentTable:onInteract(player, dir)
    -- Game.world:startCutscene("floor2.rentdoor", self)
    return true
end

function RentTable:onAdd(parent)
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

function RentTable:onRemove(parent)
    super.onRemove(self, parent)

    -- self:setFlag("sprite", self.sprite:getTexture()) This method bricks your savefile, use RentTable:setSprite(path) if you need to change the sprite instead
    self:setFlag("solid", self.solid)
end

return RentTable