local GueiChaser, super = Class(ChaserEnemy, "gueienemy")

function GueiChaser:init(data)
    super.init(self, data.properties["actor"], data.x, data.y, data.properties)

    properties = data.properties or {}

    if properties["sprite"] then
        self.sprite:setSprite(properties["sprite"])
    elseif properties["animation"] then
        self.sprite:setAnimation(properties["animation"])
    end

    if properties["facing"] then
        self:setFacing(properties["facing"])
    end

    self.encounter = properties["encounter"]
    self.enemy = properties["enemy"]
    self.group = properties["group"]

    self.path = properties["path"]
    self.speed = properties["speed"] or 6

    self.progress = (properties["progress"] or 0) % 1
    self.reverse_progress = false

    self.can_chase = properties["chase"]
    self.chasing = properties["chasing"] or false
    self.chase_dist = properties["chasedist"] or 200
    self.ignore_collision = properties["ignorecollision"] or true -- added that because in that one rooms Guei just attacks from above

    self.chase_type = properties["chasetype"] or "linear"
    self.chase_speed = properties["chasespeed"] or 9
    self.chase_max = properties["chasemax"]
    self.chase_accel = properties["chaseaccel"]

    self.pace_type = properties["pacetype"]
    self.pace_marker = TiledUtils.parsePropertyList("marker", properties)
    self.pace_interval = properties["paceinterval"] or 24
    self.pace_return  = properties["pacereturn"] or true
    self.pace_speed = properties["pacespeed"] or 4
    self.swing_divisor = properties["swingdiv"] or 24
    self.swing_length = properties["swinglength"] or 400

    self.chase_timer = 0
    self.pace_timer = 0

    -- Used for multiplier acceleration to keep acceleration consistent across framerates.
    self.chase_init_speed = self.chase_speed
    -- Starting x-coordinate of the enemy for pacing types.
    self.spawn_x = data.x
    -- Starting y-coordinate of the enemy for pacing types.
    self.spawn_y = data.y
    self.pace_index = 1
    self.wandering = false
    self.return_to_spawn = false

    self.noclip = true
    self.enemy_collision = true

    self.remove_on_encounter = true
    self.encountered = false
    self.once = properties["once"] or false
    self.chase_once = properties["chase_once"] or false

    if properties["aura"] == nil then
        self.sprite.aura = Game:getConfig("enemyAuras")
    else
        self.sprite.aura = properties["aura"]
    end
	self:setHitbox(20+5, 34+10, 20, 20)
	self.no_shadow = true
end

function GueiChaser:update()
    if self:isActive() then
        if self.path and self.world.map.paths[self.path] then
            local path = self.world.map.paths[self.path]

            if self.reverse_progress then
                self.progress = self.progress - (self.speed / path.length) * DTMULT
            else
                self.progress = self.progress + (self.speed / path.length) * DTMULT
            end
            if path.closed then
                self.progress = self.progress % 1
            elseif self.progress > 1 or self.progress < 0 then
                self.progress = MathUtils.clamp(self.progress, 0, 1)
                self.reverse_progress = not self.reverse_progress
            end

            self:snapToPath()
        elseif self.pace_type and not self.alert_icon and not self.chasing then
            self:paceMovement()
        end

        if self.alert_timer == 0 and self.can_chase and not self.chasing then
            if self.world.player then
                Object.startCache()
                local in_radius = self.world.player:collidesWith(CircleCollider(self.world, self.x, self.y, self.chase_dist))
                if in_radius then
                    local sight = LineCollider(self.world, self.x, self.y, self.world.player.x, self.world.player.y)
                    if self.ignore_collision or (not self.world:checkCollision(sight, true) and not self.world:checkCollision(self.collider, true)) then
						if not self:getFlag("dont_chase", false) then
							self.path = nil
							self.chasing = true
							self:onAlerted()
						end
                    end
                end
                Object.endCache()
            end
        elseif self.chasing then
            self:chaseMovement()
        end
    end

    super.super.update(self)
end

function GueiChaser:onEncounterEnd(primary, encounter)
    if self.remove_on_encounter then
        self:remove()
    else
        self.visible = true
    end
    if self.once then
        self:setFlag("dont_load", true)
    end
    if self.chase_once then
        self:setFlag("dont_chase", true)
    end
end

function GueiChaser:onCollide(player)
    if self:isActive() and player:includes(Player) then
        self.encountered = true
        local encounter = self.encounter
        if not encounter and Registry.getEnemy(self.enemy or self.actor.id) then
            encounter = Encounter()
            encounter:addEnemy(self.actor.id)
        end
        if encounter then
            self.world.encountering_enemy = true
			self.sprite:setAnimation("encounter")
			local pl = Game.world.player
			local px = pl.x - pl.width/2
			local py = pl.y
			Game.world.timer:tween(20/30, self, {x = px + 80}, "out-quart")
			Game.world.timer:tween(20/30, self, {y = py}, "out-quad")
            self.sprite.aura = false
            Game.lock_movement = true
            self.world.timer:script(function(wait)
				Assets.playSound("cough", 1, 1.4)
				Assets.playSound("paper_rise", 0.7, 1.2)
				Assets.playSound("paper_rise", 0.4, 1.8)
				Assets.playSound("ghostappear", 1, 1.6)
                wait(34/30)
                Assets.playSound("tensionhorn")
                wait(10/30)
                local src = Assets.playSound("tensionhorn")
                src:setPitch(1.1)
                wait(24/30)
                self.world.encountering_enemy = false
                Game.lock_movement = false
                local enemy_target = self
                if self.enemy then
                    enemy_target = {{self.enemy, self}}
                end
                Game:encounter(encounter, true, enemy_target, self)
            end)
        end
    end
end

return GueiChaser