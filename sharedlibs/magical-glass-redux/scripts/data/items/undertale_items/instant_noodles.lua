local item, super = Class(HealItem, "undertale/instant_noodles")

function item:init()
    super.init(self)

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "ate"
    -- Display name
    self.name = "Instant Noodles"
    self.short_name = "InstaNood"
    self.serious_name = "I.Noodles"
    self.dark_name = "Insta Noodles"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    self.heal_amount = 90
    self.world_heal_amount = 15

    -- Default shop sell price
    self.sell_price = 50
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Comes with everything you need for a quick meal!"

    -- Light world check text
    self.check = "Heals HP\n* Comes with everything you\nneed for a quick meal!"

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false
    
end

function item:getLightBattleText(user, target)
    local message = ""
    if not self.cooked then
        message = "\n* They're better dry."
    end
    return "* " .. target.chara:getNameOrYou() .. " "..self:getUseMethod(target.chara).." the Instant Noodles."..message
end

function item:onLightBattleUse(user, target)
    self.cooked = false
    local function heal()
        local text = self:getLightBattleText(user, target)
        self:battleUseSound(user, target)
        local amount = self:getBattleHealAmount(target.chara.id)
        
        if self.heal_amount then
            text = text .. "\n" .. self:getLightBattleHealingText(user, target, amount)
        end

        target:heal(amount, false)
        return text
    end

    if not MagicalGlassLib.serious_mode then
        Game.battle:startCutscene(function(cutscene)
            cutscene:text("[noskip]* You remove the Instant\nNoodles from their\npackaging.")
            cutscene:text("[noskip]* You put some water in\nthe pot and place it on\nthe heat.")
            cutscene:text("[noskip]* You wait for the water\nto boil.")
            cutscene:text("[noskip]* ...[wait:40]\n* ...[wait:40]\n* ...")
            Game.battle.music:pause()
            cutscene:text("[noskip]* It's[wait:20] boiling.")
            cutscene:text("[noskip]* You place the noodles[wait:10]\ninto the pot.")
            cutscene:text("[noskip]* 4[wait:30] minutes left[wait:30] until\nthe noodles[wait:20] are finished.")
            cutscene:text("[noskip]* 3[wait:30] minutes left[wait:30] until\nthe noodles[wait:20] are finished.")
            cutscene:text("[noskip]* 2[wait:30] minutes left[wait:30] until\nthe noodles[wait:20] are finished.")
            cutscene:text("[noskip]* 1[wait:30] minute left[wait:30] until\nthe noodles[wait:20] are finished.")
            cutscene:text("[noskip]* The noodles[wait:30] are finished.")
            cutscene:text("[noskip]* ... they don't taste very\ngood.")
            cutscene:text("[noskip]* You add the flavor packet.")
            cutscene:text("[noskip]* That's better.")
            cutscene:text("[noskip]* Not great,[wait:10] but better.")
            Game.battle.music:resume()
            self.cooked = true
            self.heal_amount = 4
            for _,equip in ipairs(user.chara:getEquipment()) do
                if equip.getHealBonus then
                    self.heal_amount = self.heal_amount + equip:getHealBonus()
                end
            end
            cutscene:text(heal())
        end)
    else
        super.onLightBattleUse(self, user, target)
    end
    return true
end

function item:onBattleUse(user, target)
    if not MagicalGlassLib.serious_mode then
        self.heal_amount = 4
    end
    return super.onBattleUse(self, user, target)
end

return item