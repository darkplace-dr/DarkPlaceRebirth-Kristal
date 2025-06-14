---@class Wave : Wave
local Wave, super = Utils.hookScript(Wave)

function Wave:onArenaEnter()
    super.onArenaEnter(self)

    -- Ceroba's shield on turn start
    if Game.battle:getPartyBattler("ceroba") then
        if not Game.battle.no_buff_loop then
            Game.battle.no_buff_loop = true
            self.timer:after(1/30, function()
                local diamond = Sprite("effects/spells/ceroba/diamond")
                diamond:setOrigin(0.5, 0.5)
                diamond:setColor(Game:getSoulColor())
                diamond:setScale(2, 2)
                diamond.layer = Game.battle.soul.layer + 1
                Assets.playSound("trap")
                diamond:play(1/15, false, function(s) s:fadeOutAndRemove(0.5) end)
                diamond:setParent(Game.battle.soul)
                self.timer:after(0.46, function()
                    Assets.playSound("equip_armor")
                    Game:getSoulPartyMember().pp = 1
                end)
            end)
        end
    end
end

return Wave