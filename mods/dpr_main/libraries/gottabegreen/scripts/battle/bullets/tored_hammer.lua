local Hammer, super = Class(PolarBullet, "tored_hammer")
--- @class "tored_hammer" : PolarBullet
--- A hammer that turns the soul red when deflected or on hitting the soul. (Similar to Ch4 Hammer of Justice's later attacks)
---
--- @field new_soul                 Soul        The new soul to change to. (defaults to the red soul)
--- @field soul_change_callback?    fun()       Called when the soul is changed (but before the soul has been moved to the center).
---
--- @field warning_glow_c_off       number[3]   Color mask start point for the "flashing" effect.
--- @field warning_glow_c_on        number[3]   Color mask end point for the "flashing" effect. (well, more like a midpoint)
--- @field warning_glow_len         number      Length (in seconds) it takes for a single cycle from warning_glow_c_off -> warning_glow_c_on and back again.
--- @field warning_glow_timer       number      Current time progress in the warning glow animation.

--- @param soul_change_callback?    fun()   Soul change callback.
function Hammer:init(phi, rho, speed, soul_change_callback)
    -- Last argument = sprite path
    super.init(self, phi, rho, "bullets/hammer_large")
    
    -- Shrink collider height to avoid spilling into other lanes
    local old_height = self.sprite.height / 2
    self.collider.height = self.collider.height / 2
    local hdiff = self.collider.height - old_height
    self.collider.y = self.collider.y - (hdiff/2)
    
    self.destroy_on_hit = true

    -- Speed the hammer moves
    self.physics.speed = speed
    
    self.new_soul = Soul()
    -- callback called after the soul has been changed
    self.soul_change_callback = soul_change_callback
    
    self.draw_children_below = -1
    self.remove_offscreen = false -- we have afterimages parented to us
    
    -- red "warning" glow
    self.warning_glow_c_off = {1,1,1}
    self.warning_glow_c_on = {1,0,0}
    self.warning_glow_len = 30/30
    self.warning_glow_timer = 0
end


function Hammer:update()
    -- update warning glow
    self.warning_glow_timer = self.warning_glow_timer + DT
    if self.warning_glow_timer >= self.warning_glow_len then
        self.warning_glow_timer = self.warning_glow_timer - self.warning_glow_len
    end
    -- first half white->red
    -- second half red->white
    local wt = self.warning_glow_timer/(self.warning_glow_len/2)
    if not (wt < 1) then
        wt = 1-(wt-1)
    end
    local wr = Utils.ease(self.warning_glow_c_off[1], self.warning_glow_c_on[1], wt, "linear")
    local wg = Utils.ease(self.warning_glow_c_off[2], self.warning_glow_c_on[2], wt, "linear")
    local wb = Utils.ease(self.warning_glow_c_off[3], self.warning_glow_c_on[3], wt, "linear")
    self.color = {wr,wg,wb}
    
    -- do other updates
    super.update(self)
end


function Hammer:onCollide(soul)
    self:doTransition()
    super.onCollide(self,soul)
end
function Hammer:onGreenDeflect(crit)
    self.damage = 0
    self:doTransition()
    return super.onGreenDeflect(self,crit)
end
function Hammer:playGreenDeflectSound(crit)
    -- no sfx? (todo)
end

function Hammer:doTransition()
    -- swap souls
    local new_soul = self.new_soul
    Game.battle:swapSoul(new_soul)
    
    -- call callback
    if self.soul_change_callback ~= nil then
        self.soul_change_callback()
    end
    
    -- soul knockback effect
    local kbtimer = self.wave.timer
    
    -- hide from 0..5
    new_soul.alpha = 0
    kbtimer:after(5/30, function()
        new_soul.alpha = 1
    end)
    
    -- knock away 0..9
    -- bounce 9..=10
    local kbdir = self:getDirection()
    local kbx =  math.cos(-kbdir) * 8.875 --((Game.battle.arena.width /2)/8)
    local kby = -math.sin(-kbdir) * 8.875 --((Game.battle.arena.height/2)/8)
    new_soul.physics.speed_x = kbx
    new_soul.physics.speed_y = kby
    kbtimer:after(9/30, function()
        -- bounce backwards
        new_soul.physics.speed_x = 0
        new_soul.physics.speed_y = 0
        
        -- we have to round to an 1/8th before calling sign() because of floating point inaccuracies
        local kxsign = Utils.sign(Utils.roundToZero(kbx*8))
        local kysign = Utils.sign(Utils.roundToZero(kby*8))
        
        kbtimer:tween(2/30, new_soul, {
            x = new_soul.x - (Game.battle.arena.width *0.25*kxsign),
            y = new_soul.y - (Game.battle.arena.height*0.25*kysign),
        }, "out-quad")
    end)
    
    -- fade from white 0..9
    local soul_flash = Sprite("player/heart")
    soul_flash:setOrigin(0.5,0.5)
    new_soul:addChild(soul_flash)
    function soul_flash:getDrawColor() -- monkeypatch dirty hack because there's no option for specifically only inheriting alpha but not colour
        local _,_,_,pa = self.parent:getDrawColor()
        return 1,1,1,self.alpha * pa
    end
    kbtimer:tween(8/30, soul_flash, {alpha = 0}, "in-quad", function()
        soul_flash:remove()
    end)
    
    -- rotate ccw  0..10
    -- rotate cw  10..20
    local starting_rotation = new_soul.rotation
    kbtimer:tween(10/30, new_soul, {
        rotation = starting_rotation - math.rad(180)
    }, "out-quad", function()
        kbtimer:tween(10/30, new_soul, {
            rotation = starting_rotation
        }, "out-quad")
    end)
    
    -- disable movement at first
    new_soul.can_move = false
    kbtimer:after(10/30, function()
        new_soul.can_move = true
    end)
    
    -- create explosion effect
    local hexp = Sprite("effects/redhammerexplode", Game.battle.soul.x, Game.battle.soul.y)
    hexp:setOrigin(0.5,0.5)
    hexp.layer = BATTLE_LAYERS["above_soul"]
    hexp:play(1/15, false, function()
        hexp:remove()
    end)
    Game.battle:addChild(hexp)
    
    -- play sounds
    Game.battle.camera:shake()
    Assets.playSound("impact") -- todo: find correct sound
    kbtimer:after(10/30, function()
        Assets.playSound("damage")
    end)
end

return Hammer