local item, super = Class("dogdollar", true)

function item:getLightBattleText(user, target)
    return "* "..user.chara:getNameOrYou().." admired "..self:getUseName().."."
end

return item