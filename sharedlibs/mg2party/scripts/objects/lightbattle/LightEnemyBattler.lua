local LightEnemyBattler, super = Class("LightEnemyBattler", true)

function LightEnemyBattler:hurt(amount, battler, on_defeat, options)
    options = options or {}
    if amount <= 0 then
        if attacked then self.hurt_timer = 1 end
        if not options["show_status"] then
            self:lightStatusMessage("msg", "miss", {color = options["color"] or battler.chara.color or COLORS.red, dont_animate = not options["attacked"]})
        end
        self:onDodge(battler, options["attacked"])
        return
    end

    if not options["show_status"] then
        self:lightStatusMessage("damage", amount, {color = battler.chara.color})
    end

    self.health = self.health - amount

    if amount > 0 then
        self.hurt_timer = 1
        self:onHurt(amount, battler)
    end

    self:checkHealth(on_defeat, amount, battler)
end

return LightEnemyBattler