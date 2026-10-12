local ShearySmashCutter, super = Class(Object)

function ShearySmashCutter:init(x, y)
    super.init(self, x, y)

    self.my_surface = love.graphics.newCanvas(180, 180)

    self.timer = 15
    self.con = 0
    self.angle = 0
    self.surf_size = 180
    self.half = self.surf_size / 2
    self.my_surface = love.graphics.newCanvas(self.surf_size, self.surf_size)
    self.xscale, self.yscale = 0, 0
    self.bladescale = 1
    self.rotation = -math.rad(180)
    self.warp = 0
    self.shake = 0
end

function ShearySmashCutter:update()
    super.update(self)

    local old_t = self.timer
    self.timer = self.timer + DTMULT

    if self.timer >= 60 then
        self.timer = self.timer + DTMULT
    end

    if old_t < 16 and self.timer >= 16 then
        Game.battle.timer:tween(8/30,  self, { x = self.x + 45 }, "out-back")
        Game.battle.timer:tween(25/30, self, { y = Game.battle.arena.y }, "out-back")
        Game.battle.timer:tween(12/30, self, { xscale = 2, yscale = 1 }, "out-back")
        image_angle = 180;
        Game.battle.timer:tween(28/30, self, { rotation = -math.rad(180) }, "out-back")
        Assets.playSound("spearrise", 0.8)
    end

    if old_t < 27 and self.timer >= 27 then
        Game.battle.timer:tween(10/30, self, { angle = -33 }, "out-back")
        Game.battle.timer:tween(10/30, self, { x = self.x + 30 }, "in-out-back")
        Assets.playSound("chain_extend", 0.8, 0.66)
    end

    if old_t < 38 and self.timer >= 38 then
        Game.battle.timer:tween(10/30, self, { angle = 10 }, "in-back")
        Game.battle.timer:tween(12/30, self, { x = self.x - 120 }, "in-out-back")
        Game.battle.timer:tween(10/30, self, { bladescale = 1.8 }, "in-out-back")
    end

    if old_t < 48 and self.timer >= 48 then
        self.shake = 2
        Game.battle.timer:after(20/30, function() self:remove() end)
        Game.battle.timer:tween(15/30, self, { alpha = 0 }, "linear")

        Assets.playSound("scytheburst", 0.4)

        self.physics.speed_y = 0
        self.physics.gravity = 0
        local smashcut_manager = self.wave:spawnObject(TennaSmashCutManager(self.x, self.y))
        smashcut_manager:setLayer(BATTLE_LAYERS["top"])
        Game.battle:shakeCamera()

        local _smashcut = Game.stage:getObjects(Registry.getBullet("sheary/smashcut_attack"))[1]
        _smashcut.rumble_loop:play()
        _smashcut.type = self.type
        _smashcut.do_flip = self.do_flip
        _smashcut.difficulty = self.difficulty

        -- if (math.abs(Game.battle.soul.y - self.y) < 12 and Game.inv_frames >= 0) then
        --     ti = MathUtils.randomInt(2+1)
            
        --     while (ti < 3) do
        --         for i = 0, 2-1 do
        --             if (global.hp[global.char[ti]] < 0 or global.char[ti] == 0) then
        --                 ti = ti + 1
        --             end
                    
        --             if ti == 3 then
        --                 ti = 0
        --             end
        --         end
                
        --         global.inv = -1;
        --         target = ti;
                
        --         if (global.hp[global.char[ti]] > 0 && global.char[ti] != 0) then
        --             self.damage = math.floor(global.hp[global.char[ti]] / 2) + (3 * global.battledf[ti])
        --             scr_damage();
        --         end
                
        --         ti = ti + 3
        --     end
            
        --    self.inv_frames = 40
        -- end
    end
end

local function draw_rectangle(x, y, w, h, outline)
    Draw.rectangle(outline, x, y, w - x + 1, h - y + 1)
end


function ShearySmashCutter:drawSelf()
    super.drawSelf(self)

    local width = MathUtils.clamp(15 - math.abs(45 - self.timer), 0, 10)

    if width > 0 then
        Draw.setColor(1, 0, 0, 0.5)
        local warn = math.ceil(width / 2)
        
        while (warn <= width) do
            draw_rectangle(Game.battle.arena.x - 70, Game.battle.arena.y - warn, Game.battle.arena.x + 71, Game.battle.arena.y + warn, "fill")
            warn = warn + 2
        end
        
        Draw.setColor(1, 1, 1, 1)
    end

    if self.my_surface == nil then
        self.my_surface = love.graphics.newCanvas(140, 140)
    end

    local canvas = Draw.pushCanvas(self.my_surface)
    love.graphics.clear(0, 0, 0, 0)

    Draw.setColor(1, 1, 1, 1)
    Draw.draw(Assets.getTexture("battle/bullets/sheary/scissor_blade"), 57 + (self.bladescale * 3), 57, self.angle, self.bladescale, -1, 3, 16)

    love.graphics.setBlendMode("replace", "alphamultiply")
    -- Draw.draw(spr_battlebg_0, 1, ceil(56.5 - ((obj_growtangle.x - x) / 2)), 58, 1, 2, 0, c_white, 0);
    -- Draw.draw(spr_battlebg_0, 0, ceil(56.5 - ((obj_growtangle.x - x) / 2)), 58, 1, 2, 0, c_white, 0);
    love.graphics.setBlendMode("alpha", "alphamultiply")

    Draw.draw(Assets.getFrames("battle/bullets/sheary/scissor_blade")[1], 57 + (self.bladescale * 3), 59, -self.angle, self.bladescale, 1, 3, 16)
    Draw.draw(Assets.getFrames("battle/bullets/sheary/scissor_handle")[1], 57, 58 - self.bladescale, -self.angle, 1, -self.bladescale, 30, 17)
    Draw.draw(Assets.getFrames("battle/bullets/sheary/scissor_handle")[1], 57, 58 + self.bladescale, -self.angle, 1, self.bladescale, 30, 17)

    -- gpu_set_blendmode_ext_sepalpha(bm_src_color, bm_inv_src_alpha, bm_zero, bm_dest_alpha);
    Draw.draw(Assets.getFrames("battle/bullets/sheary/scissor_blade")[2], 57 + (bladescale * 3), 59, -self.angle, self.bladescale, 1, 3, 16)
    Draw.draw(Assets.getFrames("battle/bullets/sheary/scissor_blade")[2], 57 + (self.bladescale * 3), 57, self.angle, self.bladescale, -1, 3, 16)
    Draw.draw(Assets.getFrames("battle/bullets/sheary/scissor_handle")[2], 57, 58 - self.bladescale, -self.angle, 1, -self.bladescale, 30, 17)
    Draw.draw(Assets.getFrames("battle/bullets/sheary/scissor_handle")[2], 57, 58 + self.bladescale, self.angle, 1, self.bladescale, 30, 17)
    love.graphics.setBlendMode("alpha")

    Draw.popCanvas(true)
    Draw.setColor(1, 1, 1, self.alpha)
    Draw.drawCanvas(self.my_surface, 
        ((self.x - MathUtils.lengthDirX(58 * self.xscale, self.rotation)) + MathUtils.lengthDirX(58 * self.yscale, self.rotation + 90) + MathUtils.random(self.shake)) - (self.shake / 2), 
        ((self.y - MathUtils.lengthDirY(58 * self.yscale, self.rotation - 90)) + MathUtils.lengthDirY(58 * self.xscale, self.rotation + 180) + MathUtils.random(shake)) - (self.shake / 2), 
        self.rotation, self.xscale, self.yscale
    )
end

function ShearySmashCutter:onRemove(parent)
    super.onRemove(self, parent)
end

return ShearySmashCutter