---@class ActionButton : Object
---@overload fun(...) : ActionButton
local ActionButton, super = HookSystem.hookScript(ActionButton)

function ActionButton:select()

    super.select(self)

    if self.type == "magic" then
        Game.battle:clearMenuItems()

        -- First, register X-Actions as menu items.

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
                ["color"] = {self.battler.chara:getXActColor()},
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
                    ["tp"] = action.tp or 0,
                    ["resource"] = action.resource or "tension"
                }

                Game.battle:addMenuItem({
                    ["name"] = action.name,
                    ["tp"] = action.tp or 0,
                    ["resource"] = action.resource or "tension",
                    ["description"] = action.description,
                    ["color"] = action.color or {1, 1, 1, 1},
                    ["data"] = spell,
                    ["callback"] = function(menu_item)
                        Game.battle.selected_xaction = spell
                        Game.battle:setState("ENEMYSELECT", "XACT")
                    end
                })
            end
        end

        -- Now, register SPELLs as menu items.
        for _,spell in ipairs(self.battler.chara:getSpells()) do
            ---@type table|function
            local color = spell.color or {1, 1, 1, 1}
            if spell:hasTag("spare_tired") then
                local has_tired = false
                for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                    if enemy.tired then
                        has_tired = true
                        break
                    end
                end
                if has_tired then
                    color = {0, 178/255, 1, 1}
                    if Game:getConfig("pacifyGlow") then
                        color = function ()
                            return Utils.mergeColor({0, 0.7, 1, 1}, COLORS.white, 0.5 + math.sin(Game.battle.pacify_glow_timer / 4) * 0.5)
                        end
                    end
                end
            end
            --print(spell:getResourceType(self.battler.chara))
            Game.battle:addMenuItem({
                ["name"] = spell:getName(),
                ["tp"] = spell:getTPCost(self.battler.chara),
                ["mp"] = spell:getMPCost(self.battler.chara),
                ["resource"] = spell:getResourceType(self.battler.chara),
                --["stock"] = spell:getStock(self.battler.chara),
                --["stock_limit"] = spell:getStockLimit(self.battler.chara),
                ["hp"] = spell:getHPCost(self.battler.chara),
                ["unusable"] = not spell:isUsable(self.battler.chara),
                ["description"] = spell:getBattleDescription(),
                ["party"] = spell.party,
                ["color"] = color,
                ["data"] = spell,
                ["callback"] = function(menu_item)
                    Game.battle.selected_spell = menu_item

                    if not spell:getTarget() or spell:getTarget() == "none" then
                        Game.battle:pushAction("SPELL", nil, menu_item)
                    elseif spell:getTarget() == "ally" then
                        Game.battle:setState("PARTYSELECT", "SPELL")
                    elseif spell:getTarget() == "enemy" then
                        Game.battle:setState("ENEMYSELECT", "SPELL")
                    elseif spell:getTarget() == "party" then
                        Game.battle:pushAction("SPELL", Game.battle.party, menu_item)
                    elseif spell:getTarget() == "enemies" then
                        Game.battle:pushAction("SPELL", Game.battle:getActiveEnemies(), menu_item)
                    end
                end
            })
        end
        Game.battle:setState("MENUSELECT", "SPELL")
    end
end

return ActionButton
