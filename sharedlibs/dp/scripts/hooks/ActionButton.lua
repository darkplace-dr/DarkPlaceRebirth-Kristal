---@class ActionButton : ActionButton
local ActionButton, super = Utils.hookScript(ActionButton)

function ActionButton:select()
    if Game.battle.encounter:onActionSelect(self.battler, self) then return end
    if Kristal.callEvent(KRISTAL_EVENT.onActionSelect, self.battler, self) then return end
    if self.type == "item" then
        Game.battle:clearMenuItems()
        for i,item in ipairs(Game.inventory:getStorage("items")) do
            Game.battle:addMenuItem({
                ["name"] = item:getName(),
                ["unusable"] = item.usable_in ~= "all" and item.usable_in ~= "battle",
                ["description"] = item:getBattleDescription(),
                ["data"] = item,
                ["callback"] = function(menu_item)
                    Game.battle.selected_item = menu_item

                    if not item.target or item.target == "none" then
                        Game.battle:pushAction("ITEM", nil, menu_item)
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
        if Game.inventory:hasItem("oddstone") then
            local item = Game.inventory:getItemByID("oddstone")
            Game.battle:addMenuItem({
                ["name"] = item:getName(),
                ["unusable"] = item.usable_in ~= "all" and item.usable_in ~= "battle",
                ["description"] = item:getBattleDescription(),
                ["data"] = item,
                ["callback"] = function(menu_item)
                    Game.battle.selected_item = menu_item

                    if not item.target or item.target == "none" then
                        Game.battle:pushAction("ITEM", nil, menu_item)
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
    elseif self.type == "spare" then
        local battle_leader = 1
        if self.battler == Game.battle.party[battle_leader] then

            self:spare_menu()

            local party = {}
            local party_up = {}
            for k,chara in ipairs(Game.party) do
                if k < 4 and not Game.battle.party[k].is_down then
                    table.insert(party_up, chara.id)
                end
                if k < 4 then table.insert(party, chara.id) end
            end
            Game.battle:addMenuItem({
                ["name"] = "Flee",
                ["unusable"] = not Game.battle.encounter.flee,
                ["description"] = Game.battle.encounter.flee and "" or "Can't\nEscape",
                ["party"] = Game.battle.encounter.flee and party or {},
                ["callback"] = function(menu_item)
                    if (love.math.random(1,100) < Game.battle.encounter.flee_chance) then
                        Game.battle:setState("FLEE")
                    else
                        Game.battle:setState("ENEMYDIALOGUE", "FLEE")
                        Game.battle.current_selecting = 0
                    end
                end
            })
            Game.battle:setState("MENUSELECT", "SPARE")
        elseif Game.battle.back_row then

            self:spare_menu()

            Game.battle:setState("MENUSELECT", "SPARE")
        else
            Game.battle:setState("ENEMYSELECT", "SPARE")
        end
    elseif self.type == "skill" then
        Game.battle:clearMenuItems()

        for id, action in ipairs(self.battler.chara:getSkills()) do
            Game.battle:addMenuItem({
                ["name"] = action[1],
                ["description"] = action[2],
                ["color"] = action[3],
                ["callback"] = action[4]
            })
        end

        Game.battle:setState("MENUSELECT", "SKILL")
    elseif self.type == "tension" then
        Game.battle:pushAction("TENSION", nil, {tp = -Game.battle:getDefendTension(self.battler)*2})
    else
        return super.select(self)
    end
end

function ActionButton:hasSpecial()
    if self.battler and self.type == "skill" then
        local has_tired = false
        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy.tired then
                has_tired = true
                break
            end
        end
        if has_tired then
            local has_pacify = false
            for _,spell in ipairs(self.battler.chara:getSpells()) do
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
    return super.hasSpecial(self)
end

function ActionButton:spare_menu()
    Game.battle:clearMenuItems()
    local sparable = false
    for k,v in pairs(Game.battle:getActiveEnemies()) do
        if v.mercy >= 100 then
            sparable = true
            break
        end
    end
    Game.battle:addMenuItem({
        ["name"] = "Spare",
        ["unusable"] = false,
        ["description"] = "",
        ["color"] = sparable and {1, 1, 0, 1} or {1, 1, 1, 1},
        ["callback"] = function(menu_item)
            Game.battle:setState("ENEMYSELECT", "SPARE")
        end
    })

    if Game.battle.back_row then

    local par_t = Game.party
    local chr = Game.battle.back_row.chara
    local lol = true
    local party = {}
    if chr.can_lead == false and Game.battle.current_selecting == 1 then lol = false end 
    if chr.health <= 0 then lol = false end

    if lol == false then
        party[1] = chr.id
    end

        local data = {}
        data.data = {}
        data.data.number = Game.battle.current_selecting
        print(data.data.number)
        Game.battle:addMenuItem({
            ["name"] = "Swap",
            ["unusable"] = not lol,
            ["description"] = "Swap\nParty\nMember",
            ["party"] = party,
            ["callback"] = function(menu_item)
                --Game.party[4].act_num = Game.battle.current_selecting
                Game.battle:pushAction("SWAP", nil, data)
            end
        })
    end

end

return ActionButton