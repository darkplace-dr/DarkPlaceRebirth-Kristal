local item, super = Class(LightHealItem, "mg_item/dog_salad")

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

    self.use_sound = "dogsalad"

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Recovers HP. (Hit Poodles.)"

    -- Light world check text
    self.check = "Heals ?? HP\n* Recovers HP.\n* (Hit Poodles.)"

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:playLightBattleUseSound(user, target)
    Game.battle.timer:script(function(wait)
        Assets.stopAndPlaySound("swallow")
        wait(0.4)
        if not Game.battle.encounter.serious then
            Assets.stopAndPlaySound(self.use_sound)
        else
            Assets.stopAndPlaySound("power")
        end
    end)
end

function item:onWorldUse(target)
    local amount = 1
    local dogsad = math.floor(Utils.random(4))
    local text = self:getWorldUseText(target, dogsad)

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
        amount = 999
    end

    self:playWorldUseSound(target)
    Game.world:heal(target, amount, text, self)
    return true
end

function item:getWorldUseText(target, dogsad)
    local message = ""
    if dogsad == 0 then
        message = "\n* Oh.[wait:10] Tastes yappy..."
    end
    if dogsad == 1 then
        message = "\n* Oh.[wait:10] Fried tennis ball..."
    end
    if dogsad == 2 then
        message = "\n* Oh.[wait:10] There are bones..."
    end
    if dogsad == 3 then
        message = "\n* It's literally garbage???"
    end
    return "* " ..target:getNameOrYou().." "..self:getUseMethod(target).." the Dog Salad."..message
end

function item:getLightBattleText(user, target, dogsad)
    local message
    if dogsad == 0 then
        message = "\n* Oh.[wait:10] Tastes yappy..."
    end
    if dogsad == 1 then
        message = "\n* Oh.[wait:10] Fried tennis ball..."
    end
    if dogsad == 2 then
        message = "\n* Oh.[wait:10] There are bones..."
    end
    if dogsad == 3 then
        message = "\n* It's literally garbage???" -- noelle quote, probably
    end
    
    return "* " ..target.chara:getNameOrYou().." "..self:getUseMethod(target.chara).." the Dog Salad."..message
end

function item:onLightBattleUse(user, target)
    local amount = 1
    local dogsad = math.floor(Utils.random(4))

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
        amount = 999
    end

    self:playLightBattleUseSound(user, target)
    target:heal(self:getHealAmount())
    Game.battle:battleText(self:getLightBattleText(user, target, dogsad).."\n"..self:getLightBattleHealingText(user, target, self:getBattleHealAmount()))
    return true
end

return item