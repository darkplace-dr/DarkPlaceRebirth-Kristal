local LightActionButton, super = Class(Object)

function LightActionButton:init(type, battler, x, y)
    super.init(self, x, y)

    self.type = type
    self.battler = battler
    
    self.texture = Assets.getTexture("ui/lightbattle/btn/" .. type)
    self.hover_texture = Assets.getTexture("ui/lightbattle/btn/" .. type .. "_h")
    self.special_texture = Assets.getTexture("ui/lightbattle/btn/" .. type .. "_a")
    self.disabled_texture = Assets.getTexture("ui/lightbattle/btn/" .. type .. "_d")

    self.width = self.texture:getWidth()
    self.height = self.texture:getHeight()

    self:setOriginExact(self.width / 2, 13)

    self.hovered = false
    self.selectable = true
    self.disabled = false
end

function LightActionButton:registerXActions()
    if Game.battle.encounter.default_xactions and self.battler.chara:hasXAct() then
        local spell = {
            ["name"] = Game.battle.enemies[1]:getXAction(self.battler),
            ["target"] = "xact",
            ["id"] = 0,
            ["default"] = true,
            ["party"] = {},
            ["tp"] = 0
        }

        Game.battle:addMenuItem({
            ["name"] = self.battler.chara:getXActName() or "X-Action",
            ["tp"] = 0,
            ["color"] = { self.battler.chara:getLightXActColor() },
            ["data"] = spell,
            ["callback"] = function(menu_item)
                Game.battle.selected_xaction = spell
                Game.battle:setState("ENEMYSELECT", "XACT")
            end
        })
    end

    for id, action in ipairs(Game.battle.xactions) do
        if action.party == self.battler.chara.id then
            local spell = {
                ["name"] = action.name,
                ["target"] = "xact",
                ["id"] = id,
                ["default"] = false,
                ["party"] = {},
                ["tp"] = action.tp or 0
            }

            Game.battle:addMenuItem({
                ["name"] = action.name,
                ["tp"] = action.tp or 0,
                ["description"] = action.description,
                ["color"] = action.color or { 1, 1, 1, 1 },
                ["data"] = spell,
                ["callback"] = function(menu_item)
                    Game.battle.selected_xaction = spell
                    Game.battle:setState("ENEMYSELECT", "XACT")
                end
            })
        end
    end
end

function LightActionButton:registerSpells()
    for _, spell in ipairs(self.battler.chara:getSpells()) do
        local color = spell.color or { 1, 1, 1, 1 }
        if spell:hasTag("spare_tired") then
            local has_tired = false
            for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy.tired then
                    has_tired = true
                    break
                end
            end
            if has_tired then
                color = { 0, 178 / 255, 1, 1 }
            end
        end
        Game.battle:addMenuItem({
            ["name"] = spell:getName(),
            ["tp"] = spell:getTPCost(self.battler.chara),
            ["unusable"] = not spell:isUsable(self.battler.chara),
            ["description"] = spell:getBattleDescription(),
            ["party"] = spell.party,
            ["color"] = color,
            ["data"] = spell,
            ["callback"] = function(menu_item)
                Game.battle.selected_spell = menu_item

                if not spell.target or spell.target == "none" then
                    Game.battle:pushAction("SPELL", nil, menu_item)
                elseif spell.target == "ally" and not Game.battle.multi_mode then
                    Game.battle:pushAction("SPELL", Game.battle.party[1], menu_item)
                elseif spell.target == "ally" then
                    Game.battle:setState("PARTYSELECT", "SPELL")
                elseif spell.target == "enemy" then
                    Game.battle:setState("ENEMYSELECT", "SPELL")
                elseif spell.target == "party" then
                    Game.battle:pushAction("SPELL", Game.battle.party, menu_item)
                elseif spell.target == "enemies" then
                    Game.battle:pushAction("SPELL", Game.battle:getActiveEnemies(), menu_item)
                end
            end
        })
    end
end

function LightActionButton:onMagicSelect()
    Game.battle:clearMenuItems()
    Game.battle.current_menu_columns = 2
    Game.battle.current_menu_rows = 3

    self:registerXActions()
    self:registerSpells()

    Game.battle:setState("MENUSELECT", "SPELL")
end

function LightActionButton:onItemSelect()
    Game.battle:clearMenuItems()
    Game.battle.current_menu_columns = 2
    Game.battle.current_menu_rows = 2
    for i, item in ipairs(Game.inventory:getStorage("items")) do
        Game.battle:addMenuItem({
            ["name"] = item:getName(),
            ["shortname"] = item:getShortName(),
            ["seriousname"] = item:getSeriousName(),
            ["unusable"] = item.usable_in ~= "all" and item.usable_in ~= "battle",
            ["description"] = item:getBattleDescription(),
            ["data"] = item,
            ["callback"] = function(menu_item)
                Game.battle.selected_item = menu_item

                if not item.target or item.target == "none" then
                    Game.battle:pushAction("ITEM", nil, menu_item)
                elseif item.target == "ally" and not Game.battle.multi_mode then
                    Game.battle:pushAction("ITEM", Game.battle.party[1], menu_item)
                elseif item.target == "ally" then
                    Game.battle:setState("PARTYSELECT", "ITEM")
                elseif item.target == "enemy" then
                    Game.battle:setState("ENEMYSELECT", "ITEM")
                elseif item.target == "party" then
                    Game.battle:pushAction("ITEM", Game.battle.party, menu_item)
                elseif item.target == "enemies" then
                    Game.battle:pushAction("ITEM", Game.battle:getActiveEnemies(), menu_item)
                end
            end
        })
    end
    if #Game.battle.menu_items > 0 then
        Game.battle:setState("MENUSELECT", "ITEM")
    end
end

function LightActionButton:onMercySelect()
    Game.battle:clearMenuItems()
    Game.battle.current_menu_columns = 1
    Game.battle.current_menu_rows = 3
    Game.battle:addMenuItem({
        ["name"] = "Spare",
        ["special"] = "spare",
        ["callback"] = function(menu_item)
            if Kristal.getLibConfig("magical-glass", "multi_deltarune_spare") and Game.battle.multi_mode or self.battler.manual_spare then
                self.battler.manual_spare = true
                Game.battle:setState("ENEMYSELECT", "SPARE")
            else
                Game.battle:pushAction("SPARE", Game.battle:getActiveEnemies())
            end
        end
    })
    if Game.battle.encounter:canDefendFromMercy(self.battler) then
        Game.battle:addMenuItem({
            ["name"] = "Defend",
            ["special"] = "defend",
            ["callback"] = function(menu_item)
                Game.battle:pushAction("DEFEND", nil, {tp = -Game.battle:getDefendTension(self.battler)})
            end
        })
    end
    if Game.battle.encounter:canFlee() then
        local battle_leader
        for i, battler in ipairs(Game.battle.party) do
            if not battler.is_down and not battler.sleeping and not (Game.battle:getActionBy(battler) and Game.battle:getActionBy(battler).action == "AUTOATTACK") then
                battle_leader = battler.chara.id
                break
            end
        end
        Game.battle:addMenuItem({
            ["name"] = "Flee",
            ["special"] = "flee",
            ["unusable"] = Game.battle:getPartyIndex(battle_leader) ~= Game.battle.current_selecting,
            ["callback"] = function(menu, item)
                local chance = Game.battle.encounter.flee_chance

                for _, party in ipairs(Game.battle.party) do
                    for _, equip in ipairs(party.chara:getEquipment()) do
                        chance = chance + ((equip:getFleeBonus() / #Game.battle.party) or 0)
                    end
                end
                
                chance = math.floor(chance)

                if chance >= MathUtils.round(MathUtils.random(1, 100)) then
                    Game.battle:setState("FLEEING")
                else
                    Game.battle.ui_select:stop()
                    Game.battle.ui_select:play()
                    Game.battle:setState("FLEEFAIL")
                end
            end
        })
    end
    Game.battle:setState("MENUSELECT", "MERCY")
end

function LightActionButton:select()
    Game.battle.current_menu_columns = nil
    Game.battle.current_menu_rows = nil

    if Game.battle.encounter:onActionSelect(self.battler, self) then return end
    if Kristal.callEvent(MG_EVENT.onLightActionSelect, self.battler, self) then return end
    if self.type == "fight" then
        Game.battle:setState("ENEMYSELECT", "ATTACK")
    elseif self.type == "act" or self.type == "save" then
        Game.battle:setState("ENEMYSELECT", "ACT")
    elseif self.type == "magic" then
        self:onMagicSelect()
    elseif self.type == "item" then
        self:onItemSelect()
    elseif self.type == "mercy" then
        self:onMercySelect()
    elseif self.type == "spare" then
        self.battler.manual_spare = true
        Game.battle:setState("ENEMYSELECT", "SPARE")
    elseif self.type == "defend" then
        Game.battle:pushAction("DEFEND", nil, { tp = -Game.battle:getDefendTension(self.battler) })
    end
end

function LightActionButton:unselect()
    self.battler.manual_spare = false
end

function LightActionButton:hasSpecial()
    if Kristal.getLibConfig("magical-glass", "highlight_default_buttons") then
        if self.type == "magic" then
            if self.battler then
                local has_tired = false
                for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
                    if enemy.tired then
                        has_tired = true
                        break
                    end
                end
                if has_tired then
                    local has_pacify = false
                    for _, spell in ipairs(self.battler.chara:getSpells()) do
                        if spell and spell:hasTag("spare_tired") then
                            if spell:isUsable(self.battler.chara) and spell:getTPCost(self.battler.chara) <= Game:getTension() then
                                has_pacify = true
                                break
                            end
                        end
                    end
                    return has_pacify
                end
            end
        elseif self.type == "spare" or self.type == "mercy" then
            for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy.mercy >= 100 then
                    return true
                end
            end
        end
    end
    return false
end

function LightActionButton:draw()
    if self.disabled then
        Draw.draw(self.disabled_texture or self.texture)
    elseif self.selectable and self.hovered then
        Draw.draw(self.hover_texture or self.texture)
    else
        Draw.draw(self.texture)
        if self.selectable and self.special_texture and self:hasSpecial() then
            local r, g, b, a = self:getDrawColor()
            Draw.setColor(r, g, b, a * (0.4 + math.sin((Kristal.getTime() * 30) / 6) * 0.4))
            Draw.draw(self.special_texture)
        end
    end

    super.draw(self)
end

return LightActionButton
