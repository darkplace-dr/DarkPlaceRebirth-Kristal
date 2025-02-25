local item, super = Class(HealItem, "undertale/dog_salad")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Dog Salad"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "eat"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "eats"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 8
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "(Hit Poodles.)"

    -- Light world check text
    self.check = "Heals ?? HP\n* Recovers HP.\n* (Hit Poodles.)"

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false
    
end

function item:battleUseSound(user, target)
    Game.battle.timer:script(function(wait)
        Assets.stopAndPlaySound("swallow")
        wait(0.4)
        if not MagicalGlassLib.serious_mode then
            Assets.stopAndPlaySound("dogresidue")
        else
            Assets.stopAndPlaySound("power")
        end
    end)
end

function item:worldUseSound(target)
    Game.world.timer:script(function(wait)
        Assets.stopAndPlaySound("swallow")
        wait(0.4)
        if not MagicalGlassLib.serious_mode then
            Assets.stopAndPlaySound("dogresidue")
        else
            Assets.stopAndPlaySound("power")
        end
    end)
end

function item:onWorldUse(target)
    local dogsad = Utils.random(0, 3, 1)
    
    local amount = 1

    if dogsad == 0 then
        amount = 30
    end
    if dogsad == 1 then
        amount = 10
    end
    if dogsad == 2 then
        amount = 2
    end
    if dogsad == 3 then
        amount = math.huge
    end
    
    local text = self:getWorldUseText(target, dogsad)
    
    local best_amount
    for _,member in ipairs(Game.party) do
        local equip_amount = 0
        for _,equip in ipairs(member:getEquipment()) do
            if equip.getHealBonus then
                equip_amount = equip_amount + equip:getHealBonus()
            end
        end
        if not best_amount or equip_amount > best_amount then
            best_amount = equip_amount
        end
    end
    amount = amount + best_amount

    if self.target == "ally" then
        self:worldUseSound(target)
        Game.world:heal(target, amount, text, self)
        return true
    elseif self.target == "party" then
        self:worldUseSound(target)
        for _,party_member in ipairs(target) do
            Game.world:heal(party_member, amount, text, self)
        end
        return true
    else
        return false
    end
end

function item:getWorldUseText(target, dogsad)
    local message = ""
    if dogsad == 0 then
        message = "* Oh.[wait:10] Tastes yappy..."
    end
    if dogsad == 1 then
        message = "* Oh.[wait:10] Fried tennis ball..."
    end
    if dogsad == 2 then
        message = "* Oh.[wait:10] There are bones..."
    end
    if dogsad == 3 then
        message = "* It's literally garbage???"
    end
    return super.getWorldUseText(self, target).."\n"..message
end

function item:getLightBattleText(user, target, dogsad)
    local message
    if dogsad == 0 then
        message = "* Oh.[wait:10] Tastes yappy..."
    end
    if dogsad == 1 then
        message = "* Oh.[wait:10] Fried tennis ball..."
    end
    if dogsad == 2 then
        message = "* Oh.[wait:10] There are bones..."
    end
    if dogsad == 3 then
        message = "* It's literally garbage???"
    end
    
    return super.getLightBattleText(self, user, target).."\n"..message
end

function item:onLightBattleUse(user, target)
    local dogsad = Utils.random(0, 3, 1)

    local amount = 1

    if dogsad == 0 then
        amount = 30
    end
    if dogsad == 1 then
        amount = 10
    end
    if dogsad == 2 then
        amount = 2
    end
    if dogsad == 3 then
        amount = math.huge
    end
    
    for _,equip in ipairs(user.chara:getEquipment()) do
        if equip.getHealBonus then
            amount = amount + equip:getHealBonus()
        end
    end

    self:battleUseSound(user, target)
    target:heal(amount, false)
    Game.battle:battleText(self:getLightBattleText(user, target, dogsad).."\n"..self:getLightBattleHealingText(user, target, amount))
    return true
end

function item:onBattleUse(user, target)
    local dogsad = Utils.random(0, 3, 1)

    local amount = 1

    if dogsad == 0 then
        amount = 30
    end
    if dogsad == 1 then
        amount = 10
    end
    if dogsad == 2 then
        amount = 2
    end
    if dogsad == 3 then
        amount = math.huge
    end
    
    for _,equip in ipairs(user.chara:getEquipment()) do
        if equip.getHealBonus then
            amount = amount + equip:getHealBonus()
        end
    end

    if not MagicalGlassLib.serious_mode then
        Assets.stopAndPlaySound("dogresidue")
    end
    target:heal(amount)
    return true
end

return item