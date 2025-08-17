local LightActionButton, super = Class(Object)

function LightActionButton:init(type, battler, x, y)
    super.init(self, x, y)

    self.type = type
    self.battler = battler
    
    self.tex = Assets.getTexture("ui/lightbattle/btn/" .. type)
    self.hover_tex = Assets.getTexture("ui/lightbattle/btn/" .. type .. "_h")
    
    -- Used to restore the save button back to the act button
    self.tex_og = self.tex
    self.hover_tex_og = self.hover_tex
    self.rainbow = false

    self.width = self.tex:getWidth()
    self.height = self.tex:getHeight()

    self:setOriginExact(self.width / 2, 13)

    self.hovered = false
    self.selectable = true
end

function LightActionButton:select()
    Game.battle.current_menu_columns = nil
    Game.battle.current_menu_rows = nil

    if Game.battle.encounter:onActionSelect(self.battler, self) then return end
    if Kristal.callEvent(MG_EVENT.onLightActionSelect, self.battler, self) then return end

    if self.type == "fight" then
        Game.battle:setState("ENEMYSELECT", "ATTACK")
    elseif self.type == "act" then
        Game.battle:setState("ENEMYSELECT", "ACT")
    elseif self.type == "magic" then
        Game.battle:clearMenuItems()
        Game.battle.current_menu_columns = 2
        Game.battle.current_menu_rows = 3

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

        -- Now, register SPELLs as menu items.
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

        if #Game.battle.menu_items > 0 then
            Game.battle:setState("MENUSELECT", "SPELL")
        end
    elseif self.type == "item" then
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
    elseif self.type == "mercy" then
        Game.battle:clearMenuItems()
        Game.battle.current_menu_columns = 1
        Game.battle.current_menu_rows = 3
        Game.battle:addMenuItem({
            ["name"] = "Spare",
            ["special"] = "spare",
            ["callback"] = function(menu_item)
                if Kristal.getLibConfig("magical-glass", "multi_deltarune_spare") and Game.battle.multi_mode then
                    self.battler.manual_spare = true
                    Game.battle:setState("ENEMYSELECT", "SPARE")
                else
                    Game.battle:pushAction("SPARE", Game.battle:getActiveEnemies())
                end
            end
        })
        if Kristal.getLibConfig("magical-glass", "light_battle_tp") or not Game:isLight() then
            Game.battle:addMenuItem({
                ["name"] = "Defend",
                ["special"] = "defend",
                ["callback"] = function(menu_item)
                    Game.battle:pushAction("DEFEND", nil, {tp = -Game.battle:getDefendTension(self.battler)})
                end
            })
        end
        if Game.battle.encounter.can_flee then
            local battle_leader
            for i,battler in ipairs(Game.battle.party) do
                if not battler.is_down and not battler.sleeping and not (Game.battle:getActionBy(battler) and Game.battle:getActionBy(battler).action == "AUTOATTACK")then
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

                    for _,party in ipairs(Game.battle.party) do
                        for _,equip in ipairs(party.chara:getEquipment()) do
                            chance = chance + (equip.getFleeBonus and equip:getFleeBonus() / #Game.battle.party or 0)
                        end
                    end
                    
                    chance = math.floor(chance)

                    if chance >= Utils.random(1, 100, 1) then
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
    elseif self.type == "spare" then
        self.battler.manual_spare = true
        Game.battle:setState("ENEMYSELECT", "SPARE")
    elseif self.type == "defend" then
        Game.battle:pushAction("DEFEND", nil, {tp = -Game.battle:getDefendTension(self.battler)})
    end
end

function LightActionButton:unselect()
    self.battler.manual_spare = false
end

function LightActionButton:draw()
    if self.selectable and self.hovered then
        love.graphics.draw(self.hover_tex or self.tex)
    else
        love.graphics.draw(self.tex)
    end
    
    if self.rainbow then
        self:setColor(Utils.hslToRgb(Kristal.getTime() / 0.75 % 1, 1, 0.69))
    end

    super.draw(self)
end

return LightActionButton
