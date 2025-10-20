---@class TeaItem : HealItem
---@overload fun(...) : TeaItem
local TeaItem, super = Class(HealItem)

function TeaItem:init()
    super.init(self)

    -- Amount that this item heals the owner
    self.heal_amount = 10
    -- Party member this tea is from
    self.tea_self = nil
end

function TeaItem:getHealAmount(id)
    if id ~= self.tea_self then
        local user = Game:getPartyMember(id)
        return user:getOpinion(self.tea_self)
    end
    return self.heal_amount
end

function TeaItem:getBattleHealAmount(id)
    -- Dont heal less than 40HP in battles
    return math.max(40, super.getBattleHealAmount(self, id))
end

return TeaItem