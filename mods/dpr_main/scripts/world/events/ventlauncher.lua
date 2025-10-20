---@diagnostic disable: param-type-mismatch
local VentLauncher, super = Class(Event)

function VentLauncher:init(data)
    super.init(self, data.x, data.y)

    local properties = data.properties or {}

    self.custom_sprite = properties['sprite']
    self.steam_sprite = properties['steam_sprite']
    self.launch_sound = properties['launch_sound']

    -- Which direction should it launch you?
    self.direction = properties['direction'] or "right"

    -- How far should you launch? Default is 6 tiles, each tile is 40 pixels, so 40*6 = 240
    self.distance = properties['distance'] or 240
    
    -- Alternatively, define a specific position or marker to launch to.
    self.target_x = properties['target_x'] or nil
    self.target_y = properties['target_y'] or nil
    self.marker = properties['marker'] or nil

    -- Should the vent be spawning steam?
    self.make_steam = properties['make_steam'] ~= false

    -- How long should a launch take? Default is 0.75, or 3/4ths of a second.
    self.launch_time = properties['launch_time'] or 0.75

    -- Is this vent part of a sequence of jumps? Every vent in the sequence should have this EXCEPT for the last
    self.sequence_jump = properties['sequence_jump'] or false

    -- 0 is none, 1 is flipping back and forth, 2 is 90 degrees clockwise, 3 is 90 degrees counter-clockwise
    self.rotation_type = properties['rotation_type'] or 0
    -- Time it takes for a rotation to happen
    self.rotation_delay = properties['rotation_delay'] or 30

    self.switchable = properties['switchable'] or false
    self.switch_state = properties['switch_state'] or 0
    
    if self.custom_sprite then 
        self:setSprite(self.custom_sprite)
    else self:setSprite("world/events/ventlauncher/" .. self.direction)
    end
    self.sprite:play(4/30)
    self.steam_active = true
    
    if self.switch_state == 2 then
        self.solid = true
        self.visible = false
    end
    Game.world.timer:after(1/30, function ()
        self.layer = self.layer - 0.1 -- I don't know why, but the layer gets reset somewhere after the init, so lowering it is done a frame later
    end)

    self.con = 0

    self.rotating = 0

    self.cooldown = 0


    self.timer = Timer()
    self:addChild(self.timer)

    self.timer:every(10/30, function ()
        if self.make_steam then
            if self.steam_active and not self.solid then -- Cheating
                local steam = Game.world:spawnObject(VentSteam(), WORLD_LAYERS['above_events'])
                steam.x = self.x + 20
                steam.y = self.y + 20
            end
        end
    end)

end

function VentLauncher:getLegacy()
    local legacy = false
    if self.legacy ~= nil then
        legacy = self.legacy
    elseif Mod.libs["hotland_pack"] then
        legacy = Kristal.getLibConfig("hotland-pack", "legacy_vents")
    end
    return legacy
end

function VentLauncher:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "Direction: " .. self.direction)
    table.insert(info, "Distance: " .. self.distance)
    table.insert(info, "Is Sequence: " .. (self.sequence_jump and "Yes" or "No"))
    if self.rotation_type > 0 then
        table.insert(info, "Rotation Type: " .. self.rotation_type)
        table.insert(info, "Rotation Timer: " .. math.floor(self.rotating))
    end
    return info
end

function VentLauncher:update()
    super.update(self)
    local directions =
    {
        up = 270,
        down = 90,
        left = 180+45,
        right = 270+45
    }
    if self.con > 0 then
        if self.make_steam then
            local steam = Game.world:spawnObject(VentSteam(), WORLD_LAYERS['above_events'])
            steam.x = self.x + 20
            steam.y = self.y + 20
            steam.physics.speed = 14
            steam.physics.direction = math.rad(directions[self.direction])
            if self.direction == "down" then
                steam.physics.speed = 4
                steam.physics.direction = math.rad(180)
            end
        end

        self.con = self.con - 1 * DTMULT
    end

    local rotations = {
        -- Type 1: Turn around
        {
            up = "down",
            down = "up",
            left = "right",
            right = "left"
        },
        -- Type 2: turn 90 degrees clockwise
        {
            up = "right",
            down = "left",
            left = "up",
            right = "down"
        },
        -- Type 3: turn 90 degrees counter-clockwise
        {
            up = "left",
            down = "right",
            left = "down",
            right = "up"
        },
    }
    if self.rotation_type > 0 and (not Game.world.jumping and not Game.world.sequence_jumping) then
        self.rotating = self.rotating + 1 * DTMULT
        if self.rotating >= self.rotation_delay then
            self.direction = rotations[self.rotation_type][self.direction]
            self:setSprite("world/events/ventlauncher/" .. self.direction)
            self.rotating = 0
        end
    end


    if self.cooldown > 0 then
        self.cooldown = math.max(self.cooldown - 1 * DTMULT, 0)
    end




    
end

function VentLauncher:onEnter(player)
    if player == Game.world.player and (not Game.world.jumping or self.sequence_jump) and self.cooldown == 0 and not Game.world.player.cliff then

        self.steam_active = false
        self.timer:after(2, function ()
            self.steam_active = true
        end)

        
        
        
        if not Game.world.sequence_jumping then -- Assuming this is a sequence, we've just entered it and are not already in it.
            Game.world:detachFollowers()
            Game.lock_movement = true
            player:setFacing(self.direction)
            player:slideTo(self.x + self.width/2, self.y + self.height/2 + 5, 0.1)
            for i, follower in ipairs(Game.world.followers) do
                follower:setFacing(self.direction)
                follower:slideTo(self.x + self.width/2, self.y + self.height/2 + 5, 0.1)
            end
        end
        
        
        if self.sequence_jump then
            Game.world.sequence_jumping = true
            Game.world.jumping = false
        else
            Game.world.sequence_jumping = false
            Game.world.jumping = true
        end
        
        -- Uuuuugh this is an abomination but it fixes sequence jumps
        Game.world.timer:after((player.jumping == true and self.direction == "up" and (player.jump_x == player.jump_start_x)) and 0.5 or 1/30, function ()
            
            Game.world.timer:after(0.2, function ()
                self:jump(player)
                local legacy = VentLauncher:getLegacy()
                Game.world.timer:after(not legacy and 5/30 or 1/30, function () 
                    Assets.playSound(self.launch_sound or "vaporized")
                    self.con = 20
                    local vents = Game.world.map:getEvents("ventlauncher")
                    for i, vent in ipairs(vents) do
                        vent.cooldown = 6
                    end
                        self.cooldown = 30
                end)
    
            end)
            for i, follower in ipairs(Game.world.followers) do
                Game.world.timer:after(0.2 * (i+1), function ()
                    self:jump(follower)
                end)
            end
        end)
        
        if Game.world.jumping then
            local legacy = VentLauncher:getLegacy()
            Game.world.timer:after((self.launch_time + (not legacy and 0.25 or 0.05)) + (0.2 * #Game.world.followers+0.3), function ()
                Game.world.player:interpolateFollowers()
                Game.world:attachFollowers()
                Game.lock_movement = false
                Game.world.jumping = false
            end)
        end
    end
    
end


function VentLauncher:jump(chara)
    chara:setFacing(self.direction)
    local legacy = VentLauncher:getLegacy()
    if self.marker then
        local x, y = Game.world.map:getMarker(type(self.marker) == "table" and self.data.properties.marker.id or self.marker)
        chara:jumpTo(x, y, 20, self.launch_time or 0.75, not legacy and "jump_ball" or nil, not legacy and "landed" or nil)
    elseif self.target_x and self.target_y then
        chara:jumpTo(self.target_x, self.target_y, 20, self.launch_time or 0.75, not legacy and "jump_ball" or nil, not legacy and "landed" or nil)
    else
        if self.direction == "right" or self.direction == "left" then
            chara:jumpTo((self.x+self.width/2) + (self.direction == "right" and self.distance or -self.distance), self.y+self.height/2+5, 20, self.launch_time or 0.75, not legacy and "jump_ball" or nil, not legacy and "landed" or nil)
        elseif self.direction == "up" or self.direction == "down" then
            chara:jumpTo((self.x+self.width/2), (self.y+self.height/2) + (self.direction == "up" and -self.distance+7 or self.distance+5), 20, self.launch_time or 0.75, not legacy and "jump_ball" or nil, not legacy and "landed" or nil)
        end
    end

    -- If in legacy mode, spin the character around clockwise
    if legacy then
        local spinner
        self.timer:after(3/30, function ()
            spinner = self.timer:everyInstant(0.75/4, function ()
                if chara.facing ==     "down" then chara:setFacing("left")
                elseif chara.facing == "left" then chara:setFacing("up")
                elseif chara.facing == "up"   then chara:setFacing("right")
                elseif chara.facing == "right" then chara:setFacing("down")
                end
            end)
        end)
        self.timer:after(3/30 + self.launch_time, function ()
            self.timer:cancel(spinner)
        end)
    end


end

return VentLauncher