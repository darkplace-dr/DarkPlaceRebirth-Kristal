local badge, super = Class(Badge, "tension_storage")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "Keep Tension"

    self.type = "badge"

    -- Menu description
    self.description = "Keep TP after battles. However, the TP\nwon't be converted into money."
    self.shop = "Keeps tension\nafter battle"
    -- The cost of putting it on
    self.badge_points = 4

    -- Default shop price (sell price is halved)
    self.price = 830
end

function badge:onBadgeEquipped()
    Game:setFlag("tension_storage", true)
    Game.world.tension_bar:show()
end

function badge:onBadgeRemoved()
    Game:setFlag("tension_storage", false)
    Game.world.tension_bar:hide()
    local tp_money = math.floor((Game:getTension() * 2.5) / 10) * Game.chapter
    if tp_money > 0 then
        Assets.playSound("equip")
        Assets.playSound("bell_bounce_short", 0.6, 1.5)
        Game.money = Game.money + tp_money
    end
    Game:setTension(0)
end

return badge