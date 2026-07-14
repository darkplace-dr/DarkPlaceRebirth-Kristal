local Shell, super = Class(PolarBullet, "gerson_shell")
--- @class "gerson_shell" : PolarBullet
--- A shell that travels towards the center of the arena and bounces off of the green soul's blocker. For use with the green soul mode (duh).
---
--- @field hp                       number  This shell's health.
---     
--- @field outer_texture            string  The texture for the shell's outer part.
--- @field inner_texture            string  The texture for the shell's inner (coloured) part.
--- @field shell_inner              Sprite  The Sprite displaying the shell's inner part.
---     
--- @field cooldown_left            number  The time before this shell becomes deflectable again. (used to stop shells from being bounced twice)
---     
--- @field spin_time_left           number  The time left in the shell's current direction change (for shells that rotate after bouncing).
--- @field spin_from_angle          number  The angle this shell was at when its direction change started (for shells that rotate after bouncing).
--- @field spin_to_angle            number  The angle this shell is changing to
--- @field spin_from_time           number  The total time in the shell's direction change (for shells that rotate after bouncing)
---
--- Note: changes to base_ fields might not have an immediate effect.
--- @field base_speed               number  The shell's speed (at size 1).
--- @field base_rebound_duration    number  The duration (in seconds) of a rebound (at size 1).
--- @field deflect_duration         number  The duration (in seconds) the shell stays on the blocker before rebounding (all sizes).
---
--- @field private size             number  The shell's spin, as set using :setSpin().
--- @field private size             number  The shell's size, as set using :setSize(). (1 = normal size)

--- @param hp       number  This shell's health. Drops by one each time it's deflected. Once reduced to zero, it will disappear.
function Shell:init(phi, rho, hp, size)
    self.outer_texture = "bullets/shell_outer"
    self.inner_texture = "bullets/shell_inner"
    
    super.init(self, phi, rho, self.outer_texture)
    self.shell_inner = Sprite(self.inner_texture)
    self.sprite:addChild(self.shell_inner)
    
    self.hp = hp
    
    self.cooldown_left = 0
    
    self.spin_time_left = 0
    self.spin_from_angle = nil
    self.spin_to_angle = nil
    self.spin_from_time = nil
    
    -- set base values
    self.base_speed = 12
    self.base_rebound_duration = (14*2)/30 -- the 14-frame (@15fps) "spin" animation plays once to completion over the course of a rebound
    -- set large/small-ness
    self:setSize(size or Shell.SIZE_NORMAL)
    -- set spin
    self:setSpin(Shell.SPIN_NONE)
    
    self.deflect_duration = 5/30
end

-- API
Shell.SIZE_NORMAL = 1
Shell.SIZE_LARGE = 1/0.75
--- Get the shell's size.
function Shell:getSize()
    return self.size
end
--- Change the shell's size. (use .SIZE_NORMAL and .SIZE_LARGE for standard values)
--- Larger shells are slower and take longer to rebound. Updates various fields to reflect this.
--- @param size_mult    number  The size multiplier. (regular size is size 1, giga shells are size 1/0.75)
function Shell:setSize(size_mult)
    -- set size
    self.size = size_mult
    
    -- adjust sprite scale
    self:resetScale()
    -- reset speed
    self.physics.speed = self:getDefaultSpeed()
end

Shell.SPIN_ANTICLOCKWISE = math.rad(-90)
Shell.SPIN_COUNTERCLOCKWISE = Shell.SPIN_ANTICLOCKWISE
Shell.SPIN_CLOCKWISE = math.rad(90)

Shell.SPIN_NONE = 0
Shell.SPIN_NORMAL = Shell.SPIN_COUNTERCLOCKWISE
Shell.SPIN_REVERSE = Shell.SPIN_CLOCKWISE
--- Get the shell's spin direction.
function Shell:getSpin()
    return self.spin
end
--- Set the shell's spin direction. (use .SPIN_NONE, .SPIN_NORMAL/.SPIN_ANTICLOCKWISE/.SPIN_COUNTERCLOCKWISE, and .SPIN_REVERSE/.SPIN_CLOCKWISE for standard values)
--- @param spin number  The angle (in radians) to move by after each bounce.
function Shell:setSpin(spin)
    self.spin = spin
    
    self:resetAnimation()
end

-- stuff
function Shell:getReboundDuration()
    return self.base_rebound_duration*self:getSize()
end
function Shell:getDefaultSpeed()
    return self.base_speed/self:getSize()
end
--- Reset the shell's animation back to the start, updating it based on the current spin/etc. values
function Shell:resetAnimation()
    local spin = self:getSpin()
    if spin == 0 then
        self.sprite:setSprite(self.outer_texture)
        self.sprite:stop()
        
        self.shell_inner:setSprite(self.inner_texture)
        self.shell_inner:stop()
    else
        local speed = 1/15
        speed = speed * math.abs(spin/math.rad(90)) -- spin faster/slower if we're rotating more/less than the default
        
        self.sprite:setFrames(Assets.getFrames(self.outer_texture))
        self.sprite:play(speed)
        self.shell_inner:setFrames(Assets.getFrames(self.inner_texture))
        self.shell_inner:play(speed)
    end
    
    -- flip if going clockwise
    if spin > 0 then
        self.sprite.flip_y = true
    else
        self.sprite.flip_y = false
    end
end
--- Update the shell's scale based on self.size
function Shell:resetScale()
    local size = self:getSize()
    self:setScale(0.75*size,0.75*size)
end

function Shell:update()
    if self.cooldown_left > 0 then
        self.cooldown_left = self.cooldown_left - DT
    end
    if self.spin_time_left > 0 then
        self.spin_time_left = self.spin_time_left - DT
        local new_phi = Utils.lerp(self.spin_from_angle, self.spin_to_angle, MathUtils.clamp(1-(self.spin_time_left/self.spin_from_time),0,1), "linear")
        local rho = self:getRho()
        self:setPositionPolar(new_phi, rho)
    end
    
    self:updateShellColour(self.hp)
    
    super.update(self)
end
--- *(Override)* to change the shell's colour.
--- @param hp   number  The shell's current hp.
function Shell:updateShellColour(hp)
    if hp == 1 then
        self.shell_inner.color = {1,1,0} -- BGR 00FFFF 65535
    elseif hp == 2 then
        self.shell_inner.color = {0,1,0} -- BGR 00FF00 65280
    elseif hp == 3 then
        self.shell_inner.color = {0,1,1} -- BGR FFFF00 16776960
    elseif hp == 4 then
        self.shell_inner.color = {127/255,0,127/255} -- BGR 800080 8388736
    elseif hp == 5 then
        self.shell_inner.color = {1,0,0} -- BGR 0000FF 255
    elseif hp == 6 then
        self.shell_inner.color = {1,127/255,184/255} -- from `pink1 = make_color_rgb(255, 127, 184);`
    elseif hp == 7 then
        self.shell_inner.color = {1,178/255,212/255} -- from `pink2 = make_color_rgb(255, 178, 212);`
    elseif hp == 8 then
        self.shell_inner.color = {1,204/255,226/255} -- from `pink3 = make_color_rgb(255, 204, 226);`
    else
        -- (rainbow shell as a failsafe - reference to SMW)
        local rainbow_cols = {{1,1,0}, {0,1,1}, {1,0,0}, {0,1,0}}
        self.shell_inner.color = rainbow_cols[(FPS_COUNTER%4)+1]
    end
end

function Shell:onGreenDeflect(crit)
    -- ensure we only get hit once per bounce
    if self.cooldown_left > 0 then
        return true
    end
    self.cooldown_left = self.cooldown_left + (self:getReboundDuration()/2) + self.deflect_duration
    
    self:playGreenDeflectSound(crit)
    
    -- deflection anim
    self.physics.speed = 0
    
    if self:getSpin() == 0 then
        -- reduce scale
        self.scale_x = self.scale_x * (2/3)
    else
        -- use special "deflected spinning shell" frame
        self.sprite:setSprite(self.outer_texture .. "_deflect")
        self.shell_inner:setSprite(self.inner_texture .. "_deflect")
    end
    
    self.wave.timer:after(self.deflect_duration, function()
        -- restore scale and texture
        self:resetScale()
        self:resetAnimation()
    
        -- reflect away
        local speed = self:getDefaultSpeed()
        self.physics.speed = -speed
        self.wave.timer:tween(self:getReboundDuration(), self.physics, {speed=speed}, 'linear')
        
        -- spin
        if self:getSpin() ~= 0 then
            -- Set new spin angles
            if self.spin_time_left > 0 then
                self.spin_from_angle = self.spin_to_angle -- don't get misaligned over time
            else
                self.spin_from_angle = self:getPhi()
            end
            self.spin_to_angle = self.spin_from_angle + self:getSpin()
            
            -- Set spin time
            local spin_time = self:getReboundDuration()
            self.spin_time_left = spin_time
            self.spin_from_time = spin_time
        end
    end)
    
    -- little "shake"
    local shake_strength = self.width * (1/8)
    self.wave.timer:script(function(wait)
        local y = self.sprite.y
        self.wave.timer:tween(1/30, self.sprite, {y=y+shake_strength})
        wait(1/30)
        self.wave.timer:tween(2/30, self.sprite, {y=y-shake_strength})
        wait(2/30)
        self.wave.timer:tween(1/30, self.sprite, {y=y}, "linear", function()
            self.sprite.y = y
        end)
    end)
    
    -- update hp
    self.hp = self.hp - 1
    if self.hp < 1 then
        self:remove()
    end
end
function Shell:playGreenDeflectSound(crit)
    if crit and self.hp > 1 then
        Assets.playSound("shell_deflect_crit")
    else
        super.playGreenDeflectSound(self, crit)
    end
end

return Shell