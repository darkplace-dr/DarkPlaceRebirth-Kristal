local spell, super = Class(Spell, "half-cify")

function spell:init()
    super.init(self)

    self.name = "Half-cify"

    self.cast_name = nil

    self.effect = "50%\nSpare\nTIRED foe"

    self.description = "SPARE a tired enemy by putting them to sleep.\nOnly effective when used twice on the enemy."

    self.cost = 0

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"
    self.tags = {"spare_tired"}
end

function spell:getCastMessage(user, target)
    local message = super.getCastMessage(self, user, target)
    if target.tired then
        if target.half_pacify == true then
            return message
        else
            return message.."\n* [color:blue]Pacify[color:reset] level is now at [color:blue]50%[color:reset]!"
        end
    elseif target.mercy < 100 then
        return message.."\n[wait:0.25s]* But the enemy wasn't [color:blue]TIRED[color:reset]..."
    else
        return message.."\n[wait:0.25s]* But the foe wasn't [color:blue]TIRED[color:reset]... try\n[color:yellow]SPARING[color:reset]!"
    end
end

function spell:onCast(user, target)
    if target.tired then
        if target.half_pacify == true then
            Assets.playSound("spell_pacify")

            target:spare(true)

            local pacify_x, pacify_y = target:getRelativePos(target.width/2, target.height/2)
            local z_count = 0
            local z_parent = target.parent
            Game.battle.timer:every(1/15, function()
                z_count = z_count + 1
                local z = SpareZ(z_count * -40, pacify_x, pacify_y)
                z.layer = target.layer + 0.002
                z_parent:addChild(z)
            end, 8)
        else
            if Game:isLight() then
                target:lightStatusMessage("text", "+50%", {0, 178/255, 1, 1})
            else
                target:statusMessage("msg", "half-cify")
            end
            Assets.playSound("spell_pacify", 1, 2)
            target.half_pacify = true
        end
    else
        local recolor = target:addFX(RecolorFX())
        Game.battle.timer:during(8/30, function()
            recolor.color = ColorUtils.mergeColor(recolor.color, {0, 0, 1}, 0.12 * DTMULT)
        end, function()
            Game.battle.timer:during(8/30, function()
                recolor.color = ColorUtils.mergeColor(recolor.color, {1, 1, 1}, 0.16 * DTMULT)
            end, function()
                target:removeFX(recolor)
            end)
        end)
    end
end

return spell