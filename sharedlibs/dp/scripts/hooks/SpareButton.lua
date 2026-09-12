local SpareButton, super = HookSystem.hookScript(SpareButton)

function SpareButton:select()
    if self.battler == Game.battle.party[1] then
        self:spare_menu()

		local party = {}
        for k, chara in ipairs(Game.party) do
            if k < 4 then table.insert(party, chara.id) end
        end

        Game.battle:addMenuItem({
            ["name"] = "Flee",
            ["unusable"] = not Game.battle.encounter.flee,
            ["description"] = Game.battle.encounter.flee and "" or "Can't\nEscape",
            ["party"] = Game.battle.encounter.flee and party or {},
            ["callback"] = function(menu_item)
                if (MathUtils.randomInt(1, 101) < Game.battle.encounter.flee_chance) then
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
end

function SpareButton:spare_menu()
    Game.battle:clearMenuItems()
    local sparable = false
    for k, v in pairs(Game.battle:getActiveEnemies()) do
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

return SpareButton