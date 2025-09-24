local spell, super = Class("_act", true)

function spell:init()
    super.init(self)
    
    if Game.chapter == 1 then
        self.check = "Do all sorts of things.\n* It isn't magic."
    elseif Game.chapter == 2 then
        self.check = "You can do many things.\n* Don't confuse it with magic."
    elseif Game.chapter == 3 then
        self.check = "Many different skills.\n* It has nothing to do with magic."
    else
        self.check = "Execute various behaviors.\n* It can't be considered magic."
    end
end

return spell