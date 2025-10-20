local item, super = Class("light/blackshard", true)

function item:init()
    super.init(self)

    self.can_sell = false
    
    self.light_bolt_direction = "random"
end

function item:getLightBoltSpeed()
    local speed = super.getLightBoltSpeed(self)
    if speed then
        return speed * 1.25
    else
        return nil
    end
end

return item