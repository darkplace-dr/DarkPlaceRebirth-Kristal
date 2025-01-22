local spell, super = Class("_act", true)

function spell:init()
    super.init(self)
    
    if Game.chapter == 1 then
        self.check = "Do all sorts of things.\n* It isn't magic."
    else
        self.check = "You can do many things.\n* Don't confuse it with magic."
    end
end

return spell