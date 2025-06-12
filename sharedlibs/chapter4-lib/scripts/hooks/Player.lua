---@class Player : Player
---@field world World
local Player, super = Utils.hookScript(Player)

function Player:init(chara, x, y)
    super.init(self, chara, x, y)
    self.state_manager:addState("CLIMB", {enter = self.beginClimb, leave = self.endClimb, update = self.updateClimb})
    ---@type "left"|"right"|"up"|"down"?
    self.last_climb_direction = nil
    self.climb_delay = 0
    self.jumpchargesfx = Assets.newSound("chargeshot_charge")
    self.jumpchargesfx:setLooping(true)
    self.jumpchargesfx:setVolume(0.3)
    self.jumpchargecon = 0
    self.jumpchargetimer = 0
    self.charge_times = {
        10,
        22,
    }
    self.draw_reticle = true
    self.onrotatingtower = false
    self.climb_speedboost = -1
end

function Player:beginClimb(last_state)
    self:setSprite("climb/climb")
    self.climb_speedboost = -1
    self.world.can_open_menu = false
end

function Player:setActor(actor)
    super.setActor(self, actor)
    local size = 34
    self.climb_collider = Hitbox(Game.world, (self.width/2) - (size/2), (self.height/2) - (size/2) + 8, (size), (size))
end

function Player:draw()
    -- Draw the player
    super.draw(self)

    if DEBUG_RENDER then
        self.climb_collider:drawFor(self, 1, 1, 0)
    end

    if self.state == "CLIMB" and not self.onrotatingtower then
        self:drawClimbReticle()
    end
end

function Player:endClimb(next_state)
    self:resetSprite()
    self.world.can_open_menu = true
    self.physics.move_target = nil
end

function Player:processClimbInputs()
    if self.climb_delay > 0 then
        self.climb_delay = Utils.approach(self.climb_delay, 0, DT)
        if self.climb_delay <= 0 then
            if self.climb_ready_callback then
                self:climb_ready_callback()
                self.climb_ready_callback = nil
            end
            self.sprite:setFrame(Utils.clampWrap(self.sprite.frame + 1, 1, #self.sprite.frames))

            if self.sprite.sprite_options[2] ~= "climb/climb" then
                self:setSprite("climb/climb")
                self.sprite:setFrame(1)
            end
        end
        return
    end
    local dist
    if self.jumpchargecon >= 1 then
        if Input.released("confirm") then
            self:doClimbJump(self.facing, self.jumpchargeamount)
        else
            if Input.down("left") then
                self:setFacing("left")
            elseif Input.down("right") then
                self:setFacing("right")
            elseif Input.down("up") then
                self:setFacing("up")
            elseif Input.down("down") then
                self:setFacing("down")
            end
        end
        return
    else
        if Input.down("confirm") then
            self.jumpchargecon = 1
            return
        end
    end
    if Input.down("left") then
        self:doClimbJump("left", dist)
    elseif Input.down("right") then
        self:doClimbJump("right", dist)
    elseif Input.down("up") then
        self:doClimbJump("up", dist)
    elseif Input.down("down") then
        self:doClimbJump("down", dist)
    end
end

function Player:processJumpCharge()
    if (self.jumpchargecon == 1) then
        -- climbmomentum = 0;
        -- x = remx;
        -- y = remy;
        -- jumpchargesfx = snd_loop(snd_chargeshot_charge);
        self.jumpchargesfx:play()
        self.jumpchargesfx:setPitch(0.4)
        -- snd_volume(jumpchargesfx, 0.3, 0);
        self.jumpchargetimer = 0;
        self.jumpchargeamount = 1;
        self.jumpchargecon = 2;
        self:setSprite("climb/charge/up")
        -- sprite_index = spr_kris_climb_new_charge;
        -- image_index = 0;
    end

    if (self.jumpchargecon == 2) then
        local docharge = 0

        if (Input.down("confirm") or self.jumpchargetimer < 3) then
            docharge = 1;
        end

        if (Input.pressed("confirm")) then
            docharge = 2;
        end

        if (docharge == 1) then
            if (self.facing == "up" or self.facing == "down") then
                self:setSprite("climb/charge/up");
            elseif (self.facing == "right") then
                self:setSprite("climb/charge/right");
            else
                self:setSprite("climb/charge/left");
            end

            self.jumpchargetimer = self.jumpchargetimer + DTMULT;

            for i = 1, #self.charge_times-1 do
                if (self.jumpchargetimer >= self.charge_times[i]) then
                    self.sprite:setFrame(Utils.clamp(i+1, 1, #self.sprite.frames))
                    self.jumpchargesfx:setPitch(0.5 + (i-1)/10)
                    self.jumpchargeamount = i+1;
                    self.color = Utils.lerp(COLORS.white, COLORS.teal, 0.2 + (math.floor(math.sin(self.jumpchargetimer / 2)) * 0.2));
                end
            end


            if (self.jumpchargetimer >= (self.charge_times[#self.charge_times] or math.huge)) then
                self.sprite:setFrame(Utils.clamp(#self.charge_times+1, 1, #self.sprite.frames))
                self.jumpchargeamount = (#self.charge_times+1);
                self.jumpchargesfx:setPitch(0.5 + (#self.charge_times)/10)
                self.color = Utils.lerp(COLORS.white, COLORS.teal, 0.4 + (math.floor(math.sin(self.jumpchargetimer)) * 0.4));

                if ((self.jumpchargetimer % 8) == 0) then
                    self.draw_reticle = false
                    local afterimage = AfterImage(self, 0.3, ((1 / (0.2)) / 30 * 0.3));
                    self.draw_reticle = true
                    afterimage.alpha = 0.3;
                    afterimage.graphics.grow = 0.05
                    afterimage.physics.speed_y = 1
                    afterimage:setParent(self)

                    -- TODO: ahaHAHHAHAHAHHAAHAHA
                    -- if (i_ex(obj_rotating_tower_controller_new) && i_ex(obj_climb_kris)) then
                    --     afterimage.x = obj_rotating_tower_controller_new.tower_x;
                    --     afterimage.depth = obj_rotating_tower_controller_new.depth - 4;
                    -- end
                end
            end
        end

        if (docharge == 0) then
            self.jumpchargecon = 0;
            self.climb_jumping = 1;
            self.climbcon = 1;
            self.color = COLORS.white
            self.jumpchargesfx:stop()
            self.climb_speedboost = 0
        end

        if (docharge == 2) then
            -- snd_play(182, 0.7, 0.4);
            -- snd_play(181, 0.7, 0.4);
            -- snd_play(401, 0.2, 1.8);
            -- button2buffer = 10;
            -- jumpchargecon = 0;
            -- jumpchargetimer = 0;
            -- neutralcon = 1;
            self.color = COLORS.white;
            -- snd_stop(jumpchargesfx);
        end
    end
end

---@return boolean allowed
---@return Object? obj The object, if any, responsible for this outcome.
function Player:canClimb(dx, dy)
    Object.startCache()
    local climbarea
    local trigger
    for _, event in ipairs(self.world.stage:getObjects(Event)) do
        ---@cast event Event.climbarea|Event.climbentry
        -- TODO: Find out where these numbers come from, because it sure isn't the actor
        local x,y = -17, -37
        x,y = x + self.x,y + self.y
        x,y = x + (dx*40),y + (dy*40)
        if self.onrotatingtower then
            x = Utils.clampWrap(x, 0, self.world.width)
        end
        self.climb_collider.parent = self.parent
        self.climb_collider.x, self.climb_collider.y = x, y
        if (event.preClimbEnter or event.climbable) and event:collidesWith(self.climb_collider) then
            if event.climbable then
                climbarea = event
            end
            if event.preClimbEnter then
                trigger = event
            end
        end
    end
    Object.endCache()
    if climbarea then
        return true, climbarea
    end
    return NOCLIP, trigger
end

---@param direction "up"|"down"|"left"|"right"
---@param distance integer?
function Player:doClimbJump(direction, distance)
    direction = direction or self.facing
    self:setFacing(direction)

    local charged = (distance ~= nil)
    distance = distance or 1
    if direction == "left" or direction == "right" then
        self.last_x_climb = direction
    end
    local dx, dy = unpack(({
        up = {0, -1},
        down = {0, 1},
        left = {-1, 0},
        right = {1, 0},
    })[direction])
    -- Logic dictates that duration calc goes in the loop. Nope!
    local duration = (8/30)
    if self.climb_speedboost > 4 then
        duration = (4/30)
    elseif self.climb_speedboost > 0 then
        duration = ((8-self.climb_speedboost)/30)
    end
    self.climb_speedboost = self.climb_speedboost - 1
    if charged then
        duration = (3/30) * distance
    end


    Object.startCache()
    local found_obj_dist
    for dist = distance, 1, -1 do
        local allowed, obj = self:canClimb(dx*dist, dy*dist)
        if allowed then
            Assets.playSound("wing", 0.6, 1.1 + (love.math.random()*0.1))
            if distance > 1 then
                if self.facing == "left" then
                    self:setSprite("climb/jump_left")
                elseif self.facing == "right" then
                    self:setSprite("climb/jump_right")
                else
                    self:setSprite("climb/jump_up")
                end
                self.sprite:play(0.1, true)
            else
                self.sprite:setFrame(Utils.clampWrap(Utils.floor(self.sprite.frame + 1, 2), 1, #self.sprite.frames))
            end
            self:slideTo(self.x + (dx*40*dist), self.y + (dy*40*dist), duration, "linear", function ()
                if charged then
                    if (self.jumpchargeamount == 3) then
                        self.climb_speedboost = 18
                    elseif (self.jumpchargeamount == 2) then
                        self.climb_speedboost = 6
                    elseif (self.jumpchargeamount == 1) then
                        self.climb_speedboost = 3
                    end
                end
                self.climb_delay = 2/30
                if distance ~= 1 then
                    self.climb_delay = 2/30
                end
                if self.sprite.sprite_options[2] ~= "climb/climb" then
                    if self.facing == "left" then
                        self:setSprite("climb/land_left")
                    elseif self.facing == "right" then
                        self:setSprite("climb/land_right")
                    else
                        self:setSprite("climb/jump_up")
                    end
                end
                if self.climb_callback then
                    self:climb_callback()
                    self.climb_callback = nil
                end
                if obj and obj.onClimbEnter then
                    obj:onClimbEnter(self)
                    self.climb_speedboost = -1
                end
            end)
        elseif dist == 1 and not obj then
            Assets.playSound("bump")
            self.climb_speedboost = -1
            -- TODO: use the correct sprite
            if self.last_x_climb == "left" then
                self:setSprite("climb/slip_left")
            else
                self:setSprite("climb/slip_right")
            end
            -- self.sprite:setFrame(2)
            self.climb_delay = 4/30
        end
        if dist <= 1 and obj and obj.preClimbEnter then
            obj:preClimbEnter(self)
        end
        if allowed then
            break
        end
    end
    Object.endCache()
end

function Player:drawClimbReticle()
    -- TODO: Something better
    if not self.draw_reticle then
        return
    end
    local tempalpha = 1;

    love.graphics.push()
    love.graphics.translate(self.width/2, self.height - 10)

    -- I /think/ this is what global.inv is?
    if (self.world.soul.inv_timer > 0) then
        tempalpha = 0.5;
    end

    local found = 0;
    local _alph;

    if (self.jumpchargecon ~= 0) then
        local count = 1;

        for i = 1, #self.charge_times do
            if self.jumpchargetimer > self.charge_times[i] then
                count = i + 1
            end
        end

        local px = 0;
        local py = 0;

        for i = 1, count do
            -- with (instance_place(px, py, obj_climbstarter))
            -- {
            --     if ((other.dir == 2 && e_up) || (other.dir == 0 && e_down) || (other.dir == 3 && e_left) || (other.dir == 1 && e_right))
            --     {
            --         found = i;
            --         break;
            --     }
            -- }

            if (self.facing == "down") then
                py = 0+i;
            end

            if (self.facing == "right") then
                px = 0+i;
            end

            if (self.facing == "up") then
                py = 0-i;
            end

            if (self.facing == "left") then
                px = 0-i;
            end
            local s,o = self:canClimb(px, py)
            if s or o then
                found = i
            end
        end

        _alph = Utils.clamp(self.jumpchargetimer / 14, 0.1, 0.8);
        local angle = 0;
        local xoff = 0;
        local yoff = 0;

        if (self.facing == "down") then
            angle = 0;
            xoff = -22;
            yoff = 18;
        end

        if (self.facing == "right") then
            angle = 90;
            xoff = 18;
            yoff = 22;
        end

        if (self.facing == "up") then
            angle = 180;
            xoff = 22;
            yoff = -18;
        end

        if (self.facing == "left") then
            angle = 270;
            xoff = -18;
            yoff = -22;
        end

        -- TODO: Put these colors in the PALETTE
        local col = {200/255, 200/255, 200/255};

        if (found ~= 0) then
            col = {255/255, 200/255, 132/255};
        end
        --[[
            draw_sprite_general(
                --sprite,
                Assets.getTexture("ui/climb/hint"),
                --subimg,
                floor(current_time * 0.5) % 4,
                --left, top,
                0, 0,
                --width, height,
                22, (self.jumpchargetimer / self.charge_times[2]) * 62,
                --x, y,
                x + xoff, y + yoff,
                --xscale, yscale,
                2, 2,
                --rot,
                angle,
                --c1, c2, c3, c4,
                col, col, col, col,
                --alpha
                0.85
            );
        ]]
        -- local quad = Assets.getQuad(0, 0, 22, math.floor(Utils.clamp(self.jumpchargetimer / self.charge_times[2], 0, 1) * 62), 22, 62)
        Draw.setColor(col)
        local frame = Utils.clampWrap(math.floor(Kristal.getTime() * 15), 1,4)
        -- Draw.draw(Assets.getFrames("ui/climb/hint")[frame], quad, xoff/2, yoff/2, -math.rad(angle))
        love.graphics.push()
        love.graphics.translate(xoff/2, yoff/2)
        love.graphics.rotate(-math.rad(angle))
        local w = (self.jumpchargetimer / (self.charge_times[#self.charge_times] or 10)) * (#self.charge_times+1)
        for i = 0, #self.charge_times do
            local id, h = "ui/climb/hint_mid", 20
            if i == 0 then
                id = "ui/climb/hint_start"
                h = 21
            elseif i == #self.charge_times then
                id = "ui/climb/hint_end"
                h = 21
            end
            local quad = Assets.getQuad(0, 0, 22, math.floor(Utils.clamp(w - i, 0, 1) * h), 22, h)
            Draw.draw(Assets.getFrames(id)[frame], quad)
            love.graphics.translate(0, h)

        end
        love.graphics.pop()
    end

    if (DEBUG_RENDER) then
        local count = 0;
        local space = 10;
        local border = 8;
    end

    local drawreticle = true;

    if (drawreticle and self.jumpchargecon ~= 0 and found ~= 0) then
        local px = 0 - 12;
        local py = 0 - 12;

        if (self.facing == "down") then
            py = py + (20 * found);
        end

        if (self.facing == "right") then
            px = px + (20 * found);
        end

        if (self.facing == "up") then
            py = px - (20 * found);
        end

        if (self.facing == "left") then
            px = px - (20 * found);
        end

        Draw.setColor(Utils.lerp(COLORS.yellow, COLORS.white, 0.4 + (math.sin(self.jumpchargetimer / 3) * 0.4)));
        Draw.draw(Assets.getTexture("ui/climb/reticle"), px, py)
    end
    love.graphics.pop()
end

function Player:updateClimb()
    if self:isMovementEnabled() and not self.physics.move_target then
        self:processClimbInputs()
        if self.jumpchargecon > 0 then
            self:processJumpCharge()
        else
            self.jumpchargesfx:stop()
        end
        if not (Input.down("left") or Input.down("up") or Input.down("right") or Input.down("down")) then
            self.climb_speedboost = -1
        end
    end
    -- Placeholder, obviously.
    local o_noclip = self.noclip
    self.noclip = true
    -- self:updateWalk()
    self.noclip = o_noclip
    if self.onrotatingtower and not self.physics.move_target then
        -- TODO: Find out why I have to put 1 here and not 0
        self.x = Utils.clampWrap(self.x, 1, self.world.width)
    end

    Object.startCache()
    Object.endCache()
end

function Player:onRemove(parent)
    super.onRemove(self, parent)
    self.jumpchargesfx:stop()
end

function Player:onAdd(parent)
    super.onAdd(self, parent)
    if not self.world then return end
    if not self.world.map.data then return end
    if not self.world.map.data.properties then return end
    if self.world.map.data.properties.playerstate then
        self:setState(self.world.map.data.properties.playerstate)
        if self.world.map.cyltower then
            self.onrotatingtower = true
        end
    end
end

return Player