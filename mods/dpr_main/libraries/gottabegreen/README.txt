GottaBeGreen: Kristal library for the Deltarune Green Soul.

Gamebanana: https://gamebanana.com/mods/656732
Youtube demo: https://youtu.be/zI9E3IuOYs8
Discord thread: https://discord.com/channels/899153719248191538/1477443131749175367

GottaBeGreen is a recreation of the Green Soul, as seen in the Chapter 4 Hammer of Justice battle.

Features:
 - Support for gaining TP from deflecting bullets (both regular and critcal)]
 - Support for 8-way (diagonal) mode.
 - Comes with spears, and also shells (regular, spinning, and large).
 - Built-in bullets/effects for changing to and from the green soul mid-wave.

Currently unimplemented effects:
 - Star particles when getting a critical deflect.
 - Particles for the broken blocker/octagon when the hammer changes you back to red soul.
 - Correct afterimages for the hammer (currently uses the normal hammer sprite for afterimages rather than the smaller alternate one)

-- INSTALLATION AND CONFIG
For installation, simply put the gottabegreen zip into your project's "libraries" folder, as with any Kristal library. (If that doesn't work, try extracting the zip into a folder called "gottabegreen" within your libraries folder. Kristal is confusing sometimes)

To configure, add a JSON object to your mod.json's "config" structure, under the key "gottabegreen", like so:
```
    // Config values for the engine and any libraries you may have.
    // These config values can control chapter-specific features as well.
    "config": {
        ... // kristal/etc.
        "gottabegreen": {
            // See this library's lib.json for a full list
            
            // Enable diagonal mode by default, rather than requiring a :setDiagonal(true) call every time the soul is created.
            "diagonalByDefault": true,
            // Prevent the player from spamming parry by adding a cooldown after a failed parry.
            // (Inspired after seeing a speedrunner play the HoJ fight)
            "parryCooldown": 8, // 8 frames
        }
    },
```


-- ACTIVATING GREEN SOUL MODE
The green soul implementation is called GreenSoul.
See https://kristal.cc/wiki/wavemaking-reference#changing-souls-in-battle for more examples on switching souls.
```
function Encounter:createSoul(x, y, color)
    local soul = GreenSoul(x,y,color)
    -- configure soul here
    return soul
end
```

-- SWITCHING SOULS MID-WAVE
Game.battle:swapSoul can be used as normal, but there's also a ready-made bullet ("togreen_arrow") that replicates the "green arrow" effect.
It's recommended to aim this at the arena center (like in the Hammer of Justice fight) - the hitbox is large enough that it won't miss unless the arena is WAY oversized.
```
    local center_x, center_y = Game.battle.arena:getCenter()
    local angle = Utils.angle(x, y, center_x, center_y)
    
    local arrow = self:spawnBullet("togreen_arrow", x, y, angle)
```
The soul to be used is stored in .new_soul, allowing you to configure it as you see fit:
```
    arrow.new_soul:setDiagonal(false) -- etc.
```
You can also add a callback to be called when the bullet touches the soul and turns it green.
```
    arrow.soul_change_callback = function()
        -- code goes here
    end
```

-- ENABLING DIAGONAL MODE
When created, the soul starts in 4-way or 8-way mode depending on the config. By default, this is 4-way mode.
To explicitly change the mode, use the :setDiagonal method on your soul instance (e.g. `Game.battle.soul` or similar)
```
    -- start in classic (4-way) mode
    soul:setDiagonal(false)
    -- After 4 seconds, switch to diagonal (8-way) mode
    timer:after(4, function()
        soul:setDiagonal(true)
    end)
```
If called during the wave, it will play a sound and perform a smooth transition to the new mode.

-- CHANGING THE BLOCKER SPRITE
By default, the blocker sprite is Susie's Ax from Chapter 4. This can be changed using :setBlockerSprite.
```
    -- Set blocker sprite to a custom one
    soul:setBlockerSprite("ui/battle/my_cool_blocker")
    -- Uses "ui/battle/my_cool_blocker" for the regular sprite.
    -- Uses "ui/battle/my_cool_blocker_hit" for the hit sprite.
    -- Uses "ui/battle/my_cool_blocker_crit" as the crit sprite.
    -- See the library's sprites for examples on what these should look like.
    
    -- Set blocker sprite back to normal
    soul:setBlockerSprite("ui/battle/green_soul_blocker")
```

-- WIDE MODE
"Wide Mode" is a custom feature allowing you to block three lanes at once (only valid in 8-way mode).
This can be set using the :setWideBlockerHitbox.
```
    -- Diagonal (8-way) mode must be enabled for the wide blocker to have any effect
    soul:setDiagonal(true)
    
    -- Enable the wide hitbox
    soul:setWideBlockerHitbox(true)
    -- Set sprite to one designed for wide mode (as otherwise the hitbox and sprite wouldn't match, which would confuse the player)
    soul:setBlockerSprite("ui/battle/my_cool_wide_blocker")
    
    -- Disable the wide hitbox
    soul:setWideBlockerHitbox(false)
    -- And set sprite back to my_cool_blocker
    soul:setBlockerSprite("ui/battle/my_cool_blocker")
```

-- POLAR BULLETS
The PolarBullet class is a subclass of Bullet designed for green soul mode.
It exposes a special coordinate system in its api (though due to how Kristal works, it still uses x/y internally).

The coordinate system is relative to a central "pole" (by default, the arena center):
 - phi: the angle (clockwise) around the pole
 - rho: the distance from the pole

When spawning polar bullets, its important to note that the constructor takes phi and rho rather than x and y.


-- SPEARS
The "gerson_spear" bullet is a PolarBullet representing the standard yellow spear used in the Hammer of Justice fight.
```
    -- spawn a spear
    local spear = self:spawnBullet("gerson_spear", angle, distance, speed?)
    -- spawn a spear overhead, 352px away, at a speed of 12px/f
    local spear = self:spawnBullet("gerson_spear", math.rad(-90), 352, 12)
```

-- RED SPEARS
The closest spear to the player is typically marked red, as an indicator. This can be handled automatically, by adding a SpearRedChecker() as a child of your Wave in :init().
```
    self:addChild(SpearRedChecker())
```

Alternatively, for deception attacks, you can instead set spears to red manually, using the :setRed method. (This only works if there is no SpearRedChecker added to the wave, as otherwise your spears' red-ness will likely get overwritten)
```
    -- Make a spear red
    spear:setRed(true)
    -- Set the spear back to yellow
    spear:setRed(false)
```

The colour of a spear (red / yellow) has no effect on its behaviour - it's purely a visual indicator.


-- SHELLS
The "gerson_shell" bullet represents all types of shells seen in the green soul segments of the Hammer of Justice fight.
```
    -- spawn a shell
    local shell = self:spawnBullet("gerson_shell", angle, distance, hp)
    -- spawn a green shell (2hp) directly above at a distance of 352px
    local shell = self:spawnBullet("gerson_shell", math.rad(-90), 352, 2)
    -- spawn a cyan shell (3hp) to the right at a distance of 352px
    local shell = self:spawnBullet("gerson_shell", math.rad(0), 352, 3)
    -- spawn a yellow shell (1hp) diagonally down-right at a distance of 352px
    local shell = self:spawnBullet("gerson_shell", math.rad(45), 352, 3)
```

-- SPINNING SHELLS
The "gerson_shell" bullet also supports spinning shells, which rotate a certain amount each time they're deflected. You can set their spin using :setSpin
```
    -- Set the shell to spin anticlockwise
    shell:setSpin(shell.SPIN_NORMAL)
    -- Set the shell to spin clockwise (not used in deltarune, but implemented for completion's sake)
    shell:setSpin(shell.SPIN_REVERSE) -- you can also use SPIN_CLOCKWISE
    -- you can also use SPIN_ANTICLOCKWISE and SPIN_COUNTERCLOCKWISE
    
    -- Set the shell to spin a custom amount (45 degrees anticlockwise)
    -- beware: very hard to sightread
    shell:setSpin(math.rad(-45))
    
    -- Set the shell to not spin at all
    shell:setSpin(shell.SPIN_NONE) -- you can also use 0
```

Note that the SPIN_ constants are actually part of the Shell class, so you can also do things like this if you want to:
```
    local Shell = Registry.getBullet("gerson_shell")
    
    local spin = Shell.SPIN_NONE
    if math.random() < 0.3 then
        spin = Shell.SPIN_ANTICLOCKWISE
    end
    
    local shell = self:spawnBullet("gerson_shell", ...)
    shell:setSpin(spin)
```

-- LARGE SHELLS
The "gerson_shell" bullet also supports the large shells from the final attack. Larger shells move slower.
```
    -- Set the shell to be large.
    shell:setSize(shell.SIZE_LARGE)
    
    -- Set the shell to be small (i.e. back to normal size).
    shell:setSize(shell.SIZE_NORMAL)
    
    -- Set the shell to be a custom size.
    -- In this case, the shell will by tiny (and way too fast to react to).
    shell:setSize(0.75)
```

Just like the SPIN_ constants, the SIZE_ constants are also part of the Shell class.
```
    local Shell = Registry.getBullet("gerson_shell")
    
    local size = Shell.SIZE_NORMAL
    if math.random() < 0.3 then
        size = Shell.SIZE_LARGE
    end
    if math.random() < 0.02 then
        size = size * 1.5
    end
    
    local shell = self:spawnBullet("gerson_shell", ...)
    shell:setSize(size)
```


-- THE HAMMER (switching back to red mode)
The "tored_hammer" polar bullet replicates the fast hammer that changes you back to red soul mode in the latter half of the Hammer of Justice fight.
```
    local hammer = self:spawnBullet("tored_hammer", angle, distance, speed)
    
    -- spawn a hammer from above at a distance of 352px, at a speed of 18px/frame
    local hammer = self:spawnBullet("tored_hammer", math.rad(90), 352, 18)
    
    -- Just like togreen_arrow, tored_hammer also has support for changing the soul, or setting a callback.
    hammer.new_soul = MyCoolSoul()
    hammer.soul_change_callback = function()
        -- do cool stuff here
    end
```


-- MAKING CUSTOM BULLETS

-- POLAR BULLETS (continued)
This section contains information on polar bullets that is useful if you are creating your own.
```
    -- to directly create/spawn
    local bullet = self:spawnBullet(PolarBullet(..., phi, rho, texture, pole?))
    
    -- or to subclass
    local MyCustomBullet, super = Class(PolarBullet, "my_custom_bullet")
    ...
```

By default, polar bullets face inwards, and have match_rotation set to true.
This means that positive speeds move towards the soul, and negative speeds move away.
```
    bullet.physics.speed = 10 -- move towards the pole at 10px/frame
    bullet.physics.speed = -10 -- move away from the pole at 10px/frame
```

Their direction can be changed relative to phi by using :setFacingOffset.
The "facing offset" is an angle clockwise from phi, defaulting to 180 degrees (i.e. inwards).
```
    
    bullet:setFacingOffset(math.rad(0)) -- face outwards
    bullet:setFacingOffset(math.rad(90)) -- face clockwise
    bullet:setFacingOffset(math.rad(180)) -- face inwards
    bullet:setFacingOffset(math.rad(180)) -- face counterclockwise
```

To disconnect their sprite rotation and physics direction, set physics.match_rotation to false and call :updateDirection() to ensure their physics direction is properly set.
```
    bullet.physics.match_rotation = false -- use physics.direction instead of bullet.rotation for physics
    bullet:updateDirection() -- update the physics direction (as physics.direction isn't set while match_rotation is true, and so may be outdated)
    
    bullet.rotation = math.rad(0) -- always face right, regardless of phi
```

The "pole" defaults to the arena center, but can be changed using :setPole.
```
    -- change the pole, moving the bullet so that it's at the same relative position
    bullet:setPole(new_x, new_y)
    
    -- change the pole, but leave the bullet at the same x/y position rather than move it
    bullet:setPole(new_x, new_y, true)
```

-- GREEN DEFLECT COLLIDERS
Bullets can have a separate "green_deflect_collider" in addition to their regular collider.
If set, then both the bullet's regular collider and its "green_deflect_collider" must collide with the soul's deflector in order to deflect the bullet.
This is useful for bullets that are large and/or fast, as otherwise they may spill over into other lanes, which would allow the player to deflect them while facing away.
It is recommended to use a line collider because it is infinitely thin, and thus runs the least risk.

If you are using PolarBullets, then a green_deflect_collider is already set up for you, running directly down the center of the bullet parallel to phi.
However, if you change the bullet's rotation or desire a different-shaped collider, you will have to set green_deflect_collider yourself.

If you want to change this behaviour entirely (e.g. to ignore the regular collider, or something else), then you can override collidesWith_greenDeflect in order to implement custom behaviour.

-- CUSTOM HANDLING WHEN DEFLECTED
To have something different happen when your bullet is deflected, override the :onGreenDeflect function.
It takes a single boolean, "crit", which tells you if the deflection was a critical or not.
```
-- Example: Move away instead of disappearing when deflected.
function MyCustomBullet:onGreenDeflect(crit)
    self:playGreenDeflectSound(crit)
    
    if not self.was_deflected then
        self.was_deflected = true
        
        -- Begin moving away instead of disappearing
        self.physics.speed = -self.physics.speed
        
        -- if a crit, move away twice as fast
        if crit then
            self.physics.speed = self.physics.speed*2
        end
    end
end
```

If you want to disable the "critical" flash effect and bonus TP gain, return true from the onGreenDeflect function.
```
function MyCustomBullet:onGreenDeflect(crit)
    return true
end
```
