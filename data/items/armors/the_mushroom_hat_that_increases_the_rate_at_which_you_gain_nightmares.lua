---@class Item.the_mushroom_hat_that_increases_the_rate_at_which_you_gain_nightmares : Item
local item, super = Class(Item, "the_mushroom_hat_that_increases_the_rate_at_which_you_gain_nightmares")

function item:init()
    super.init(self)
    self.name = "T.M.H.T.I.T.R.A.W.Y.G.N."
    self.description = "\"The Mushroom Hat That Increases The Rate At Which You Gain Nightmares\", it says."
    self.bonuses = {attack = -1}
    self.type = "armor"

    self.bonus_name = "Nightmares"
    self.bonus_icon = "ui/menu/icon/up"
end

function item:applyMoneyBonus(gold)
    return gold * (0.99)
end

return item
