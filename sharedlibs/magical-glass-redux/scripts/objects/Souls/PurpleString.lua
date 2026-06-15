local PurpleString, super = Class(Object)

function PurpleString:init(x1, y1, x2, y2, w, lay)
    super.init(self, x1, y1)

    self:setLayer(lay or (Game.battle.light and LIGHT_BATTLE_LAYERS["below_soul"] or BATTLE_LAYERS["below_soul"]))

    self.x = x1
    self.y = y1
    self.x2 = x2
    self.y2 = y2
    
    self.width = w or 1

    self.last_x = self.x
    self.last_y = self.y

    self:updateLineData()
end

function PurpleString:updateLineData()
    self.len = MathUtils.dist(self.x, self.y, self.x2, self.y2)
    self.rot = Utils.angle(self.x, self.y, self.x2, self.y2)

    self.left_bound = {
        x = 0,
        y = 0
    }

    self.right_bound = {
        x = self.x2 - self.x,
        y = self.y2 - self.y
    }

    self.collider = LineCollider(self, self.left_bound.x, self.left_bound.y, self.right_bound.x, self.right_bound.y)
end

function PurpleString:setPoints(x1, y1, x2, y2)
    self.x = x1
    self.y = y1
    self.x2 = x2
    self.y2 = y2

    self.last_x = self.x
    self.last_y = self.y

    self:updateLineData()
end

function PurpleString:getPositionBetweenBounds(progress)
    local x = self.left_bound.x + (self.right_bound.x - self.left_bound.x) * progress
    local y = self.left_bound.y + (self.right_bound.y - self.left_bound.y) * progress
    return x, y
end

function PurpleString:getProgressFromLocation(x, y)
    local dist = MathUtils.dist(self.x, self.y, x, y)
    return dist / self.len
end

function PurpleString:update()
    super.update(self)

    -- Move endpoint 2 along with endpoint 1 if the object moved
    local dx = self.x - self.last_x
    local dy = self.y - self.last_y

    if dx ~= 0 or dy ~= 0 then
        self.x2 = self.x2 + dx
        self.y2 = self.y2 + dy
    end

    self.last_x = self.x
    self.last_y = self.y

    self:updateLineData()
end

function PurpleString:draw()
    super.draw(self)

    love.graphics.setLineWidth(self.width)
    Draw.setColor(128 / 255, 0, 128 / 255, 1)

    love.graphics.line(self.left_bound.x, self.left_bound.y, self.right_bound.x, self.right_bound.y)

    if DEBUG_RENDER then
        self.collider:draw(0, 1, 1)
    end
end

return PurpleString