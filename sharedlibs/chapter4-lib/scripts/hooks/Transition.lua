---@class Transition : Transition
local Transition, super = Utils.hookScript(Transition)

function Transition:init(x,y,shape,properties)
    super.init(self,x,y,shape,properties)
    self.climbable = true
end

function Transition:onEnter(chara)
    if chara.state ~= "CLIMB" then
        return super.onEnter(self, chara)
    end
end

function Transition:onClimbEnter(chara)
    local wld = self.world
    if chara.is_player then
        local x, y = self.target.x, self.target.y
        local facing = self.target.facing
        local marker = self.target.marker

        if self.sound then
            Assets.playSound(self.sound, 1, self.pitch)
        end

        if self.target.shop then
            self.world:shopTransition(self.target.shop, {x=x, y=y, marker=marker, facing=facing, map=self.target.map})
        elseif self.target.map then
            local callback = function(map)
                if self.exit_sound then
                    Assets.playSound(self.exit_sound, 1, self.exit_pitch)
                end
                wld.player:setState("CLIMB")
                Game.world.door_delay = self.exit_delay

                local id = "climb_fade"
                for _,follower in ipairs(wld.followers) do
                    if not follower:getFX(id) then
                        follower:addFX(AlphaFX(0), id)
                    end
                end
            end

            if marker then
                self.world:mapTransition(self.target.map, marker, facing or chara.facing, callback)
            else
                self.world:mapTransition(self.target.map, x, y, facing or chara.facing, callback)
            end
        end
    end
end

return Transition