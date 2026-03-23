local EyeBeam, super = Class(Wave)

function EyeBeam:init()
    super.init(self)

    self.time = -1

    self.voidspawn = self:getAttackers()
    for index, voidspawn in ipairs(self.voidspawn) do
        voidspawn.sprite:setEyeState("FOLLOWING")
        voidspawn.siner_active = false
        voidspawn.layer = BATTLE_LAYERS["above_arena"]
        if index == 1 then
            self.og_posx_1 = voidspawn.x
            self.og_posy_1 = voidspawn.y
        elseif index == 2 then
            self.og_posx_2 = voidspawn.x
            self.og_posy_2 = voidspawn.y
        end
    end

    self.wavetimer = 0

    self.state = "AIMING" -- AIMING, RAMMING, RETURNING
end

function EyeBeam:onStart()
    Game.battle:swapSoul(FlashlightSoul())
    
    for index, voidspawn in ipairs(self.voidspawn) do
        local x, y = voidspawn:getRelativePos(voidspawn.width/2, voidspawn.height/2)
        if index == 1 then
            self.hitbox_1 = self:spawnBullet("voidspawn/ram_hitbox", x, y, voidspawn)
        elseif index == 2 then
            self.hitbox_2 = self:spawnBullet("voidspawn/ram_hitbox", x, y, voidspawn)
        end
    end
end

function EyeBeam:onEnd()
    super.onEnd(self)

    for _, voidspawn in ipairs(self.voidspawn) do
        voidspawn.sprite:setEyeState("SET", voidspawn.x - 10, voidspawn.y + 30)
        voidspawn.layer = BATTLE_LAYERS["battlers"]
    end
end

function EyeBeam:update()
    for index, voidspawn in ipairs(self.voidspawn) do
        if index == 1 then
            if self.state == "AIMING" then
                voidspawn.x = MathUtils.lerp(voidspawn.x, Game.battle.arena.right + 70, 0.1)
                voidspawn.y = MathUtils.lerp(voidspawn.y, Game.battle.soul.y, 0.1)
            end
        end
    end

    self.wavetimer = self.wavetimer + DT
    if self.wavetimer > 2 and self.state == "AIMING" then
        self.state = "RAMMING"
        for index, voidspawn in ipairs(self.voidspawn) do
            if index == 1 then
                Assets.playSound("back_attack", 1.2, 0.75)
                Assets.playSound("back_attack", 0.8, 0.6)
                Assets.playSound("bump", 4, 0.5)
                Game.stage.timer:tween(0.5, voidspawn, {x = Game.battle.arena.right + 100}, "out-cubic", function()
                    Assets.playSound("cardrive", 1, 0.95)
                    Assets.playSound("spearrise", 1, 0.3)
                    Game.battle.timer:every(1/5, function()
                        if voidspawn.x < Game.battle.arena.right + 50 then
                            Assets.playSound("dark_odd", 1.6, 1.2)
                            local x, y = voidspawn:getRelativePos(voidspawn.width/2, voidspawn.height/2)
                            local bullet1 = self:spawnBullet("voidspawn/rambullet", x, y, math.rad(90), 0.1)
                            local bullet2 = self:spawnBullet("voidspawn/rambullet", x, y, math.rad(270), 0.1)
                            bullet1.layer = voidspawn.layer - 1
                            bullet1.physics.friction = -0.25
                            bullet2.layer = voidspawn.layer - 1
                            bullet2.physics.friction = -0.25
                        end
                        if self.state == "RETURNING" then
                            return false
                        end
                    end)
                    Game.stage.timer:tween(4, voidspawn, {x = -500}, "in-cubic", function()
                        self.state = "RETURNING"
                        voidspawn.x = SCREEN_WIDTH + 100
                        Game.stage.timer:tween(1, voidspawn, {x = self.og_posx_1, y = self.og_posy_1}, "linear", function()
                            voidspawn.siner_active = true
                            Game.stage.timer:after(1, function()
                                self:setFinished()
                            end)
                        end)
                    end)
                end)
            end
        end
    end

    super.update(self)
end

return EyeBeam