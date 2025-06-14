---@class Player : Player
local Player, super = Utils.hookScript(Player)

function Player:init(chara, x, y)
    super.init(self, chara, x, y)

    self.siner = 0

    self.invincible_colors = false
    self.inv_timer = 0
    self.old_song = ""
    self.so_gamer = Assets.getShader("so_gamer")

    if DP.run_timer_hold then
        self.run_timer = DP.run_timer_hold
    end

    if DP.walk_speed_hold then
        self.walk_speed = DP.walk_speed_hold
    end
end

function Player:isMovementEnabled()
    return not DP.taunt_lock_movement
        and super.isMovementEnabled(self)
end

function Player:handleMovement()
    -- Holding run with the Pizza Toque equipped (or if the file name is "PEPPINO")
    -- will cause a gradual increase in speed.
    if DP:isTauntingAvaliable()
        and (self.world.map.id ~= "everhall" and self.world.map.id ~= "everhall_entry") then
        if self.run_timer > 60 then
            self.walk_speed = self.walk_speed + DT
        elseif self.walk_speed > 4 then
            self.walk_speed = 4
        end
    end

    super.handleMovement(self)
    assert(not self.disable_running, "What the hell is disable_running what is wrong with you why can't you just use force_walk why why why why")
    DP.run_timer_hold = self.run_timer
end

function Player:update()
    super.update(self)
    if DP:isTauntingAvaliable() then
        if self.last_collided_x or self.last_collided_y then
            if self.walk_speed >= 10 then
                self.world.player:shake(4, 0)
                Assets.playSound("wing")
            end
        end
    end

    if self.invincible_colors then
        self:starman()
    end

    DP.walk_speed_hold = self.walk_speed
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