local item, super = Class(LightHealItem, "mg_item/instant_noodles")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Instant Noodles"
    -- Name displayed in the normal item select menu
    self.short_name = "InstaNood"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "I.Noodles"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "ate"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals for in the overworld
    self.world_heal_amount = 15

    -- Default shop sell price
    self.sell_price = 50
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Comes with everything you need for a quick meal!"

    -- Light world check text
    self.check = "Heals HP\n* Comes with everything you\nneed for a quick meal!."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:getBattleHealAmount(id)
    if Game.battle.encounter.serious then
        return 90
    else
        return 4
    end
end

function item:getLightBattleText(user, target)
    if Game.battle.encounter.serious then
        return super.getLightBattleText(self, user, target) .. "\n* They're better dry."
    else
        return super.getLightBattleText(self, user, target)
    end
end

function item:onLightBattleUse(user, target)
    if not Game.battle.encounter.serious then
        local function after_func()
            Game.battle:setState("ACTIONS", "CUTSCENE")
            super.onLightBattleUse(self, user, target)
        end    

        Game.battle:startCutscene(function(cutscene)
            cutscene:after(after_func)
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
        end)
    else
        super.onLightBattleUse(self, user, target)
    end
    return true
end

return item