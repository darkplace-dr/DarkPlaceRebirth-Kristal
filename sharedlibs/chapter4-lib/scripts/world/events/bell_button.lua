---@class Event.bell_button : Event
local event, super = Class(Event, "bell_button")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    
end

function event:onEnter(player)
    if not player.is_player then return end
    Assets.playSound("churchbell_short")
    self.world:addChild(RippleEffect(player.x, player.y, 50, 460, 10, {1, 1, 0}, 0, 0, 1));
    self.world:addChild(RippleEffect(player.x, player.y, 50, 380, 10, {1, 1, 0}, 0, 0, 1));
    self.world:addChild(RippleEffect(player.x, player.y, 50, 320, 10, {1, 1, 0}, 0, 0, 1));
    self.world:addChild(RippleEffect(player.x, player.y, 50, 240, 10, {1, 1, 0}, 0, 0, 1));
end

return event