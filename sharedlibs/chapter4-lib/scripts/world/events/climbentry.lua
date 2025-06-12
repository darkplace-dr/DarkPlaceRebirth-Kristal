---@class Event.climbentry : Event
local event, super = Class(Event, "climbentry")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.up = properties.up or false
    self.yoffset = properties.yoff or (self.up and -5 or (self.height + 40))
end

---@param player Player
function event:onInteract(player, dir)
    if player.state_manager.state ~= "WALK" then return end
    if dir ~= "up" and dir ~= "down" then
        Kristal.Console:warn("climbentry interacted at a weird angle ("..dir..")! Assuming \"down\"...")
        dir = "down"
    end

    local id = "climb_fade"
    for _,follower in ipairs(self.world.followers) do
        local mask = follower:addFX(AlphaFX(1), id)
        self.world.timer:tween(10/30, mask, {alpha = 0})
    end

    ---@param cutscene WorldCutscene
    ---@diagnostic disable-next-line: param-type-mismatch
    self.world:startCutscene(function (cutscene)
        local tx = Utils.round(player.x-(self.x+20), 40)+(self.x+20)
        tx = Utils.clamp(tx, self.x+20, self.x+self.width-20)
        local ty = Utils.round(self.y, 40)
        if dir == "down" then
            ty = ty + 80
        else
            ty = ty - 40
        end
        
        Assets.playSound("wing")
        player.sprite:set("jump_ball")
        cutscene:wait(cutscene:jumpTo(player,tx,ty,10,.5))
        player:resetSprite()
        cutscene:detachFollowers()
        Assets.playSound("noise")
        player:setState("CLIMB")
    end)
end

---@param player Player
function event:preClimbEnter(player)
    if self.world:hasCutscene() then return end
    if player.state_manager.state == "CLIMB" then
        player:setState("WALK")
        local tx, ty = player.x, self.y
        ty = ty + self.yoffset
        ---@param cutscene WorldCutscene
        ---@diagnostic disable-next-line: param-type-mismatch
        self.world:startCutscene(function (cutscene)
            Assets.stopAndPlaySound("wing")
            player.sprite:set("jump_ball")
            cutscene:wait(cutscene:jumpTo(player,tx,ty,10,.5))
            player:resetSprite()
            Assets.playSound("noise")
            local id = "climb_fade"
            for i,follower in ipairs(self.world.followers) do
                local mask = follower:getFX(id)
                if mask then
                    self.world.timer:tween(10/30, mask, {alpha = 1}, nil, function ()
                        follower:removeFX(mask)
                    end)
                end
                -- TODO: Support parties > 3
                follower:setPosition(tx + (i == 1 and -30 or 30), ty + (self.up and 10 or -10))
                follower:setFacing(player.facing)
            end
            cutscene:interpolateFollowers()
            cutscene:attachFollowers()
        end)
    end
end

return event