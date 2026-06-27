local ChaserEnemy, super = HookSystem.hookScript(ChaserEnemy)

function ChaserEnemy:init(actor, x, y, properties)
    super.init(self, actor, x, y, properties)
    properties = properties or {}
    self.floradinn_jump_marker = properties["jumpmarker"]
    self.floradinn_jump_strength = properties["jumpstrength"]
	self.did_ambush = false
end

function ChaserEnemy:paceMovement()
	super.paceMovement(self)
    if self.pace_type == "floradinn_ambush" then
		local in_radius = self.world.player:collidesWith(CircleCollider(self.world, self.x, self.y, self.chase_dist))
        if in_radius and not self.did_ambush then
			self.collidable = false
			Assets.playSound("board_throw", 0.7)
			self:jumpTo(self.floradinn_jump_marker, self.floradinn_jump_strength, 20/30, nil, nil)
			Game.world.timer:after(20/30, function()
				self:setAnimation("overworld")
				self.collidable = true
				Game.world.timer:after(5/30, function()
					self.pace_type = "wander_nospawn"
					self:setWalkSprite("overworld")
					self:setAnimation("overworld")
					self.can_chase = true
				end)
			end)
			self.did_ambush = true
		end
	elseif self.pace_type == "wander_nospawn" then
        if self.pace_timer < self.pace_interval or self.wandering then
            return
        end

        self.wandering = true
        self:walkToSpeed(self.pace_marker[self.pace_index], self.pace_speed, nil, false, function() self.pace_timer = 0; self.wandering = false end)
        self.pace_index = MathUtils.wrapIndex(self.pace_index + 1, #self.pace_marker)
	end
end

return ChaserEnemy