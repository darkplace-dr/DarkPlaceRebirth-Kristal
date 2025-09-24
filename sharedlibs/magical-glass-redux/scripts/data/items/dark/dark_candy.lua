local item, super = Class("dark_candy", true)

function item:init()
    super.init(self)

    if Game:getConfig("darkCandyForm") == "darker" then
        self.short_name = "DarkerCndy"
    end
end

return item