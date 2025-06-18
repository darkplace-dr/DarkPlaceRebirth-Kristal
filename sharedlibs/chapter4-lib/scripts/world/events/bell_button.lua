---@class Event.bell_button : Event
local event, super = Class(Event, "bell_button")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    
end

function event:onEnter(player)
    if not player.is_player then return end
    Assets.playSound("churchbell_short")
    RippleEffect:MakeRipple(self.x, self.y, 50, 65535, 460, 1, 10, 1999980);
    RippleEffect:MakeRipple(self.x, self.y, 50, 65535, 380, 1, 10, 1999980);
    RippleEffect:MakeRipple(self.x, self.y, 50, 65535, 320, 1, 10, 1999980);
    RippleEffect:MakeRipple(self.x, self.y, 50, 65535, 240, 1, 10, 1999980);
end

return event