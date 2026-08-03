---@class ActorSprite : ActorSprite
local ActorSprite, super = HookSystem.hookScript(ActorSprite)

function ActorSprite:setSprite(texture, keep_anim, ignore_actor_callback)
    if self:hasSprite("climb/climb") then
        --old, let's revise and add
        local revise_animations = {
            "climb/jump_left",
            "climb/jump_right",
            "climb/jump_up",
            "climb/land_left",
            "climb/land_right",
            "climb/slip_left",
            "climb/slip_right"
        }
        local replace_animations = {
            {"climb/climb", "climb/climbing"},
            {"climb/charge/left", "climb/charge_left"},
            {"climb/charge/right", "climb/charge_right"},
            {"climb/slip_fall", "climb/fall"},
            {"climb/charge/up", "climb/charge"}
        }
        local changed = false
        if TableUtils.contains(revise_animations, texture) then
            changed = true
        end
        for _, textures in ipairs(replace_animations) do
            if textures[2] == texture then
                texture = textures[1]
                changed = true
            end
        end
        if changed then
            Kristal.Console:warn("Actor " .. self.actor.id .. " is using an outdated climbing sprite structure! Please update it to use Kristal's native structure.")
            local ox, oy = self.actor:getOffset(texture)
            self.walk_override = false
            self.path = self.actor:getSpritePath()
            self:_setSprite(texture, keep_anim)

            self.actor:onSetSprite(self, texture, keep_anim)
            local t = self:getTexture()
            local h = t and t:getHeight() or 0
            self.force_offset = { ox - 2, oy - (h / 3)} --this is my rough estimate for the change in offset. feel free to change
        else
            super.setSprite(self, texture, keep_anim, ignore_actor_callback)
        end
    else
        super.setSprite(self, texture, keep_anim, ignore_actor_callback)
    end
end

return ActorSprite