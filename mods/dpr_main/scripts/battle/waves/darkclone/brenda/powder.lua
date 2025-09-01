local Powder, super = Class(Wave)

function Powder:init()
    super.init(self)
    self.time = -1
end

function Powder:onStart()
    local powder = self:spawnBullet("darkclone/brenda/powder", (Game.battle.arena.left + Game.battle.arena.right)/2, (Game.battle.arena.top + Game.battle.arena.bottom)/2, 0, 0)

    Game.battle.timer:after(2, function()
        local brenda = Game.battle:getPartyBattler("brenda")
        brenda.powder = true
        brenda:addFX(ColorMaskFX({0,0,0}, 0.5), "powder_fx")
        brenda:shake(10)
        Assets.playSound("damage")
        powder.state = "FADEOUT"
        Game.battle.timer:after(2, function()
            local attacker = Game.battle.enemies[1]
            local index = nil
            for i, v in ipairs(attacker.waves) do
                if v == "darkclone/brenda/powder" then
                    index = i
                end
            end
            table.remove(attacker.waves, index)
            self.finished = true
        end)
    end)
end

function Powder:update()
    super.update(self)
end

return Powder