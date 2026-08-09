---@diagnostic disable: undefined-field
local Pillar, super = Class(Bullet)

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


function Pillar:init(x, y, green)
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
    self.tp = 10 / 2.5

    self:setScale(0, 2)
    self.destroy_on_hit = false
    -- self.active = false
    self:setHitbox(self.width / 4, self.height / 8, self.width / 2, 6 * self.height / 8)
    self.collider.collidable = false
    -- self:addFX(RecolorFX(COLORS.gray))
    self:setColor(COLORS.gray)
    self.damage = 56
    self.sprite.anim_speed = 0
    self.charge_sfx = nil
    self.layer = 400
    self.gainmercytimer = 0
    self.gainmercytimer2 = 0
    self.showtempmercy = true
    
end

function Pillar:onWaveSpawn()
    self:addFX(MaskFX(Game.battle.arena))

    -- I can't find the part that spawns the afterimages
    self.wave.timer:everyInstant(3/30, function ()
        if self:isRemoved() or self.collider.collidable then return false end
        local afterimage = self.wave:spawnObject(OrganikkPillarAfterImage("battle/bullets/organikk/bar_1", 0.4 + MathUtils.random(0.25), 0.05))
        afterimage:setLayer(self.layer - 1)
        afterimage:setPosition(self:getPosition())
        afterimage:setOrigin(self:getOrigin())
        afterimage:setScale(self:getScale())
        afterimage.rotation = self.rotation
        afterimage.start_color = self.color
    end)

    self.wave.timer:lerpVar(self, "scale_x", 0, 0.4, 13, 3, "in")
    self.wave.timer:after(13 / 30, function ()
        self.wave.timer:lerpVar(self, "scale_x", 0.4, 1.25, 3, -1, "in")
    end)

    self.wave.timer:after(16 / 30, function ()
        -- self.active = true
        Assets.playSound("sneo_overpower", 1, 1.9)
        self.collider.collidable = true
        self.sprite.anim_speed = 1
    end)

    self.wave.timer:after(16 / 30, function ()
        self:setColor(COLORS.white)
    end)

    self.wave.timer:after(self.wave.interval / 30, function ()
        self:setColor(ColorUtils.hexToRGB("808080"))
        self.collider.collidable = false
        self.sprite.anim_speed = 0
        self.wave.timer:lerpVar(self, "scale_x", 1, 0, 4)
    end)
end

function Pillar:update()
    super.update(self)
end

return Pillar