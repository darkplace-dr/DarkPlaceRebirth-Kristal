--- CallCardItem is an extension of Item that provides additional functionality for items that summon RECRUITs when used. \
--- This class can be extended from in an item file instead of `Item` to include this functionality in the item.
--- 
---@class CallCardItem : Item
---
---@field recruit           string
---
---@overload fun(...) : CallCardItem
local CallCardItem, super = Class(Item)

function CallCardItem:init()
    super.init(self)
    
    self.name = "Call Card"

    self.recruit_id = "dummy"     -- fallback
    
    self.target = "party"
    
    self.usable_in = "battle"
end

function CallCardItem:getDebugName()
    return "Call Card (" .. self.recruit_id .. ")"
end

function CallCardItem:getBattleText(user, target)
    return "* " .. user.chara:getName() .. " used the call card!\n* " .. self.recruit.name .. " was summoned!"
end

function CallCardItem:postInit()
    self.recruit = Registry.createRecruitBattler(self.recruit_id)
end

function CallCardItem:onBattleUse(user, target)
    Assets.playSound("summon")
    
    Game.battle.ally = self.recruit
    
    if Game.battle.ally_char then
        Game.battle.timer:tween(1, Game.battle.ally_char, {y = -100})
    end
    
    Game.battle.ally_char = Character(self.recruit.actor_id, 150, -100)
    Game.battle.ally_char:setLayer(BATTLE_LAYERS["battlers"])
    Game.battle.ally_char.flip_x = self.recruit.flip
    Game.battle:addChild(Game.battle.ally_char)
    
    Game.battle.timer:tween(1, Game.battle.ally_char, {y = 100})
end

function CallCardItem:getDescription()
    return "A call card for a recruit. Labeled as \"" .. self.recruit.name .. "\"."
end

function CallCardItem:getBattleDescription()
    return "Summon\n" .. self.recruit.name
end

function CallCardItem:getShopDescription()
    return self:getTypeName() .. "\nSummon\n" .. self.recruit.name
end

return CallCardItem
