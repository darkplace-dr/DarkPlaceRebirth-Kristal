local LightActionButton, super = Class(Object, "LightActionButton")

function LightActionButton:init(x, y, type, battler)
    super.init(self, x, y)

    self.type = type
    self.battler = battler

    self.tex = Assets.getTexture("ui/lightbattle/btn/" .. type)
    self.hover_tex = Assets.getTexture("ui/lightbattle/btn/" .. type .. "_h")
    self.special_tex = Assets.getTexture("ui/lightbattle/btn/" .. type .. "_a")

    self.cant_select_tex = Assets.getTexture("ui/lightbattle/btn/" .. type .. "_x")
    self.cant_select_hover_tex = Assets.getTexture("ui/lightbattle/btn/" .. type .. "_hx")

    self.width = self.tex:getWidth()
    self.height = self.tex:getHeight()

    self:setOriginExact(self.width / 2, 13)

    self.hovered = false
    self.selectable = true

    self.allow_highlight = MagicalGlass:getConfig("lightBattleActionButtonFlash")
    self.allow_cant_select = MagicalGlass:getConfig("lightBattleActionButtonCantSelect")
end

function LightActionButton:select()
    if Kristal.callEvent(MagicalGlass.EVENT.onLightBattleActionButtonSelect, self.battler, self, self.selectable) then return end
    if Game.battle.encounter:onActionButtonSelect(self.battler, self, self.selectable) then return end

    if self.selectable then
        if self.type == "fight" then
            self:onFightSelected()
        elseif self.type == "act" then
            self:onActSelected()
        elseif self.type == "spell" then
            self:onSpellSelected()
        elseif self.type == "item" then
            self:onItemSelected()
        elseif self.type == "mercy" then
            self:onMercySelected()
        end
    end
end

function LightActionButton:onFightSelected()
    Game.battle:setState("ENEMYSELECT", "ATTACK")
end

function LightActionButton:onActSelected()
    Game.battle:setState("ENEMYSELECT", "ACT")
end

function LightActionButton:onSpellSelected()
    Game.battle:setState("MENUSELECT", "SPELL", {["user"] = self.battler})
end

function LightActionButton:onItemSelected()
    Game.battle:setState("MENUSELECT", "ITEM")
end

function LightActionButton:onMercySelected()
    Game.battle:setState("MENUSELECT", "MERCY")
end

function LightActionButton:hasSpecial()
    if self.allow_highlight then
        if self.type == "spell" then
            if self.battler then
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
                            has_pacify = true
                            break
                        end
                    end
                    return has_pacify
                end
            end
        elseif self.type == "mercy" then
            for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy.mercy >= 100 then
                    return true
                end
            end
        end
    end
    return false
end

function LightActionButton:draw()
    if self.hovered then
        if not self.selectable and self.allow_cant_select then
            love.graphics.draw(self.cant_select_hover_tex)
        else
            love.graphics.draw(self.hover_tex or self.tex)
        end
    else
        if not self.selectable and self.allow_cant_select then
            love.graphics.draw(self.cant_select_tex)
        else
            love.graphics.draw(self.tex)
        end
        if self.selectable and self.special_tex and self:hasSpecial() then
            local r, g, b, a = self:getDrawColor()
            love.graphics.setColor(r, g, b, a * (0.4 + math.sin((Kristal.getTime() * 30) / 6) * 0.4))
            love.graphics.draw(self.special_tex)
        end
    end

    super.draw(self)
end

return LightActionButton