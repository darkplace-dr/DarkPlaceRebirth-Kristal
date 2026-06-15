---@diagnostic disable: undefined-field
local PillarHarmony, super = Class(Bullet)

-- scr_bullet_init();
-- spin = 0;
-- spinspeed = 0;
-- image_alpha = 1;
-- if (!instance_exists(obj_heart))
-- {
--     instance_destroy();
-- }
-- wall_destroy = 1;
-- bottomfade = 0;
-- green = 0;
-- highlight = 0;
-- greentimer = 0;
-- parentid = -4;
-- playpianosfx = 0;
-- touchingplayer = 0;
-- particletimer = 0;
-- chorus = 0;
-- grazepoints = 10;
-- with (obj_growtangle)
-- {
--     other.depth = depth - 2;
-- }

function PillarHarmony:init(x, y, green)
    super.init(self, x, y, "battle/bullets/organikk/bar")
    self.sprite:play(1/30)

    self.wall_destroy = 1
    self.bottom_fade = 0
    self.green = green or false
    self.highlight = nil
    self.green_timer = 0
    -- self.parent_id = -4
    self.play_piano_sfx = false
    self.touching_player = 0
    self.particle_timer = 0
    self.chorus = false
    self.tp = 4

    self:setScale(0, 2)
    self.destroy_on_hit = false
    -- self.active = false
    self:setHitbox(self.width / 4, self.height / 8, self.width / 2, 6 * self.height / 8)
    self.collidable = false
    -- self:addFX(RecolorFX(COLORS.gray))
    self:setColor(COLORS.gray)
    self.damage = 56
    self.sprite.anim_speed = 0
    self.vm = 1
    self.charge_sfx = nil
    self.layer = 400

    self.gainmercytimer = 0
    self.gainmercytimer2 = 0
    self.showtempmercy = true
end

function PillarHarmony:onWaveSpawn()
    if self.wave.difficulty > 0 then
        self.green = true
        self:setColor(COLORS.lime)
        self.rotation = math.rad(90)
    end
    if self.wave.difficulty == 2 then
        self.chorus = true
    end
    self:addFX(MaskFX(Game.battle.arena))

    -- I can't find the part that spawns the afterimages
    self.wave.timer:everyInstant(3/30, function ()
        if self:isRemoved() or self.collider.collidable then return false end
        local afterimage = self.wave:spawnObject(OrganikkPillarAfterImage("bullets/organikk/bar_1", 0.4 + MathUtils.random(0.25), 0.05))
        afterimage:setLayer(self.layer - 1)
        afterimage:setPosition(self:getPosition())
        afterimage:setOrigin(self:getOrigin())
        afterimage:setScale(self:getScale())
        afterimage.rotation = self.rotation
        afterimage.color = self.color
    end)

    self.wave.timer:lerpVar(self, "scale_x", 0, 0.4, 13, 3, "in")
    self.wave.timer:after(13 / 30, function ()
        self.wave.timer:lerpVar(self, "scale_x", 0.4, 1.25, 3, -1, "in")

        -- for c = 0, (6 + (#self.wave:getAttackers() - 1) * 2) do
        --     self.wave:spawnBullet(x, y)
        -- end
    end)

    self.wave.timer:after(16 / 30, function ()
        Assets.playSound("sneo_overpower", 1, 1.9)
        self.collidable = true
        self.sprite.anim_speed = 1
    end)

    if not self.green then
        self.wave.timer:after(16 / 30, function ()
            self:setColor(COLORS.white)
        end)
    end

    self.wave.timer:after(self.wave.interval / 30, function ()
        self:setColor(ColorUtils.hexToRGB("808080"))
        self.collidable = false
        self.sprite.anim_speed = 0
        self.wave.timer:lerpVar(self, "scale_x", 1, 0, 4)
    end)
end

-- if (green == 1)
-- {
--     var a = 1;
--     if (chorus == 1)
--     {
--         a = 3;
--     }
--     if (i_ex(obj_organ_enemy) && obj_organ_enemy.wicabell_tuning)
--     {
--         a = 2;
--     }
--     repeat (a)
--     {
--         if (!i_ex(obj_dmgwriter_boogie))
--         {
--             with (obj_monsterparent)
--             {
--                 if (global.mercymod[myself] < 100)
--                 {
--                     snd_stop(snd_mercyadd);
--                     snd_play_x(snd_mercyadd, 0.8, 1.4);
--                     var mercygiven = 0;
--                     if (other.parentid == id)
--                     {
--                         mercygiven = 3;
--                     }
--                     else if (object_index == obj_organ_enemy)
--                     {
--                         mercygiven = 1;
--                     }
--                     else if (object_index == obj_halo_enemy)
--                     {
--                         mercygiven = 1;
--                     }
--                     else if (object_index == obj_bell_enemy)
--                     {
--                         mercygiven = 1;
--                     }
--                     if ((global.mercymod[myself] + mercygiven) > 100)
--                     {
--                         mercygiven = 100 - global.mercymod[myself];
--                     }
--                     __mercydmgwriter = instance_create_depth(global.monsterx[myself], global.monstery[myself] + 40, depth - 99999, obj_dmgwriter_boogie);
--                     __mercydmgwriter.damage = mercygiven;
--                     __mercydmgwriter.type = 5;
--                     global.mercymod[myself] += mercygiven;
--                     global.hittarget[myself]++;
--                 }
--             }
--         }
--         else
--         {
--             with (obj_monsterparent)
--             {
--                 if (global.mercymod[myself] < 100)
--                 {
--                     var mercygiven = 0;
--                     if (other.parentid == id)
--                     {
--                         mercygiven = 3;
--                     }
--                     else if (object_index == obj_organ_enemy)
--                     {
--                         mercygiven = 1;
--                     }
--                     else if (object_index == obj_halo_enemy)
--                     {
--                         mercygiven = 1;
--                     }
--                     else if (object_index == obj_bell_enemy)
--                     {
--                         mercygiven = 1;
--                     }
--                     if ((global.mercymod[myself] + mercygiven) > 100)
--                     {
--                         mercygiven = 100 - global.mercymod[myself];
--                     }
--                     __mercydmgwriter.damage += mercygiven;
--                     __mercydmgwriter.init = 0;
--                     global.mercymod[myself] += mercygiven;
--                 }
--             }
--         }
--     }
--     with (obj_organ_enemy)
--     {
--         snd_volume(harmon_sound, 1, 6);
--     }
--     touchingplayer = 2;
-- }
-- else
-- {
--     with (obj_dmgwriter_boogie)
--     {
--         killtimer = 0;
--         killactive = 0;
--         kill = 0;
--     }
--     if (active == 1)
--     {
--         if (target != 3)
--         {
--             scr_damage();
--         }
--         if (target == 3)
--         {
--             scr_damage_all();
--         }
--         if (destroyonhit == 1)
--         {
--             instance_destroy();
--         }
--     }
-- }


function PillarHarmony:update()
    super.update(self)

    if self.wave.del then
        if self.charge_sfx then
            self.charge_sfx:stop()
            self.charge_sfx = nil
        end
        if self.highlight then
            self.highlight:remove()
            self.highlight = nil
        end
    end

    self.touching_player = self.touching_player - DTMULT
    if self.touching_player > 0 then
        if not self.charge_sfx then
            self.charge_sfx = Assets.getSound("harmonize_act_b")
            self.charge_sfx:setLooping(true)
            self.charge_sfx:setVolume(0)
            local timer = 0
            Game.battle.timer:during(1/2, function()
                timer = timer + DT
                if self.charge_sfx then
                    self.charge_sfx:setVolume(MathUtils.rangeMap(timer, 0, 1/2, 0, 1))
                end
            end)
            self.charge_sfx:play()
        end

        for _, attacker in ipairs(self.wave:getAttackers()) do
            if not self.highlight then
                self.highlight = Game.battle:addChild(OrganikkHighlight(attacker.x - 54, attacker.y - 11))
                self.highlight:setLayer(BATTLE_LAYERS["above_battlers"])
            -- else
            --     Game.battle.timer:after(2/30, function() self.highlight:remove() end)
            end
        end

        self.particle_timer = self.particle_timer + DTMULT
        if self.particle_timer >= 3 then
            for _, attacker in ipairs(self.wave:getAttackers()) do
                local particle_1 = Game.battle:addChild(OrganikkParticle(attacker.x - 15 + MathUtils.random(-20, 20),attacker.y - 20))
                particle_1:setLayer(BATTLE_LAYERS["above_battlers"])
                local particle_2 = Game.battle:addChild(OrganikkParticle(Game.battle.soul.x  - 12 + MathUtils.random(-5, 5),Game.battle.soul.y - 4))
                particle_2:setLayer(BATTLE_LAYERS["above_soul"])
                -- obj_heart.x + random(20), obj_heart.y + random(20)
                -- local soul = Game.battle.soul
                -- local x, y = soul:getPosition()
                -- local origin_x, origin_y = soul:getOrigin()
                -- local width, height = soul:getScaledSize()
                -- local heart_x, heart_y = x - width * origin_x, y - height * origin_y
                -- local heart_x, heart_y = soul:getPosition()
                -- local particle = Game.battle:addChild(OrganikkParticle(heart_x + MathUtils.random(20), heart_y + MathUtils.random(20)))
                -- particle:setLayer(BATTLE_LAYERS["above_soul"])
            end
            self.particle_timer = self.particle_timer - 3
        end

        self.gainmercytimer = self.gainmercytimer + DTMULT
        for _, attacker in ipairs(self.wave:getAttackers()) do
		    if self.gainmercytimer >= 2 then
                attacker.mercyget = 1
			    self.gainmercytimer = 1
		    end
        end

        self.gainmercytimer2 = self.gainmercytimer2 + DTMULT
        for _, attacker in ipairs(self.wave:getAttackers()) do
		    if self.gainmercytimer2 >= 4 then
                attacker.mercyget2 = 1
			    self.gainmercytimer2 = 1
		    end
        end

    elseif self.green then
        if self.charge_sfx then
            self.charge_sfx:stop()
            self.charge_sfx = nil
        end
        if self.highlight then
            self.highlight:remove()
            self.highlight = nil
        end
    else
        -- Nothing
    end
end

function PillarHarmony:onCollide(soul)
    if self.green then
        self.touching_player = 2
    else
        if soul.inv_timer == 0 then
            self:onDamage(soul)
        end
    end
end

return PillarHarmony