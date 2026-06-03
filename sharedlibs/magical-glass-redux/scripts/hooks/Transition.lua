local Transition, super = HookSystem.hookScript(Transition)

function Transition:init(x, y, shape, properties)
    super.init(self, x, y, shape, properties)

    properties = properties or {}

    self.target["lightshop"] = properties.lightshop
end

function Transition:getDebugInfo()
    local info = Event.getDebugInfo(self)
    if self.target.map then table.insert(info, "Map: " .. self.target.map) end
    if self.target.shop then table.insert(info, "Shop: " .. self.target.shop) end
    if self.target.lightshop then table.insert(info, "Light Shop: " .. self.target.lightshop) end
    if self.target.x then table.insert(info, "X: " .. self.target.x) end
    if self.target.y then table.insert(info, "Y: " .. self.target.y) end
    if self.target.marker then table.insert(info, "Marker: " .. self.target.marker) end
    if self.target.facing then table.insert(info, "Facing: " .. self.target.facing) end
    return info
end

function Transition:onEnter(chara)
    if chara.is_player then
        local x, y = self.target.x, self.target.y
        local facing = self.target.facing
        local marker = self.target.marker

        if self.sound then
            Assets.playSound(self.sound, 1, self.pitch)
        end

        if self.target.shop and self.target.lightshop then
            error("Transition cannot have both shop and lightshop")
        elseif self.target.shop then
            self.world:shopTransition(self.target.shop, {x=x, y=y, marker=marker, facing=facing, map=self.target.map})
        elseif self.target.lightshop then
            self.world:lightShopTransition(self.target.lightshop, {x=x, y=y, marker=marker, facing=facing, map=self.target.map})
        elseif self.target.map then
            local callback = function(map)
                if self.exit_sound then
                    Assets.playSound(self.exit_sound, 1, self.exit_pitch)
                end
                Game.world.door_delay = self.exit_delay
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