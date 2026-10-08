local DanceFloorZone, super = Class(Event)

function DanceFloorZone:init(data)
    super.init(self, data)

    self.dance_timer_max = 160
    self.dance_timer = self.dance_timer_max
end

function DanceFloorZone:update()
    local player = Game.world.player
    if self:meetsObject(Game.world.player) then
        if not player:isDancing() then
            if not player:isMoving() then
                self.dance_timer = self.dance_timer - DTMULT
            end
            if self.dance_timer <= 0 then
                self.dance_timer = self.dance_timer_max
                player:setDancing(true)
                for _, follower in ipairs(Game.world.followers) do
                    follower:setDancing(true)
                end
            end
        end
    else
        self.dance_timer = self.dance_timer_max
    end

    super.update(self)
end

return DanceFloorZone
