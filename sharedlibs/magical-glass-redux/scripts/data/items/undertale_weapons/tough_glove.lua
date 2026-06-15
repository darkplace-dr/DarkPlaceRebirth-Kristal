local item, super = Class(LightEquipItem, "undertale/tough_glove")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Tough Glove"
    self.short_name = "TuffGlove"
    self.serious_name = "Glove"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Shop description
    self.shop = "Slap 'em."
    -- Default shop price (sell price is halved)
    self.price = 50
    -- Default shop sell price
    self.sell_price = 50
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A worn pink leather glove.\nFor five-fingered folk."

    -- Light world check text
    self.check = "Weapon AT 5\n* A worn pink leather glove.[wait:10]\n* For five-fingered folk."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    self.bonuses = {
        attack = 5
    }

    self.attack_punches = 4
    self.attack_punch_time = 1
    self.light_bolt_direction = "random"

    self.attack_sound = "punchstrong"
    self.light_bolt_speed_multiplier = 1.2
    self.light_attack_crit_multiplier = 2.1

    self.tags = {"punch"}
end

function item:showEquipText(target)
    Game.world:showText("* " .. target:getNameOrYou() .." equipped Tough Glove.")
end

function item:showEquipTextFail(target)
    Game.world:showText("* " .. target:getNameOrYou() .. " didn't want to equip Tough Glove.")
end

function item:getLightBattleText(user, target)
    local text = "* "..target.chara:getNameOrYou().." equipped "..self:getUseName().."."
    if user ~= target then
        text = "* "..user.chara:getNameOrYou().." gave "..self:getUseName().." to "..target.chara:getNameOrYou(true)..".\n" .. "* "..target.chara:getNameOrYou().." equipped it."
    end
    return text
end

function item:getLightBattleTextFail(user, target)
    local text = "* "..target.chara:getNameOrYou().." didn't want to equip "..self:getUseName().."."
    if user ~= target then
        text = "* "..user.chara:getNameOrYou().." gave "..self:getUseName().." to "..target.chara:getNameOrYou(true)..".\n" .. "* "..target.chara:getNameOrYou().." didn't want to equip it."
    end
    return text
end

function item:onLightAttack(battler, enemy, damage, stretch, crit)
    if Game.battle:getActionBy(battler).action == "AUTOATTACK" then
        self:startLightAttackAnimation(battler, enemy, damage, stretch, crit, {sprite = "effects/lightattack/hyperfist", color = true,
          shake = true, speed = 2/30, scale = 1, battle_shake = true})
        
        Game.battle.timer:after(10/30, function()
            self:onLightAttackHurt(battler, enemy, damage, stretch, crit)
        end)
    else
        local state = "PRESS" -- PRESS, PUNCHING, DONE
        local punches = 0
        local punch_time = 0

        local confirm_button
        local press = Sprite("ui/lightbattle/pressz_press")
        local confirm_key = StringUtils.sub(Input.getText("confirm"), 2, -2)
        
        local relative_pos_x, relative_pos_y = 0, 0
        if Input.usingGamepad() then
            confirm_button = Sprite(Input.getTexture("confirm"))
            confirm_button:setScale(2)
            confirm_button:setOrigin(0.5)
            relative_pos_x, relative_pos_y = enemy:getRelativePos((enemy.width / 2), (enemy.height / 2) + 6)
        elseif confirm_key ~= "Z" then
            confirm_button = Text(confirm_key)
            confirm_button:setColor(0, 1, 0)
            confirm_button:addFX(OutlineFX({0, 0, 0}))
            relative_pos_x, relative_pos_y = enemy:getRelativePos((enemy.width / 2) - 3 - (#confirm_key - 1) * 3.5, (enemy.height / 2) - 3)
        else
            confirm_button = Sprite("ui/lightbattle/pressz_z")
            confirm_button:setOrigin(0.5)
            relative_pos_x, relative_pos_y = enemy:getRelativePos((enemy.width / 2), (enemy.height / 2))
        end
        
        confirm_button:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
        
        local press_timer = 3
        press:setOrigin(0.5)
        local relative_pos_x, relative_pos_y = enemy:getRelativePos((enemy.width / 2), (enemy.height / 2))
        press:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
        
        press:setLayer(LIGHT_BATTLE_LAYERS["above_arena_border"])
        press.battler_id = battler and Game.battle:getPartyIndex(battler.chara.id) or nil
        table.insert(enemy.dmg_sprites, press)
        
        confirm_button:setLayer(LIGHT_BATTLE_LAYERS["above_arena_border"])
        confirm_button.battler_id = battler and Game.battle:getPartyIndex(battler.chara.id) or nil
        table.insert(enemy.dmg_sprites, confirm_button)

        local function finishAttack()
            if press then
                press:remove()
                TableUtils.removeValue(enemy.dmg_sprites, press)
            end
            if confirm_button then
                confirm_button:remove()
                TableUtils.removeValue(enemy.dmg_sprites, confirm_button)
            end

            if punches > 0 then
                local new_damage = math.ceil(damage * (punches / self.attack_punches))
                if punches < self.attack_punches and new_damage <= 0 then
                    enemy:onDodge(battler, true)
                end
                self:onLightAttackHurt(battler, enemy, new_damage, stretch, crit)
            else
                self:onLightMiss(battler, enemy, true, nil, false)
                Game.battle:finishActionBy(battler)
            end
        end

        Game.battle.timer:during(self.attack_punch_time, function()
            press_timer = press_timer - 1 * DTMULT

            if press_timer < 0 then
                if press.visible == false and confirm_button.visible == false then
                    press_timer = 6
                    press.visible = true
                    confirm_button.visible = true
                else
                    press.visible = false
                    confirm_button.visible = false
                    press_timer = 3
                end
            end

            if Input.pressed("confirm") and state ~= "DONE" then

                if state == "PRESS" then
                    enemy.parent:addChild(press)
                    enemy.parent:addChild(confirm_button)
                    state = "PUNCHING"
                elseif state == "PUNCHING" then

                    punches = punches + 1

                    if punches < self.attack_punches then
                        if press then
                            press:remove()
                            TableUtils.removeValue(enemy.dmg_sprites, press)
                        end
                        if confirm_button then
                            confirm_button:remove()
                            TableUtils.removeValue(enemy.dmg_sprites, confirm_button)
                        end
                        
                        self:startLightAttackAnimation(battler, enemy, damage, stretch, crit, {sprite = "effects/lightattack/regfist", sound = "punchweak", color = true,
                          position = {enemy:getRelativePos((love.math.random(enemy.width)), (love.math.random(enemy.height)))}, shake = true, speed = 2/30, scale = 1, trigger_dodge = false})
                    else
                        state = "DONE"
                        
                        self:startLightAttackAnimation(battler, enemy, damage, stretch, crit, {sprite = "effects/lightattack/hyperfist", color = true,
                          shake = true, speed = 2/30, scale = 1, battle_shake = true})
                        
                        Game.battle.timer:after(10/30, function()
                            finishAttack()
                        end)
                    end

                end
            end
        end,
        
        function()
            if state ~= "DONE" then
                finishAttack()
                state = "DONE" 
            end
        end)
    end
    
    return false
end

return item