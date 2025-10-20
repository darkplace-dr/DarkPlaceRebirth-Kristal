local bullet, super = Class(Bullet)

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


function bullet:init(x, y, green)
    super.init(self, x, y, "battle/bullets/organikk/bar_1")

    self.wall_destroy = 1
    self.bottom_fade = 0
    self.green = green or false
    self.highlight = 0
    self.green_timer = 0
    -- self.parent_id = -4
    self.play_piano_sfx = false
    self.touching_player = 0
    self.particle_timer = 0
    self.chorus = 0
    self.tp = 10 / 2.5
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


function bullet:update()
    super.update(self)

    if self.green then
        -- local a = 
    end

    self.touching_player = self.touching_player - DTMULT
    if self.touching_player > 0 then
        -- Stuff
        self.highlight = self.highlight + 10 * DTMULT
        local _highlight = self.highlight
        if _highlight > 70 then
            _highlight = 70
        end

        -- Stuff
        self.particle_timer = self.particle_timer + DTMULT
        if self.particle_timer >= 3 then
            self.particle_timer = self.particle_timer - 3
            -- Create particle
            -- Set depth to Soul depth - 100
            -- Set alpha to 1
        end
    elseif self.green then
        self.highlight = 0
        -- image_blend = c_lime
        -- Assets.playSound("harmon_sound", 0, 10) 
    else
        -- Assets.playSound("harmon_sound", 0, 10)
    end
end

return bullet