local VoidspawnChaser, super = Class(ChaserEnemy, "voidenemy")

function VoidspawnChaser:init(data)
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
    self.chase_dist = properties["chasedist"] or 100

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
    self.alert_type = properties["alerttype"] or 0

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

	self.sprite.aura = false
	self.collider = CircleCollider(self, 31, 31, 29)
	self.no_shadow = true
	self.spawn_attack_loop = Assets.newSound("spawn_attack")
	self.spawn_attack_loop:setPitch(1.2)
	self.spawn_attack_loop:setLooping(true)
end

function VoidspawnChaser:onAdd(parent)
	super.onAdd(self, parent)
end

function VoidspawnChaser:update()
    if self:isActive() then
        if self.can_chase and not self.chasing then
            if self.world.player then
                Object.startCache()
				local in_radius = false
				if self.alert_type == 0 then
					in_radius = self.world.player:collidesWith(Hitbox(self.world, self.x - self.chase_dist/2, self.y, self.chase_dist, SCREEN_HEIGHT))
                end
				if in_radius then
                    if not self:getFlag("dont_chase", false) then
						self.path = nil
						Assets.stopAndPlaySound("spearappear_choppy", 1, 0.66)
						Assets.stopAndPlaySound("giygastalk", 0.7, 1.2)
						self.spawn_attack_loop:play()
						self.sprite:setEyeState("FOLLOWING")
						self.world.timer:after(10/30, function()
							self.sprite.trail_speed = 1
							self.sprite:setBodyState("CHASETRAIL")
							self.chasing = true
						end)
						self.can_chase = false
						self:onAlerted()
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

function VoidspawnChaser:onEncounterEnd(primary, encounter)
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

function VoidspawnChaser:onCollide(player)
    if self:isActive() and player:includes(Player) then
        self.encountered = true
        local encounter = self.encounter
        if not encounter and Registry.getEnemy(self.enemy or self.actor.id) then
            encounter = Encounter()
            encounter:addEnemy(self.actor.id)
        end
        if encounter then
			self.spawn_attack_loop:stop()
			self.sprite.eye_center = true
			self.sprite:setBodyState("ENCOUNTER")
            self.world.encountering_enemy = true
			self.sprite:setAnimation("encounter")
			self.layer = WORLD_LAYERS["above_events"]
            self.sprite.aura = false
            Game.lock_movement = true
            self.world.timer:script(function(wait)
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
				self.darkness_unlit = false
                Game:encounter(encounter, true, enemy_target, self)
            end)
        end
    end
end

return VoidspawnChaser