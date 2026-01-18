---@diagnostic disable inject-field
local TrafficCar, super = Class(Event)

function TrafficCar:init(data)
    super.init(self, data)

    -- Sprites setup
    do
        self.path           = "world/events/traffic/"
        self.car_path       = "traffic_car"
        self.legs_path      = "traffic_car_legs"
    
        self.legs_sprite = Sprite(self.path..self.legs_path)
        self.legs_sprite.x_offset = 0
        self.legs_sprite.y_offset = 0
        self:addChild(self.legs_sprite)
        self.legs_sprite:setScale(2)
    
        self.car_sprite = Sprite(self.path..self.car_path)
        self.car_sprite.x_offset = 0
        self.car_sprite.y_offset = 0
        self:addChild(self.car_sprite)
        self.car_sprite:setScale(2)
    end

    -- Variables setup
    do
        -- Configurable Variables
        self.alwayswalking  = false
        self.group          = 0
        self.speed          = 18
        self.walking        = false
        self.walkdir        = "down"

        -- Internal Variables
        self._active        = true
        self.animsiner      = 0
        self.downframe      = 0
        self.downframetimer = 0
        self.endme          = false
        self.remspeed       = self.speed
        self.speedadjust    = false
        self.spintimer      = 0
        self.touchcon       = 0
        self.touchtimer     = 0
        self.turned         = 0
        self.walklerp       = 0
        self.walkx          = 0
        self.walky          = 0
        self.freshness = #TableUtils.filter(Game.world.children, function (v)
            return isClass(v) and v:includes(Registry.events["traffic_car"]) 
        end) - 1

        self.speedadjust_min = 10
        self.speedadjust_max = 24
        self.speedadjust_proximity = 200
        self.speedadjust_divisor = 16
    end

    self:setSize(self.car_sprite.width * 2, self.car_sprite.height * 2)
    self:setHitbox(7 * 2, 12 * 2, 25 * 2, 16 * 2)
    self.car_sprite.debug_select = false
    self.legs_sprite.debug_select = false

    self.solid = false

    Kristal.callEvent("onTrafficCarInit", self)
end

function TrafficCar:setDirection(direction)
    local old = self.walkdir
    self.walkdir = direction
    if direction == "down" then
        self.car_sprite:set(self.path..self.car_path)
        self.legs_sprite:setSprite(self.path..self.legs_path)
        self.legs_sprite:stop(false)
        self:setSize(self.car_sprite.width * 2, self.car_sprite.height * 2)
        self:setHitbox(7 * 2, 12 * 2, 25 * 2, 16 * 2)
	elseif direction == "up" then
        self.car_sprite:set(self.path..self.car_path.."_up")
        self.legs_sprite:setSprite(self.path..self.legs_path) -- Maybe add legs for cars going up later?
        self.legs_sprite:stop(false)
        self:setSize(self.car_sprite.width * 2, self.car_sprite.height * 2)
        self:setHitbox(7 * 2, 12 * 2, 25 * 2, 16 * 2)
    elseif direction == "right" or direction == "left" then
        self.car_sprite:set(self.path..self.car_path.."_side")
        self.legs_sprite:set(self.path..self.legs_path.."_side")
        self:setSize(self.car_sprite.width * 2, self.car_sprite.height * 2)
        self:setHitbox(10 * 2, 11 * 2, 34 * 2, 14 * 2)
    else
        if not Kristal.getLibConfig("city_traffic", "allowInvalidCarDirection") then
            error("Tried to set traffic_car to invalid direction '" .. tostring(direction) .. "'! Must be 'down', 'right', or 'left'.")
        end
    end

    Kristal.callEvent("onTrafficCarDirectionChange", self, old, direction)
end

function TrafficCar:update()
    super.update(self)
    if Kristal.callEvent("beforeTrafficCarUpdate", self) then
        return
    end

    local fsx, fsy = self:getFullScale()
    local destroy_check = {
        down    = (self.y >= Game.world.map.height * 40 + self.car_sprite.height * fsy),
        up      = (self.y <= (0 - (self.car_sprite.height * fsy))),
        right   = (self.x >= (Game.world.map.width * 40 + (self.car_sprite.width * fsy))),
        left    = (self.x <= (0 - (self.car_sprite.width * fsx))),
    }

    if destroy_check[self.walkdir] then
        self.endme = true
    end
    
    Object.startCache()
    for _, carkiller in ipairs(self.world:getEvents("car_killer")) do
        if self:collidesWith(carkiller) then
            if carkiller.explode_car then 
                self:explode(0, 0, false, {playsound = carkiller.quieter_explosion}) 
                if carkiller.quieter_explosion then
                    Assets.stopAndPlaySound("badexplosion", 0.4)
                end
            else 
                self.endme = true 
            end
            break
        end
    end
    Object.endCache()

    if not Game.world.cutscene and self.touchcon == 0 and self._active and not Game.world.menu and not Game.world.car_collision then
        if self.alwayswalking == true then
            self.walking = true
        end

        -- Cleaned up from the deltarune version so we check self.walking just the once
        local eff_speed = self.speed * DTMULT
        -- In DELTARUNE, this only applies to cars walking down - however, given car_turner was unimplemented 
        -- and the code implies `alwayswalking` was never going to be used with these directions, i've made this
        -- apply to all directions as this is the behaviour modders will probably expect from the car turner.
        if self.walking and not self.alwayswalking then
            eff_speed = eff_speed / 4
        end

        if (self.walkdir == "down") then
            self.y = self.y + eff_speed
        elseif (self.walkdir == "up") then
            self.y = self.y - eff_speed
        elseif (self.walkdir == "right") then
            self.x = self.x + eff_speed
        elseif (self.walkdir == "left") then
            self.x = self.x - eff_speed
        end
    end

    if self.touchcon == 1 then
        self.touchtimer = 0
        self.spintimer = 0
        self.touchcon = 2
        Assets.playSound("cardrive")
        Game.world.player.alpha = 0.5

        -- Fallback position finding (only used if traffic markers are not used or avoided somehow)
        -- Ideally this should never end up being used anyways so its very basic
        local x, y = 0, 0
        if Game.world.map:hasMarker("spawn") then
            x, y = Game.world.map:getMarker("spawn")
        end
        if Game.world.map:hasMarker("entry") then
            x, y = Game.world.map:getMarker("entry")
        end

        local marker = Game.world.player.last_traffic_marker
        if marker then
            x, y = marker:getRecallPosition()
        end

        Game.world.player:slideTo(x, y)
        Game.lock_movement = true
        if not Kristal.getLibConfig("city_traffic", "fixPlayerSpinning") then
            Game.world.player.sprite.active = false
        end

        for i, follower in ipairs(Game.world.followers) do
            if follower.actor.id == "noelle" and follower.noelle_traffic then
                follower.x = follower.noelle_traffic.x
                follower.y = follower.noelle_traffic.y
                follower:setSprite("shocked")
                follower.noelle_traffic:remove()
                follower.noelle_traffic = nil
                follower.visible = true
            end

            follower.alpha = follower.alpha >= 0.5 and 0.5 or follower.alpha

            local target_x = x
            if Game.world.player.x < x then
                follower:setFacing("left")
                target_x = x + 50*i
            else
                follower:setFacing("right")
                target_x = x - 50*i
            end
            follower:slideTo(target_x, y, 1, "linear", function ()
                local me = Game.world.followers[i]
                me:interpolateHistory()
                if me.actor.id == "noelle" then
                    me:resetSprite()
                end
            end)
        end
    end

    if self.touchcon == 2 then
        self.touchtimer = self.touchtimer + DTMULT
        self.spintimer = self.spintimer + DTMULT
        if (self.spintimer >= 4) then
            local tbl = {
                up = "left",
                left = "down",
                down = "right",
                right = "up",
            }
            if Kristal.getLibConfig("city_traffic", "fixPlayerSpinning") then
                Game.world.player:setFacing(tbl[Game.world.player.facing])
            end
            self.spintimer = 0
        end
        if self.touchtimer >= 30 then
            self.touchtimer = 0
            self.touchcon = 0
            Game.lock_movement = false
            Game.world.player.sprite.active = true
            Game.world.player.alpha = 1
            Game.world.player:setFacing("down")
            for _, follower in ipairs(Game.world.followers) do
                follower.alpha = follower.alpha == 0.5 and 1 or follower.alpha
            end

            Game.world.car_collision = false
        end
    end

    self.solid = not self._active

    if self.endme then
        self._active = false
        self.visible = false

        if self.touchcon == 0 then
            self:remove()
        end
    end

    Object.startCache()
    for _, turner in ipairs(Game.world:getEvents("car_turner")) do
        if self:collidesWith(turner) and turner.walkdir ~= self.walkdir then
            local car = Registry.createLegacyEvent("traffic_car", {x = self.x, y = self.y})
            car.car_path = self.car_path
            car.legs_path = self.legs_path
            car.speed = self.speed
            -- In DELTARUNE, the unimplemented turner would only turn cars to face right,
            -- this is still used as the default, but turner objects can now change it
            car.walkdir = self.walkdir
            car:setDirection(turner.walkdir or "right")
            car.remspeed = self.remspeed
            car.alwayswalking = self.alwayswalking
            car.group = self.group
            car.walking = self.walking
            if self.walking then
                car.walklerp = 1
            end
            car._active = self._active
            car.touchcon = self.touchcon
            car.touchtimer = self.touchtimer
            car.speedadjust = turner.speedadjust -- DELTARUNE sets to true, but this one is a bit funky so we'll default to false instead and make it a toggle on the turner
            if turner.speedadjust then
                car.speedadjust_min = turner.speedadjust_min
                car.speedadjust_max = turner.speedadjust_max
                car.speedadjust_proximity = turner.speedadjust_proximity
                car.speedadjust_divisor = turner.speedadjust_divisor
            end
            car.turned = 1
            Game.world:spawnObject(car, self.layer)

            self.endme = true
        end
    end
    Object.endCache()

    -- This one is related to car turning above, or at least i think it is
    -- This makes the car slow down while it's close to the player - normally gets enabled when the car turns.
    if self.speedadjust then
        local sx, sy = self:getPosition()
        local px, py = Game.world.player:getPosition()
        local chardist = MathUtils.dist(sx, sy, px, py)

        if chardist >= self.speedadjust_proximity then
            self.idealspeed = self.speedadjust_max
        else
            self.idealspeed = math.max((chardist / 16), self.speedadjust_min)
        end
        self.speed = MathUtils.approach(self.speed, self.idealspeed, 1)
        -- This should be the equivalent of what instance_place is doing in DELTARUNE
        local carcheck
        Object.startCache()
        for _, car in ipairs(TableUtils.filter(Game.world.children, function (v)
            return isClass(v) and v:includes(Registry.events["traffic_car"]) 
        end)) do
            -- DELTARUNE inaccuracy (this was unimplemented so whether you can even call it that depends...)
            -- usually this doesn't check the car walkdir but i do it here because otherwise high density cars will sometimes push each other offroad while turning
            if self:collidesWith(car) and car.walkdir == self.walkdir then
                carcheck = car
                break
            end
        end
        Object.endCache()
        -- Newer cars push older cars out of the way
        if carcheck then
            if carcheck.freshness > self.freshness then
                self.y = self.y - 12
                self.speed = self.speed - 12
                self.speed = MathUtils.clamp(self.speed, 0, 24)
            end
        end
    end
    --

    if self:collidesWith(Game.world.player) and not Game.world.car_collision and self._active and self.touchcon == 0 then
        if not Kristal.callEvent("onTrafficCollision", self, Game.world.player) then
            self.touchcon = 1
            Game.world.car_collision = true
        end
    end

    Kristal.callEvent("onTrafficCarUpdate", self)
end

function TrafficCar:draw()
    if Kristal.callEvent("beforeTrafficCarDraw", self) then
        return
    end
    self.downframetimer = self.downframetimer + DTMULT
    self.animsiner = self.animsiner + DTMULT
    if (self.downframetimer >= 3) then
        if self.downframe == 0 then
            self.downframe = 1
        else
            self.downframe = 0
        end
        self.downframetimer = 0
    end

    self.legs_sprite:setFrame(math.floor(self.animsiner / 6))

    love.graphics.setColor(1, 1, 1, 1)
    if self.walkdir == "down" then
        self:setLegsSpritePosition(0, (self.downframe * 2))
        self:setCarSpritePosition(self.walkx, self.walky + (self.downframe * 4))
		
    elseif self.walkdir == "up" then
        self:setLegsSpritePosition(0, (self.downframe * 2))
        self:setCarSpritePosition(self.walkx, self.walky + (self.downframe * 4))

    elseif self.walkdir == "right" then
        self:setLegsSpritePosition(0, (self.downframe * 2))
        self:setCarSpritePosition(self.walkx, self.walky + (self.downframe * 4))

    elseif self.walkdir == "left" then
        self:setLegsSpritePosition(0, (self.downframe * 2))
        self:setCarSpritePosition(self.walkx, self.walky + (self.downframe * 4))
        self.flip_x = true
    end

    if self.walking then
        self.walklerp = self.walklerp + (0.01 + (self.walklerp / 2))
        if self.walklerp >= 1 then
            self.walklerp = 1
        end
    else
        if self.walklerp >= 0 then
            self.walklerp = self.walklerp * 0.85
        end
        if math.abs(self.walklerp) < 0.02 then
            self.walklerp = 0
        end
        if math.abs(self.walkx) < 0.02 then
            self.walkx = 0
        end
        if math.abs(self.walky) < 0.02 then
            self.walky = 0
        end
    end
    self.walkx = ((math.sin((self.animsiner / 4)) * self.walklerp) * 2)
    self.walky = MathUtils.lerp(0, self.walklerp, -26, true)
    if self.alwayswalking then
        self.walky = -26
    end
    super.draw(self)
    Kristal.callEvent("onTrafficCarDraw", self)
end

-- Okay i will clean this up eventually but its so fiddly that i need to remember how it all pieces together
-- In the meantime i pray that you don't want to have custom car sprites because you will actually suffer
-- Update: i am probably never going to clean this up

function TrafficCar:setCarSpritePosition(x, y)
    if x then
        self.car_sprite.x = x + self.car_sprite.x_offset
    end
    if y then
        self.car_sprite.y = y + self.car_sprite.y_offset
    end
end

function TrafficCar:setLegsSpritePosition(x, y)
    local off_x, off_y = self:getLegOffsetForCurrentFrame()
    if x then
        self.legs_sprite.x = x + self.legs_sprite.x_offset + off_x
    end
    if y then
        self.legs_sprite.y = y + self.legs_sprite.y_offset + off_y
    end
end

function TrafficCar:getLegOffsetForCurrentFrame()
    local down_offsets_x = {
        6,
        2,
        6,
        5,
    }
    local down_offsets_y = {
        16,
        16,
        16,
        16,
    }

    local side_offsets_x = {
        16,
        2,
    }
    local side_offsets_y = {
        12,
        12,
    }

    if self.walkdir == "left" or self.walkdir == "right" then
        return side_offsets_x[self.legs_sprite.frame] * 2, side_offsets_y[self.legs_sprite.frame] * 2
    end

    return down_offsets_x[self.legs_sprite.frame] * 2, down_offsets_y[self.legs_sprite.frame] * 2
end

return TrafficCar