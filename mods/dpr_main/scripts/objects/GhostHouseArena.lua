local GhostHouseArena, super = Class(Object)

function GhostHouseArena:init(x, y, sprite)
    super.init(self, x, y)
    self:setOrigin(0.5, 0.5)

    self.color = {0, 0.75, 0}

    self.x = math.floor(self.x)
    self.y = math.floor(self.y)

    self.sprite_outer = Sprite("battle/ghost_house/"..sprite, 0, 0)
	self.sprite_outer:setScale(2,2)
	self.sprite_outer.inherit_color = true
	self.sprite_outer:setLayer(self.layer + 3)
    self:addChild(self.sprite_outer)
    self.sprite_bg = Sprite("battle/ghost_house/"..sprite.."_bg", 0, 0)
	self.sprite_bg:setScale(2,2)
	self.sprite_bg.inherit_color = true
	self.sprite_bg:setLayer(self.layer)
    self:addChild(self.sprite_bg)
    self.sprite_inner = Sprite("battle/ghost_house/"..sprite.."_inner", 0, 0)
	self.sprite_inner:setScale(2,2)
	self.sprite_inner.inherit_color = true
	self.sprite_inner:setLayer(self.layer + 1)
    self:addChild(self.sprite_inner)
    self.mask = nil
	self.fade_in = 1
	self.arena_fade = 1
	
	self:setShape(sprite)
end

function GhostHouseArena:setShape(sprite)
	self.sprite_outer:setSprite("battle/ghost_house/"..sprite)
	self.sprite_bg:setSprite("battle/ghost_house/"..sprite.."_bg")
	self.sprite_inner:setSprite("battle/ghost_house/"..sprite.."_inner")
	
	self.width = self.sprite_outer.texture:getWidth()*2
	self.height = self.sprite_outer.texture:getHeight()*2
	
    self.left = math.floor(self.x - self.width/2)
    self.right = math.floor(self.x + self.width/2)
    self.top = math.floor(self.y - self.height/2)
    self.bottom = math.floor(self.y + self.height/2)
end

---@return number x
---@return number y
function GhostHouseArena:getCenter()
    return self:getRelativePos(self.width/2, self.height/2)
end

---@return number x
---@return number y
function GhostHouseArena:getTopLeft() return self:getRelativePos(0, 0) end
---@return number x
---@return number y
function GhostHouseArena:getTopRight() return self:getRelativePos(self.width, 0) end
---@return number x
---@return number y
function GhostHouseArena:getBottomLeft() return self:getRelativePos(0, self.height) end
---@return number x
---@return number y
function GhostHouseArena:getBottomRight() return self:getRelativePos(self.width, self.height) end

---@return number x
function GhostHouseArena:getLeft() local x, y = self:getTopLeft(); return x end
---@return number x
function GhostHouseArena:getRight() local x, y = self:getBottomRight(); return x end
---@return number y
function GhostHouseArena:getTop() local x, y = self:getTopLeft(); return y end
---@return number y
function GhostHouseArena:getBottom() local x, y = self:getBottomRight(); return y end

---@param parent Object
function GhostHouseArena:onAdd(parent)
	super.onAdd(self, parent)
	Game.battle.timer:tween(1, self, {arena_fade = 0.75}, "out-sine")
end

---@param parent Object
function GhostHouseArena:onRemove(parent)
	super.onRemove(self, parent)
end

function GhostHouseArena:update()
    super.update(self)
end

function GhostHouseArena:drawMask()
    love.graphics.push()
    self.sprite_bg:preDraw()
    self.sprite_bg:postDraw()
    self.sprite_inner:preDraw()
    self.sprite_inner:postDraw()
    self.sprite_outer:preDraw()
    self.sprite_outer:postDraw()
    love.graphics.pop()
end

function GhostHouseArena:draw()
    super.draw(self)

    if DEBUG_RENDER and self.collider then
        self.collider:draw(0, 0, 1)
    end
end

return GhostHouseArena