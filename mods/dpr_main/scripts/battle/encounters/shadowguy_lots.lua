local ShadowguyLots, super = Class(Encounter)

function ShadowguyLots:init()
    super.init(self)

    self.text = "* Holy FUCK"

    self.first_guy = self:addEnemy("shadowguy")
    self.first_guy.money = 69

    for i = 1, 500 do
        self:addEnemy("shadowguy", Utils.random(SCREEN_WIDTH/2) + SCREEN_WIDTH + 80, Utils.random(SCREEN_HEIGHT))
    end

    self.done_stupid_thing = false

    self.background = true
    self.music = "battle"
end

function ShadowguyLots:getNextWaves()
    for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
        enemy.selected_wave = "tommygun_lots"
    end
    return {"tommygun_lots"}
end

function ShadowguyLots:beforeStateChange(old, new)
    if old == "INTRO" and new ~= "INTRO" and not self.done_stupid_thing then
        self.done_stupid_thing = true

        Game.battle:setState("NONE")

        for _,battler in ipairs(Game.battle.party) do
            battler:setAnimation("battle/idle")
        end

        local src = Assets.playSound("rumble")
        src:setLooping(true)
        src:setVolume(0.75)
        local src2

        local timer = 0
        local stage = 0

        Game.battle:shakeCamera(5, 5, 0)

        Game.battle.timer:every(1/30, function()
            timer = timer + 1
            if stage == 0 and timer >= 60 then
                stage = 1
                timer = 0

                src2 = Assets.playSound("rumble")
                src2:setLooping(true)
                src2:setPitch(1.5)

                for _,enemy in ipairs(Game.battle.enemies) do
                    if enemy ~= self.first_guy then
                        local x = enemy.x
                        Game.battle.timer:tween(1, enemy, {x = x - SCREEN_WIDTH/2 - 80})
                    end
                end
            elseif stage == 1 and timer >= 30 then
                stage = 2
                timer = 0
                Game.battle:shakeCamera(0)
                src:stop()
                src2:stop()
            elseif stage == 2 and timer >= 15 then
                Game.battle:setState("ACTIONSELECT")
                return false
            end
        end)
    end
end

return ShadowguyLots