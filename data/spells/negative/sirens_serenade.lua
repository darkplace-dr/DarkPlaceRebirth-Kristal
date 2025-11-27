local spell, super = Class(Spell, "sirens_serenade")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Sirens Serenade"
    self.cast_name = nil

    self.effect = "Damage\nw/ STAR"
    self.description = "Deals magical Star damage to\none enemy."
    self.check = "Deals magical star damage to one enemy."

    -- TP cost
    self.cost = 16

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"spare_tired"}

    self.sleep = {["dummy"] = true}
end
--function spell:getCastMessage(user, target) return "" end

function spell:getCastMessageF(user, target)
    local message = super.getCastMessage(self, user, target)
    if target.tired or target.mercy < 100 then
        return message
    else
        return "[instant]"..message.."\n[wait:0.25s]* But the foe wasn't [color:blue]TIRED[color:reset]...[wait:10]* The foe was [color:yellow]SPARED[color:reset] anyway."
    end
end

function spell:onCast(user, target)
    Game.battle.music:pause()
    Assets.playSound("sirens_serenade")
    self:serenade(user, target)
    return false
end

function spell:onStart(user, target)
    --Game.battle:battleText(self:getCastMessage(user, target))
    self.og_alpha = Game.battle.transition_timer
    user:setAnimation("battle/a", function()
        self:onCast(user, target)
    end)
    Game.battle.transition_timer = 0
end


function spell:serenade(user, target)

    local mess = "[voice:none]"..self:getCastMessage(user, target)
    local alt = "\n* But the foe wasn't [color:blue]TIRED[color:reset]..."
    local spar = "\n* The foe was [color:yellow]SPARED[color:reset] anyway."
    --Game.battle:battleText(mess)
    local txt = Game.battle.battle_ui.encounter_text
    txt:setText("[noskip]"..mess)

Game.battle.timer:after(5.5, function()
    if target.tired then
        local pacify_x, pacify_y = target:getRelativePos(target.width/2, target.height/2)
        local z_count = 0
        local z_parent = target.parent
        target:spare(true)
        Game.battle.timer:every(1/15, function()
            z_count = z_count + 1
            local z = SpareZ(z_count * -40, pacify_x, pacify_y)
            z.layer = target.layer + 0.002
            z_parent:addChild(z)
        end, 8)
    elseif target.mercy >= 100 then

        Game.battle.timer:after(3, function()
            Game.battle.music:resume()
            Game.battle:finishActionBy(user)
        end)
    elseif self.sleep[target.id] then
        target:setTired(true)
        txt:setText("[noskip][instant]"..mess.."[stopinstant]\n* The foe became [color:blue]TIRED[color:reset]...")
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
        txt:setText("[noskip][instant]"..mess.."[stopinstant]"..alt)
    end
end)

    if target.tired or (target.mercy < 100) or (self.sleep[target.id]) then
        Game.battle.timer:after(7, function()
            Game.battle:battleText("")
            txt:advance()

            Game.battle.music:resume()
            Game.battle:finishActionBy(user)
            Game.battle:clearActionIcon(user)
            user:setAnimation("battle/idle")
            Game.battle.transition_timer = self.og_alpha
        end)
    end


end

return spell