Utils.hook(Registry.getSpell("rude_buster"), "onLightBattleCast", function(orig, self, user, target)
    Assets.playSound("rudebuster_swing")
    local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
    local beam = LightRudeBuster(false, tx, ty, function(pressed)
        local damage = self:getDamage(user, target, pressed)
        if pressed then
            Assets.playSound("scytheburst")
        end
        target:hurt(damage, user)
        Game.battle:finishActionBy(user)
    end)
    beam.layer = BATTLE_LAYERS["above_ui"]
    Game.battle:addChild(beam)
    return false
end)