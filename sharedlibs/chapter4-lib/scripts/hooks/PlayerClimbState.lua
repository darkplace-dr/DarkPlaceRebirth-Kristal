---@class PlayerClimbState : PlayerClimbState
---@field world World
local PlayerClimbState, super = HookSystem.hookScript(PlayerClimbState)

function PlayerClimbState:updateClimbCamera()
    local camera = Game.world.camera
    if camera == nil then
        return
    end

    if self.player.onrotatingtower then
        local camera_lerp_speed = 0.16

        local camera_min_x, camera_min_y = camera:getMinPosition()
        local camera_max_x, camera_max_y = camera:getMaxPosition()

        local camera_x = MathUtils.clamp(Game.world.map.cyltower.krisx, camera_min_x, camera_max_x)
        local camera_y = MathUtils.clamp(Game.world.map.cyltower.krisy + self.camera_y_offset, camera_min_y, camera_max_y)

        local t = 1 - (1 - camera_lerp_speed) ^ DTMULT
        local ideal_y =  MathUtils.roundToMultiple(MathUtils.lerp(camera.y, camera_y, camera_lerp_speed * DTMULT), 2)

        camera:setPosition(camera_x, ideal_y)
    else
        super.updateClimbCamera(self)
    end
end

function PlayerClimbState:getOverlappingObjects(x, y, object)
    x = x or self.player.x
    y = y or self.player.y

    local old_x = self.player.x
    local old_y = self.player.y

    if self.player.falseloop then
        x = MathUtils.wrap(x, self.player.falseloopx[1], self.player.falseloopx[2])
    end

    self.player.x = x
    self.player.y = y

    local objects = {}

    Object.startCache()
    for _, obj in ipairs(Game.world.children) do
        if obj:includes(object) then
            if self:isOverlappingInstance(obj) then
                table.insert(objects, obj)
            end
        end
    end

    Object.endCache()

    self.player.x = old_x
    self.player.y = old_y
    return objects
end

function PlayerClimbState:drawReticleHint()

    if not self.player.onrotatingtower then
        return super.drawReticleHint(self)
    end
    if not self._draw_reticle then
        return 0, 0
    end

    local found = 0
    local alpha = 0

    if self.charge_state > 0 then
        local count = 1
        if self.charge_timer >= self.charge_time_1 then
            count = 2
        end
        if self.charge_timer >= self.charge_time_2 then
            count = 3
        end

                
        local ix = self.player.lastx
        local iy = self.player.lasty

        local px = ix
        local py = iy

        for i = 1, count do
            local found_exit, exit = self:isOverlappingObject(ClimbExit, px, py)
            if found_exit and exit:canExit() then
                ---@cast exit ClimbExit
                if exit:getExitDirection() == self.direction then
                    found = i
                    break
                end
            end

            if self.direction == "down" then
                py = iy + (40 * i)
            elseif self.direction == "right" then
                px = ix + (40 * i)
            elseif self.direction == "up" then
                py = iy - (40 * i)
            elseif self.direction == "left" then
                px = ix - (40 * i)
            end
            if self:isOverlappingClimbable(px, py, ClimbArea) or NOCLIP then
                found = i
            end
        end

        alpha = MathUtils.clamp(self.charge_timer / 14, 0.1, 0.8)
        local angle = 0
        local xoff = 0
        local yoff = 0
        --I couldn't figure this one out properly... sorry...
        if self.direction == "down" then
            angle = 0
            xoff = -22
            yoff = 25
        elseif self.direction == "right" then
            angle = 90
            xoff = 8
            yoff = 27
        elseif self.direction == "up" then
            angle = 180
            xoff = 22
            yoff = -15
        elseif self.direction == "left" then
            angle = 270
            xoff = -8
            yoff = -17
        end

        local col = { 200 / 255, 200 / 255, 200 / 255, 0.85 }
        if found > 0 then
            col = { 1, 200 / 255, 132 / 255, 0.85 };
        end

        local origin_x = 11

        -- The offset of 1 is (most likely) due to GameMaker rounding being different from ours.
        local origin_y = -10 + 1


        local frames = Assets.getFrames("player/climb_reticle_hint")

        -- This index is very weird in DR and ends up being kinda broken at higher FPSes.
        -- So, quantize the time to 30 FPS intervals
        local target_fps = 1 / 30
        local target_seconds = math.floor(Kristal.getTime() / target_fps) * target_fps
        local index = (math.floor(target_seconds * 1000 / 2) % #frames) + 1

        Draw.setColor(col)
        Draw.drawPart(frames[index], (self.player.width / 2) + xoff, (self.player.height / 2) + yoff, 0, 0, 22, math.min(self.charge_timer / self.charge_time_2, 1) * 62, math.rad(-angle), 1, 0.98, -origin_x, -origin_y)
        Draw.setColor(COLORS.white)
    end

    return found, alpha
end

function PlayerClimbState:drawReticle(found, alpha)
    if not self._draw_reticle then
        return
    end

    if not Game.world.map.cyltower then
        return super.drawReticle(self, found, alpha)
    end

    local cyltower = Game.world.map.cyltower

    love.graphics.push()
	love.graphics.origin()
    love.graphics.translate(-(Game.world.camera.x - SCREEN_WIDTH/2), -(Game.world.camera.y - SCREEN_HEIGHT/2))

    if self.charge_state > 0 then
        if found > 0 then
            local px = self.player.lastx + (self.player.width / 2) - 20
            local py = self.player.lasty + (self.player.height / 2) - 20

            if self.direction == "down" then
                py = py + 40 * found
            elseif self.direction == "right" then
                px = px + 40 * found
            elseif self.direction == "up" then
                py = py - 40 * found
            elseif self.direction == "left" then
                px = px - 40 * found
            end

            local col = ColorUtils.mergeColor(COLORS.yellow, COLORS.white, 0.4 + (math.sin(self.charge_timer / 3) * 0.4))
            col[4] = col[4] * alpha

            local tilex = math.floor(px / cyltower.tile_width_fine) + 1
            if tilex >= cyltower.horizontaltilecount then
                tilex = tilex - cyltower.horizontaltilecount
            end
            if tilex <= 0 then
                tilex = tilex + cyltower.horizontaltilecount
            end
            local tile = cyltower.tile_data[cyltower.tm_tileset[1]][tilex]

            Draw.setColor(col)
            if tile.vis == 1 then
                Draw.draw(Assets.getTexture("player/climb_reticle"), cyltower.tower_x + tile.x, py, 0, ((tile.xscale * 2) / cyltower.tile_width_fine), 2, 2, 2)
            end
        end
    end
    love.graphics.pop()
end

function PlayerClimbState:chargeClimbCharge()
    if self.direction == "up" or self.direction == "down" then
        self.player.sprite:setSprite("climb/charge")
    elseif self.direction == "right" then
        self.player.sprite:setSprite("climb/charge_right")
    elseif self.direction == "left" then
        self.player.sprite:setSprite("climb/charge_left")
    end

    self.charge_timer = self.charge_timer + DTMULT
    self.charge_afterimage_timer = self.charge_afterimage_timer + DTMULT

    if self.charge_timer >= self.charge_time_1 then
        self.player.sprite:setFrame(2)
        self.charge_sound:setPitch(0.5)
        self.charge_amount = 2
        self.player:setColor(ColorUtils.mergeColor(COLORS.white, COLORS.teal, 0.2 + (math.floor(math.sin(self.charge_timer / 2)) * 0.2)))
    end

    if self.charge_timer >= self.charge_time_2 then
        self.player.sprite:setFrame(3)
        self.charge_sound:setPitch(0.7)
        self.charge_amount = 3
        self.player:setColor(ColorUtils.mergeColor(COLORS.white, COLORS.teal, 0.4 + (math.floor(math.sin(self.charge_timer)) * 0.4)))

        if self.charge_afterimage_timer >= 8 then
            local afterimage = nil
            if self.player.onrotatingtower then
                afterimage = self.player.parent:addChild(Sprite(self.player.sprite:getTexture(), Game.world.map.cyltower.krisx, Game.world.map.cyltower.krisy))
            else
                afterimage = self.player.parent:addChild(Sprite(self.player.sprite:getTexture(), self.player.x, self.player.y))
            end
            afterimage.alpha = 0.3
            afterimage:setScale(2)
            afterimage:fadeOutSpeedAndRemove(0.1)
            afterimage:setOrigin(0.5)
            afterimage.layer = self.player.layer + 20
            local scale_x, scale_y = self.player:getScale()
            afterimage.graphics.grow_x = 0.2 / scale_x
            afterimage.graphics.grow_y = 0.2 / scale_y
        end
    end

    if self.charge_afterimage_timer >= 8 then
        self.charge_afterimage_timer = self.charge_afterimage_timer - 8
    end
end

function PlayerClimbState:updateClimbMove()
    if self.climbing_x_dir > 0 then
        self.bump_sprite = "climb/slip_right"
    elseif self.climbing_x_dir < 0 then
        self.bump_sprite = "climb/slip_left"
    end

    self.recently_bumped = nil
    self.previous_bump = nil

    if self.timer == 0 then
        local dust_amount = self.jumping and 5 or 1

        for i = 1, dust_amount do
            local dust = Sprite("effects/climb_dust_small")
            dust:setOrigin(0.5, 0)
            if self.player.onrotatingtower then
                dust:setPosition(Game.world.map.cyltower.krisx, Game.world.map.cyltower.krisy)
            else
                dust:setPosition(self.player.x, self.player.y)
            end
            dust.layer = self.player.layer - 0.01

            if self.jumping then
                dust.x = dust.x + MathUtils.random(-10, 10)
                dust.y = dust.y + MathUtils.random(-10, 10)
            elseif self.climbing_y_dir < 0 then
                dust.x = (dust.x - 10) + (10 * (self.climb_frame - 1))
            elseif self.climbing_y_dir > 0 then
                dust.x = (dust.x - 15) + (15 * (self.climb_frame - 1))
            else
                dust.y = dust.y + 10
            end

            dust:setScale(2, 2)
            dust:play(1 / 15, false, function() dust:remove() end)
            dust.physics.speed_y = -1
            dust.debug_select = false
            self.player.world:addChild(dust)
        end
    end

    self.player.sprite.y = 0

    local new_x
    local new_y
    local climbrate

    if not self.jumping then
        if self.speed < 1 then
            self.speed = 1
        end
        self.timer = self.timer + (self.speed + self.momentum) * DTMULT
        climbrate = 10

        if self.timer >= climbrate then
            self.timer = climbrate
        end

        new_x = Utils.ease(self.last_x, self.last_x + self.climbing_x_dir, self.timer / climbrate, "inOutQuad")
        new_y = Utils.ease(self.last_y, self.last_y + self.climbing_y_dir, self.timer / climbrate, "inOutQuad")
        self.player.sprite:setFrame(self.climb_frame)

        if math.abs(new_x - self.last_x) > 3 or math.abs(new_y - self.last_y) > 3 then
            self.player.sprite:setFrame(self.climb_frame + 1)
        end
    else
        self.timer = self.timer + DTMULT
        climbrate = 6 + (self.charge_amount * 2)
        local clipamount = 4

        if (self.charge_amount >= 2) then
            clipamount = 2
        end

        if self.timer >= climbrate then
            self.timer = climbrate
        end

        if self.timer >= climbrate - clipamount then
            self.timer = climbrate
        end

        new_x = Utils.ease(self.last_x, self.last_x + self.climbing_x_dir, self.timer / climbrate, "outSine")
        new_y = Utils.ease(self.last_y, self.last_y + self.climbing_y_dir, self.timer / climbrate, "outSine")
        self.player.sprite.y = (-math.sin((self.timer / climbrate) * math.pi) * (2 * (self.charge_amount - 1))) / 2

        if self.direction == "up" or self.direction == "down" then
            self.player.sprite:setSprite("climb/jump_up")
            self.player.sprite:setFrame((self.timer / 2) + 1)
        elseif self.direction == "right" then
            if (self.timer / climbrate) > 0.5 then
                self.player.sprite:setSprite("climb/land_right")
            else
                self.player.sprite:setSprite("climb/slip_right")
                self.player.sprite:setFrame(1)
            end
        elseif (self.timer / climbrate) > 0.5 then
                self.player.sprite:setSprite("climb/land_left")
        else
            self.player.sprite:setSprite("climb/slip_left")
            self.player.sprite:setFrame(1)
        end

        if self.afterimage_timer >= 1 then
            local afterimage = nil
            if self.player.onrotatingtower then
                afterimage = self.player.parent:addChild(Sprite(self.player.sprite:getTexture(), Game.world.map.cyltower.krisx, Game.world.map.cyltower.krisy + self.player.sprite.y * 2))
            else
                afterimage = self.player.parent:addChild(Sprite(self.player.sprite:getTexture(), self.player.x, self.player.y + self.player.sprite.y * 2))
            end
            afterimage:setScale(2)
            afterimage:setOrigin(0.5)
            afterimage.alpha = 0.2
            afterimage.layer = self.player.layer - 0.01
            afterimage:fadeOutSpeedAndRemove(0.04)
            self.player.parent:addChild(afterimage)
        end

        local check_x = self.player.x - MathUtils.clamp(self.climbing_x_dir, -40, 40)
        local check_y = self.player.y - MathUtils.clamp(self.climbing_y_dir, -40, 40)

        local found_exit, exit = self:isOverlappingObject(ClimbExit, check_x, check_y)

        local use_exit = nil

        if found_exit and exit:canExit() then
            ---@cast exit ClimbExit

            local exit_dir = exit:getExitDirection()
            if self.climbing_y_dir > 0 and exit_dir == "down" then
                use_exit = exit
            elseif self.climbing_y_dir < 0 and exit_dir == "up" then
                use_exit = exit
            elseif self.climbing_x_dir > 0 and exit_dir == "right" then
                use_exit = exit
            elseif self.climbing_x_dir < 0 and exit_dir == "left" then
                use_exit = exit
            end
        end

        if use_exit ~= nil then
            self:queueExit({ obj = use_exit })
            return
        end
    end

    self.player.x = new_x
    self.player.y = new_y

    if self.timer >= climbrate then
        if self.jumping then
            self.momentum = self.charge_amount / 2
        end

        self.jumping = false
        self.state = 0
        self.charge_amount = 0
        self.player.x = self.last_x + self.climbing_x_dir
        self.player.y = self.last_y + self.climbing_y_dir
        self.neutral_state = 1
        self.check_move = true
    end
end

function PlayerClimbState:updateClimbGrab()
    self.grab_sound_timer = self.grab_sound_timer + DTMULT
    self.dust_timer = self.dust_timer + DTMULT

    if self.grab_sound_timer >= 1 then
        self.grab_sound_timer = self.grab_sound_timer - 1
        Assets.stopAndPlaySound("wing", 0.7, 0.6 + MathUtils.random(0.3))
    end

    if (self.dust_timer >= 2) then
        self.dust_timer = self.dust_timer - 2

        local dust = Sprite("effects/slide_dust")
        dust:play(1 / 15, false, function() dust:remove() end)
        dust:setOrigin(0.5, 0.5)
        dust:setScale(2, 2)
        if self.player.onrotatingtower then
            dust:setPosition(Game.world.map.cyltower.krisx, Game.world.map.cyltower.krisy)
        else
            dust:setPosition(self.player.x, self.player.y)
        end
        dust.layer = self.player.layer - 0.01
        dust.physics.speed_y = -3
        dust.physics.speed_x = MathUtils.random(-1, 1)
        dust.debug_select = false
        self.player.world:addChild(dust)
    end

    -- Cap climb speed to 7
    if (self.fall_speed > 7) then
        self.fall_speed = 7
    end

    self.fall_speed = self.fall_speed - DTMULT

    if self.fall_direction == "down" then
        self.player.y = self.player.y + math.ceil(self.fall_speed) * DTMULT
    elseif self.fall_direction == "right" then
        self.player.x = self.player.x + math.ceil(self.fall_speed) * DTMULT
    elseif self.fall_direction == "up" then
        self.player.y = self.player.y - math.ceil(self.fall_speed) * DTMULT
    elseif self.fall_direction == "left" then
        self.player.x = self.player.x - math.ceil(self.fall_speed) * DTMULT
    end

    if (self.fall_speed <= 0) then
        self.grab_timer = 0
        self.grab_state = 3
        self.grab_start_y = self.player.y
        self.grab_start_x = self.player.x
    end
end

return PlayerClimbState