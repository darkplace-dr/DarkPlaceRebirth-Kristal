---@class Player : Player
local Player, super = Utils.hookScript(Player)

function Player:init(chara, x, y)
    super.init(self, chara, x, y)

    self.siner = 0

    self.invincible_colors = false
    self.inv_timer = 0
    self.old_song = ""
    self.so_gamer = Assets.getShader("so_gamer")

    self.base_speed_multiplier = 1

    if DP.run_timer_hold then
        self.run_timer = DP.run_timer_hold
    end

    self.run_toque_timer = 0
    if DP.run_toque_timer_hold then
        self.run_toque_timer = DP.run_toque_timer_hold
    end

    ---@type love.Source?
    self.toque_collide_sound = nil
end

function Player:getBaseWalkSpeed()
    -- apparently this never worked even before the player speed refactor
    --[[local override = self.actor.walk_speed_override
    if override ~= nil then return override end]]

    return super.getBaseWalkSpeed(self) * (self.base_speed_multiplier == nil and 1 or self.base_speed_multiplier)
end

function Player:getCurrentSpeed(running)
    local speed = super.getCurrentSpeed(self, running)
    --local base_speed = super.getBaseWalkSpeed(self)

    -- Holding run with the Pizza Toque equipped (or if the file name is "PEPPINO")
    -- will cause a gradual increase in speed.
    if DP:isTauntingAvaliable()
        and (self.world.map.id ~= "everhall" and self.world.map.id ~= "everhall_entry") then
        if self.run_timer > 60 then
            self.run_toque_timer = self.run_toque_timer + DT
            speed = speed + self.run_toque_timer
        else
            self.run_toque_timer = 0
            --[[
            if speed > base_speed then
                speed = base_speed
            end
            ]]
        end
    end

    return speed
end

function Player:getDebugInfo()
    local info = super.getDebugInfo(self)

    table.insert(info, string.format("Toque timer: %f", self.run_toque_timer))

    return info
end

function Player:isMovementEnabled()
    return not DP.taunt_lock_movement
        and super.isMovementEnabled(self)
end

function Player:handleMovement()
    super.handleMovement(self)
    assert(not self.disable_running, "What the hell is disable_running what is wrong with you why can't you just use force_walk why why why why")
    DP.run_timer_hold = self.run_timer
    DP.run_toque_timer_hold = self.run_toque_timer
end

function Player:update()
    super.update(self)
    if DP:isTauntingAvaliable() and (self.last_collided_x or self.last_collided_y) and self.run_toque_timer >= 6 then
        self:shake(4, 0)
        if self.toque_collide_sound then self.toque_collide_sound:stop() end
        self.toque_collide_sound = Assets.playSound("wing")
    end

    if self.invincible_colors then
        self:starman()
    end
end

function Player:starman()
    if Kristal.Config["simplifyVFX"] then
        self.siner = self.siner + DT * 40
        self.inv_timer = self.inv_timer - DT
        self:setColor(Utils.hsvToRgb(((self.siner * 8) % 255)/255, 255/255, 255/255))
        if (self.inv_timer + DT) % 0.125 < self.inv_timer % 0.125 then
            local afterimage = Sprite(self.sprite:getTexture(), self.x - self.sprite:getOffset()[1], self.y - self.sprite:getOffset()[2])
            afterimage:setScale(2, 2)
            afterimage:setOrigin(0.5, 1)
            afterimage:setColor(self.color)
            Game.world:spawnObject(afterimage)
            Game.world.stage.timer:tween(0.5, afterimage, {alpha = 0}, 'linear', function()
                afterimage:remove()
            end)
        end
        if self.inv_timer <= 0 and self.invincible_colors then
            self.invincible_colors = false
            Game.world.music:play(self.old_song or "none")
            self.old_song = nil
            self:setColor(1, 1, 1, 1)
            self:removeFX("Power Star")
        end
    else
        self.siner = self.siner + DT * 40
        self.inv_timer = self.inv_timer - DT

        if not self.shader_applied then
            self:addFX(ShaderFX(self.so_gamer, {
                ["iTime"] = function () return love.timer.getTime() end,
                ["iResolution"] = { love.graphics.getWidth(), love.graphics.getHeight() }
            }), "Power Star")
            self.shader_applied = true
        end

        if (self.inv_timer + DT) % 0.125 < self.inv_timer % 0.125 then
            local afterimage = Sprite(self.sprite:getTexture(), self.x - self.sprite:getOffset()[1], self.y - self.sprite:getOffset()[2])
            afterimage:setScale(2, 2)
            afterimage:setOrigin(0.5, 1)
            -- Apply the shader effect to the afterimage

            local hey_yall = love.timer.getTime()
            afterimage:addFX(ShaderFX(self.so_gamer, {
                ["iTime"] = function () return hey_yall end,
                ["iResolution"] = { love.graphics.getWidth(), love.graphics.getHeight() }
            }))
            Game.world:spawnObject(afterimage)
            Game.world.stage.timer:tween(0.5, afterimage, {alpha = 0}, 'linear', function()
                afterimage:remove()
            end)
        end

        if self.inv_timer <= 0 and self.invincible_colors then
            self.invincible_colors = false
            self:setColor(1, 1, 1, 1)
            self:removeFX("Power Star")
            self.shader_applied = false
            Game.world.music:play(self.old_song)
        end
    end
end

return Player
