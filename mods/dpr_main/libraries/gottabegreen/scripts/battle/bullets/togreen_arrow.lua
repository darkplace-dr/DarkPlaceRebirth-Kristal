local GreenTransition, super = Class(Bullet, "togreen_arrow")
--- @class "togreen_arrow" : Bullet
--- An arrow effect that turns the soul green on contact (similar to Ch4 Hammer of Justice).
--- @field applied                  boolean Whether the effect has been applied to the soul.
--- @field new_soul                 Soul    The new soul to change to. (defaults to the green soul)
--- @field soul_change_callback?    fun()   Called when the soul is changed (but before the soul has been moved to the center).

--- @param dir                      number  Direction to spawn facing.
--- @param soul_change_callback?    fun()   Soul change callback.
function GreenTransition:init(x, y, dir, soul_change_callback)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/togreen_arrow")
    self.flip_h = true
    self.flip_v = true
    
    -- Fix scale
    self:setScale(1,1)
    -- Fix hitbox (this isn't supposed to be dodged)
    self.collider = ColliderGroup(self, {
        Hitbox(self, self.width - 30, -self.height/2, 30, self.height*2), -- back hitbox (catches anything that gets past)
        PolygonCollider(self, {{self.width-30, 0}, {self.width-30,self.height}, {0,self.height/2}}) -- front hitbox (catches the soul if it touches the arrow early)
    })
    
    -- disable tp/other bullet settings
    self.can_graze = false
    self.destroy_on_hit = false
    self.damage = 0
    self.inv_timer = 0
    
    self.applied = false
    
    self.new_soul = GreenSoul()
    -- callback called after the soul has been changed
    -- (the soul may still be transitioning back to the arena center at this point. transitionTo doesn't support callbacks)
    self.soul_change_callback = soul_change_callback

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = 20
    
    self.draw_children_below = -1
    self.remove_offscreen = false -- we have afterimages parented to us
    
    -- spawn afterimages
    local afterimage_timer = self:addChild(Timer())
    afterimage_timer:every(1/30, function()
        -- If our sprite stops existing, this stops the timer so we don't crash
        if not self.sprite then
            return false
        end
        
        -- The AfterImage takes three arguments - the sprite, the initial alpha of the afterimage, and the fade speed.
        -- Play around with these values to decide what fits your effect best!
        local after_image = AfterImage(self.sprite, 1, 1/7)
        after_image:setLayer(-1) -- draw below us
        -- Parent the AfterImage to the sprite otherwise it won't appear in-game!
        self:addChild(after_image)
    end)
end

function GreenTransition:onCollide(soul)
    if not self.applied then -- only apply effect once
        local new_soul = self.new_soul
        Game.battle:swapSoul(new_soul)
        self.applied = true
        
        -- play sound
        Assets.playSound("ui_cancel_small")
        
        -- move soul to center
        local cx, cy = Game.battle.arena:getCenter()
        new_soul:transitionTo(cx, cy, false)
        
        -- call callback
        if self.soul_change_callback ~= nil then
            self.soul_change_callback()
        end
    end
end
function GreenTransition:onGreenDeflect(crit) -- ignore green soul deflection
    return true
end

return GreenTransition