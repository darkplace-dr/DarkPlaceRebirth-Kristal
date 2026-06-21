local UnderPlayer, super = Class(Player)

function UnderPlayer:init(chara, x, y)
    super.init(self, chara, x, y)

    -- If 'true', the player will be unable to run, like in Undertale
    self.force_walk = not Kristal.getLibConfig("magical-glass", "undertale_movement_can_run")
    
    self.event_collide = false
    self.dancing = {buttons = false, collided = false, facing = false}
end

function UnderPlayer:getCurrentSpeed(running)
    local speed = self:getBaseWalkSpeed()
    if running then
        speed = speed + 5
    end
    return speed
end

function UnderPlayer:getDebugInfo()
    local info = super.getDebugInfo(self)
    
    TableUtils.removeValue(info, "Run timer: " .. self.run_timer)
    
    return info
end

function UnderPlayer:handleMovement()
    if Input.down("up") and Input.down("down") and not self.event_collide then
        self.dancing["buttons"] = true
    else
        self.dancing["buttons"] = false
        self.dancing["collided"] = false
        self.dancing["facing"] = false
    end
    
    local walk_x = 0
    local walk_y = 0

    if Input.down("left") then
        walk_x = walk_x - 1
    elseif Input.down("right") then
        walk_x = walk_x + 1
    end

    if self.dancing["collided"] == true then
        walk_y = walk_y + 1
        self.dancing["collided"] = false
    else
        if Input.down("up") then
            walk_y = walk_y - 1
        elseif Input.down("down") then
            walk_y = walk_y + 1
        end
    end
    
    if self.dancing["buttons"] and self.last_collided_x == true then
        walk_y = 0
    end

    self.moving_x = walk_x
    self.moving_y = walk_y

    local running = (Input.down("cancel") or self.force_run) and not self.force_walk
    if Kristal.Config["autoRun"] and not self.force_run and not self.force_walk then
        running = not running
    end

    local speed = self:getCurrentSpeed(running)
    
    if walk_x == 0 or walk_y == 0 then
        self.event_collide = false
    end

    self:move(walk_x, walk_y, speed * DTMULT)
    
    if self.dancing["buttons"] == true and self.last_collided_y == true then
        if self.dancing["facing"] == false then
            self:move(0, walk_y, speed * DTMULT)
        end
        self.dancing["collided"] = true
        self.dancing["facing"] = true
    end
end

function UnderPlayer:doMoveAmount(type, amount, other_amount)
    other_amount = other_amount or 0

    if amount == 0 then
        self["last_collided_" .. type] = false
        return false, false
    end

    local other = type == "x" and "y" or "x"

    local sign = MathUtils.sign(amount)
    for i = 1, math.ceil(math.abs(amount)) do
        local moved = sign
        if (i > math.abs(amount)) then
            moved = (math.abs(amount) % 1) * sign
        end

        local last_a = self[type]
        local last_b = self[other]

        self[type] = self[type] + moved

        if (not self.noclip) and (not NOCLIP) then
            Object.startCache()
            local collided, targets = self.world:checkCollisions(self.collider, self.enemy_collision)
            if collided and not (other_amount > 0) then
                for j = 1, 2 do
                    Object.uncache(self)
                    self[other] = self[other] - j
                    collided, targets = self.world:checkCollisions(self.collider, self.enemy_collision)
                    if not collided then break end
                end
            end
            if collided and not (other_amount < 0) then
                self[other] = last_b
                for j = 1, 2 do
                    Object.uncache(self)
                    self[other] = self[other] + j
                    collided, targets = self.world:checkCollisions(self.collider, self.enemy_collision)
                    if not collided then break end
                end
            end
            Object.endCache()

            if collided or self.event_collide then
                self[type] = last_a
                self[other] = last_b
                
                for _, target in ipairs(targets) do
                    if target:includes("Event") or target:includes("NPC") then
                        self.event_collide = true
                        break
                    end
                end

                for _, target in ipairs(targets) do
                    if target.onCollide then
                        target:onCollide(self)
                    end
                end

                self["last_collided_" .. type] = true
                return i > 1, targets
            end
        end
    end
    self["last_collided_" .. type] = false
    return true, false
end

function UnderPlayer:move(x, y, speed, keep_facing)
    local movex, movey = x * (speed or 1), y * (speed or 1)

    local moved = false
    moved = self:moveX(movex, movey) or moved
    moved = self:moveY(movey, movex) or moved

    if moved then
        self.moved = math.max(self.moved, math.max(math.abs(movex) / DTMULT, math.abs(movey) / DTMULT))

        self.sprite.walking = true
        self.sprite.walk_speed = self.moved > 0 and math.max(4, self.moved) or 0
    end

    if not keep_facing and (movex ~= 0 or movey ~= 0) then
        local dir = self:getFacing()
        if self.sprite.directional then
            local angle = math.atan2(movey, movex)
            if not Utils.isFacingAngle(dir, angle) then
                dir = Utils.facingFromAngle(math.atan2(movey, movex))
            end
        else
            if movex > 0 then
                dir = "right"
            elseif movex < 0 then
                dir = "left"
            elseif movey > 0 then
                dir = "down"
            elseif movey < 0 then
                dir = "up"
            end
        end
        
        if movex ~= 0 then
            if self.last_collided_x == true and self.last_collided_y == false then
                if movey < 0 then
                    dir = "up"
                elseif movey > 0 then
                    dir = "down"
                end
            end
        end

        if movey ~= 0 then
            if self.last_collided_x == false and self.last_collided_y == true then
                if movex < 0 then
                    dir = "left"
                elseif movex > 0 then
                    dir = "right"
                end
            end
        end
        
        if self.dancing["facing"] == true then
            if self.last_collided_y == true then
                dir = "down"
            else
                dir = "up"
            end
        end
        if self.dancing["buttons"] == true then
            if self.last_collided_x == true then
                dir = "down"
            end
        end
        
        if self.event_collide then
            dir = self:getFacing()
        end

        self:setFacing(dir)
    end
    
    return moved
end

return UnderPlayer