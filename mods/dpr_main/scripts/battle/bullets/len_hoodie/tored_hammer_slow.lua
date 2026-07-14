local SlowHammer, super = Class("tored_hammer", "tored_hammer_slow")

--- @class "tored_hammer_slow" : "tored_hammer"
--- A version of tored_hammer that comes in slowly, then becomes fast when self:throw() is called. (similar to Ch4 Hammer of Justice's first hammer attack)
---
--- @field autostop_rho?        number  Autostop rho value, or nil to disable.
--- @field autostop_callback?   fun()   Autostop callback
--- @field thrown               boolean If true, creates afterimages. If false, shakes as it approaches autostop_rho.

--- @field initial_rho          number  The original rho this started at (for easing shake strength).
--- @field afterimage_timer     number  Time counter for creating after images.

--- @param initial_speed?       number  initial speed (default 1)
--- @param autostop_rho?        number  Distance from the center to automatically stop at if not yet thrown.
--- @param autostop_callback?   fun()   Callback called when auto-stop triggers.
function SlowHammer:init(phi, rho, initial_speed, autostop_rho, autostop_callback)
    super.init(self, phi, rho, initial_speed or 1, nil)
    
    self.initial_rho = rho
    self.afterimage_timer = 0
    
    self.autostop_rho = autostop_rho
    self.autostop_callback = autostop_callback
    
    self.thrown = false
    
    self.draw_children_below = -1
end

--- Pull the hammer backwards then throw it at a fast speed.
--- @param speed?       number  Speed to throw it at. (default is 20)
--- @param duration?    number  Duration (in seconds) of the pull-back. (default 9/30)
function SlowHammer:throw(speed, duration)
    speed = speed or 20
    duration = duration or 9/30
    
    -- disable autostop
    self.autostop_rho = nil
    
    -- pull back and throw
    self.physics.speed = -speed
    self.wave.timer:tween(duration, self.physics, {speed=speed})
    
    -- set thrown to true once we're thrown
    self.wave.timer:after(duration/2, function()
        self.thrown = true
    end)
end

function SlowHammer:update()
    if self.autostop_rho ~= nil then
        local rho = self:getRho()
        if rho <= self.autostop_rho then
            self.physics.speed = 0
            self.autostop_rho = nil
            if self.autostop_callback ~= nil then
                self.autostop_callback(self)
            end
        end
    end
    
    if not self.thrown then
        -- "shake" effect
        local shake_strength = 1
        if self.autostop_rho ~= nil then -- shake stronger as we get closer
            local rho = self:getRho()
            local t = (rho-self.autostop_rho)/(self.initial_rho-self.autostop_rho)
            shake_strength = Utils.ease(0,shake_strength,1-t,"in-quad")
        end
        self.sprite.x = Utils.random(-shake_strength,shake_strength)
        self.sprite.y = Utils.random(-shake_strength,shake_strength)
    else
        -- undo shake
        self.sprite.x = 0
        self.sprite.y = 0
        
        if not self.dont_create_after_images then
            -- and create afterimages
            local AFTERIMAGES_PER = 1/30
            self.afterimage_timer = self.afterimage_timer + DT
            if self.afterimage_timer >= AFTERIMAGES_PER then
                self.afterimage_timer = self.afterimage_timer - AFTERIMAGES_PER
                -- The AfterImage takes three arguments - the sprite, the initial alpha of the afterimage, and the fade speed.
                -- Play around with these values to decide what fits your effect best!
                local after_image = AfterImage(self.sprite, 1, 1/7) -- todo: use the actual hammer afterimage sprite rather than the main hammer one
                after_image:setLayer(-1) -- draw below us
                -- Parent the AfterImage to the sprite otherwise it won't appear in-game!
                self:addChild(after_image) -- todo parent to something else
            end
        end
    end
    
    super.update(self)
end

return SlowHammer