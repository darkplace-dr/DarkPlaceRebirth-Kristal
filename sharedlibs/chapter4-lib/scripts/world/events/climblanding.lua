---@class Event.climbentry : Event
local event, super = Class(Event, "climblanding")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
end

---@param player Player
function event:climbFallLanding(player)
    if self.world:hasCutscene() then return end
    if player.state_manager.state == "CLIMB" then
        player:setState("WALK")
        local tx, ty = player.x, self.y
        ---@param cutscene WorldCutscene
        ---@diagnostic disable-next-line: param-type-mismatch
        self.world:startCutscene(function (cutscene)
            Assets.stopAndPlaySound("noise")
            player.sprite:set("landed")
			player:shake()
            cutscene:wait(16/30)
            local id = "climb_fade"
            for i,follower in ipairs(self.world.followers) do
                local mask = follower:getFX(id)
                if mask then
                    self.world.timer:tween(12/30, mask, {alpha = 1}, nil, function ()
                        follower:removeFX(mask)
                    end)
                end
                -- TODO: Support parties > 3
                follower:setPosition(tx + (i == 1 and -30 or 30), ty + (self.up and 10 or -10))
                follower:setFacing(player.facing)
            end
            cutscene:interpolateFollowers()
            cutscene:attachFollowers()
            player:resetSprite()
        end)
    end
end

return event