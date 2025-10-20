local spell, super = Class(Spell, "ice_beam")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "IceBeam"
    -- Name displayed when cast (optional)
    self.cast_name = "ICEBEAM"

    -- Battle description
    self.effect = "Frostbite"
    -- Menu description
    self.description = "HOYL FUCK DID YOU JUST KILL SOMEONE OH MY GOD WHAT THE FUCK ARE YOU DOING"

    -- TP cost
    self.cost = 40

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"ice", "frost", "damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
    local target_x, target_y = target:getRelativePos(target.width/2, target.height/2, Game.battle)

    local function finishAnim()
        anim_finished = true
        if buster_finished then
            Game.battle:finishAction()
        end
    end

    local function createParticle(x, y)
        local sprite = Sprite("effects/icespell/snowflake", x, y)
        sprite:setOrigin(0.5, 0.5)
        sprite:setScale(1.5)
        sprite.layer = BATTLE_LAYERS["above_battlers"]
        Game.battle:addChild(sprite)
        return sprite
    end

    user:setAnimation("battle/spell", finishAnim)

    local damage = math.ceil((user.chara:getStat("magic") * 5) + (user.chara:getStat("attack") * 11) - (target.defense * 3))

    local particles = {}
    Game.battle.timer:script(function(wait)
        Assets.playSound("dtrans_square")
        local x, y = user:getRelativePos(user.width, user.height/2 + 5, Game.battle)
        local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
        local blast = IceBeamSpell(false, x, y, tx, ty, function(pressed)
            if pressed then
                damage = damage + 50
                Assets.playSound("dtrans_twinkle")
            end
            target:flash()
        end)
        blast.layer = BATTLE_LAYERS["above_ui"]
        Game.battle:addChild(blast)
        wait(0.5)
        wait(1/30)
        Assets.playSound("icespell")
        particles[1] = createParticle(target_x-25, target_y-20)
        wait(3/30)
        particles[2] = createParticle(target_x+25, target_y-20)
        wait(3/30)
        particles[3] = createParticle(target_x, target_y+20)
        wait(3/30)
        Game.battle:addChild(IceSpellBurst(target_x, target_y))
        for _,particle in ipairs(particles) do
            for i = 0, 5 do
                local effect = IceSpellEffect(particle.x, particle.y)
                effect:setScale(0.75)
                effect.physics.direction = math.rad(60 * i)
                effect.physics.speed = 8
                effect.physics.friction = 0.2
                effect.layer = BATTLE_LAYERS["above_battlers"] - 1
                Game.battle:addChild(effect)
            end
        end
        wait(1/30)
        for _,particle in ipairs(particles) do
            particle:remove()
        end
        wait(4/30)

        target:hurt(damage, user, function() target:freeze() end)

        Game.battle:finishActionBy(user)
    end)



    return false
end

return spell