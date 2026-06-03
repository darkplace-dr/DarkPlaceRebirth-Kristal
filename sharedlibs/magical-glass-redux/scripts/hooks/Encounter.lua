local Encounter, super = HookSystem.hookScript(Encounter)

function Encounter:init()
    super.init(self)

    -- Whether Karma (KR) UI changes will appear.
    self.karma_mode = false

    -- Whether the flee command is available at the mercy button
    self.can_flee = Game:isLight()

    -- Amount of times the player used the yellow soul's BIGSHOT cheat
    self.yellow_funnycheat = 0

    -- The chance of successful flee (increases by 10 every turn)
    self.flee_chance = 50

    -- A random flee message that appears when you manage to run away.
    self.flee_messages = {}
end

function Encounter:canFlee()
    return self.can_flee
end

function Encounter:getMonsterSoul() end

function Encounter:onTurnEnd()
    self.flee_chance = self.flee_chance + 10

    return super.onTurnEnd(self)
end

function Encounter:getFleeMessage()
    if #self.flee_messages == 0 then
        local flee_messages = {
            "* I'm outta here.", -- 1/20
            "* I've got better to do.", --1/20
            "* Don't slow me down.", --1/20
            "* Escaped..." --17/20
        }

        return flee_messages[math.min(MathUtils.round(MathUtils.random(1, 20)), #flee_messages)]
    end

    return self.flee_messages[MathUtils.round(MathUtils.random(1, #self.flee_messages))]
end

function Encounter:getVictoryText(text, money, xp)
    if Game.battle.fled then
        if money ~= 0 or xp ~= 0 or Game.battle.used_violence and Game:getConfig("growStronger") and not Game:isLight() then
            if Game:isLight() then
                return string.format("* Ran away with %s EXP\nand %s %s.", xp, money, Game:getConfig("lightCurrency"):upper())
            else
                if Game.battle.used_violence and Game:getConfig("growStronger") then
                    local stronger = "You"

                    for _, battler in ipairs(Game.battle.party) do
                        if Game:getConfig("growStrongerChara") and battler.chara.id == Game:getConfig("growStrongerChara") then
                            stronger = battler.chara:getName()
                            break
                        end
                    end

                    if xp == 0 then
                        return string.format("* Ran away with %s %s.\n* %s became stronger.", money, Game:getConfig("darkCurrencyShort"), stronger)
                    else
                        return string.format("* Ran away with %s EXP and %s %s.\n* %s became stronger.", xp, money, Game:getConfig("darkCurrencyShort"), stronger)
                    end
                else
                    return string.format("* Ran away with %s EXP and %s %s.", xp, money, Game:getConfig("darkCurrencyShort"))
                end
            end
        else
            return self:getFleeMessage()
        end
    elseif Game:isLight() then
        local win_text = string.format("* You won!\n* Got %s EXP and %s %s.", xp, money, Game:getConfig("lightCurrency"):lower())
        -- if (in_dojo) then
        --     win_text == "* You won the battle!"
        -- end

        for _, member in ipairs(Game.battle.party) do
            local lv = member.chara:getLightLV()
            member.chara:addLightEXP(xp)

            if lv ~= member.chara:getLightLV() then
                win_text = string.format("* You won!\n* Got %s EXP and %s %s.\n* Your %s increased.", xp, money, Game:getConfig("lightCurrency"):lower(), Kristal.getLibConfig("magical-glass", "light_level_name"))
                Assets.stopAndPlaySound("levelup")
            end
        end

        return win_text
    elseif xp ~= 0 and Game.battle.used_violence and Game:getConfig("growStronger") then
        local stronger = "You"
        for _, battler in ipairs(Game.battle.party) do
            if Game:getConfig("growStrongerChara") and battler.chara.id == Game:getConfig("growStrongerChara") then
                stronger = battler.chara:getName()
            end
        end
        return string.format("* You won!\n* Got %s EXP and %s %s.\n* %s became stronger.", xp, money, Game:getConfig("darkCurrencyShort"), stronger)
    else
        return super.getVictoryText(self, text, money, xp)
    end
end

function Encounter:onFlee() end
function Encounter:onFleeFail() end

function Encounter:beforeStateChange(old, new, reason)
    if new == "VICTORY" then
        if Game:isLight() then
            Game.battle.used_violence_backup = Game.battle.used_violence
            Game.battle.used_violence = false
            Game.battle.money_backup = Game.money
        end
    end

    return super.beforeStateChange(self, old, new, reason)
end

function Encounter:getVictoryMoney(money)
    if Game.battle.fled or Game:isLight() then
        local tension_money = math.floor(((Game:getTension() * 2.5) / 10)) * Game.chapter
        for _, battler in ipairs(Game.battle.party) do
            for _, equipment in ipairs(battler.chara:getEquipment()) do
                tension_money = math.floor(equipment:applyMoneyBonus(tension_money) or tension_money)
            end
        end
        money = math.floor(money - tension_money)
    end

    if Game:isLight() and Kristal.getLibConfig("magical-glass", "light_world_dark_battle_tension") and not Game.battle.fled then
        local tension_money = math.floor(Game:getTension() / 5)
        for _, battler in ipairs(Game.battle.party) do
            for _, equipment in ipairs(battler.chara:getEquipment()) do
                tension_money = math.floor(equipment:applyMoneyBonus(tension_money) or tension_money)
            end
        end
        money = math.floor(money + tension_money)
    end

    return money
end

return Encounter