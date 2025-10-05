-- Basically a character that automatically walks
-- (Really bad name but Idk how to name things)
local CharacterWalker, super = Class(Character)

function CharacterWalker:init(actor, x, y, limit, fake)
    super.init(self, actor, x, y)
    self:setLayer(-2)
    self:setFacing('up')
    self.until_move_again = Utils.random(20, 40)
    self.speed = 2
    self.limit = limit
    self.last_moved = 0
    self.last_moved_set = false
    
    if fake then self.collider.collidable = false
    else
        self.collider = Hitbox(self, 1, 5, 17, 16)
    end
end

function CharacterWalker:update()
    if self.until_move_again < 0 then
        self.until_move_again = Utils.random(20, 30)
        local range = 20
        if Utils.random(1, 2, 1) == 1 then
            self:walkToSpeed(self.x + Utils.pick({-20, 20}), self.y, self.speed)
        else
            self:walkToSpeed(self.x, self.y + Utils.pick({-20, 20}), self.speed)
        end
    end

    if self.physics.move_target ~= nil then
        -- If this character reaches a border, flips around and continue walking
        if self.x < self.limit.left then
            local remaining_x = self.physics.move_target.x - self.x
            self.x = 2 * self.limit.left - self.x
            self:walkToSpeed(self.x - remaining_x, self.y, self.speed)
        elseif self.x > self.limit.right then
            local remaining_x = self.physics.move_target.x - self.x
            self.x = 2 * self.limit.right - self.x
            self:walkToSpeed(self.x - remaining_x, self.y, self.speed)
        elseif self.y < self.limit.up then
            local remaining_y = self.physics.move_target.y - self.y
            self.y = 2 * self.limit.up - self.y
            self:walkToSpeed(self.x, self.y - remaining_y, self.speed)
        elseif self.y > self.limit.down then
            local remaining_y = self.physics.move_target.y - self.y
            self.y = 2 * self.limit.down - self.y
            self:walkToSpeed(self.x, self.y - remaining_y, self.speed)
        end
    else
        self.until_move_again = self.until_move_again - DTMULT
    end

    self.moved = 4

    super.update(self)
end

function CharacterWalker:draw()
    super.draw(self)
    if DEBUG_RENDER and self.collider and self.collider.collidable then self.collider:draw() end
end

return CharacterWalker