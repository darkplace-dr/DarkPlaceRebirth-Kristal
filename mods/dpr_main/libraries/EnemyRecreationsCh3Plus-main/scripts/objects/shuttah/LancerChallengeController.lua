local LancerChallengeController, super = Class(Object)

function LancerChallengeController:init()
    super.init(self, SCREEN_WIDTH / 2, 250)

    self.camera_collider = nil
	
    self.lancer = ActorSprite("lancertongue")
    self.lancer:setScale(2)
    self.lancer:setOrigin(0.5, 1)
    self:addChild(self.lancer)
    self.collider = Hitbox(self.lancer, 14, 23, 16, 10)
    self.lancer.collider = self.collider

    -- All possible actions: "WAVE", "WALK", "JUMP_PREPARE", "JUMP", "TONGUE", "DROP_DOWN"
    self.current_action = "WAVE"
    if Utils.random(1, 7, 1) == 1 then -- Theres a small chance he jumps immediately I think?????
        self.current_action = "JUMP_PREPARE"
    end

    local limit_width = 360
    self.min_x = SCREEN_WIDTH / 2 - limit_width / 2
    self.max_x = SCREEN_WIDTH / 2 + limit_width / 2
    self.max_y = 250

    self.idle = false
    self.action = false
    self.idle_timer = 0
    self.action_timer = 0
    self.walk_animation = false
    self.last_jump = 0
    self.actions_done = 0

    self:startAction()
end

function LancerChallengeController:startAction()
    self.idle = false
    self.action = false
    if self.current_action == "WAVE" then
        self.lancer:setAnimation("wave", function()
            self.idle_timer = 15
            self.idle = true
        end)
    elseif self.current_action == "WALK" then
        if Utils.random(1, 2, 1) == 1 then
            self:setPhysics({ speed_x = 8 })
        else
            self:setPhysics({ speed_x = -8 })
        end
        if Utils.random(1, 3, 1) == 1 then
            self.lancer:setAnimation("up_flip")
            self.walk_animation = "up_flip"
        else
            local animation = Utils.pick({"walk/right", "walk/left"})
            self.lancer:setSprite(animation)
            self.walk_animation = animation
        end
        self.action_timer = 8
        self.action = true
    elseif self.current_action == "JUMP_PREPARE" then
        self.lancer:setAnimation("jump_prepare")
        self.action_timer = 10
        self.action = true
    end
end

function LancerChallengeController:processActionEnd()
    self.action = false
    if self.current_action == "WALK" then
        if Utils.random(1, 3, 1) == 1 then
            self.lancer:setSprite("walk/down")
        else
            self.lancer:setAnimation("up_flip")
        end
        self:resetPhysics()
        self.idle_timer = 15
        self.idle = true
    elseif self.current_action == "JUMP_PREPARE" then
        local multiplier = Utils.random(1, 2)
        self:setPhysics({
            speed_y = -8 * multiplier,
            gravity = 1,
            speed_x = Utils.pick({-2, 2}) * multiplier
        })
        self.lancer:setAnimation("spin")
        self.current_action = "JUMP"
        self.action_timer = 8 * multiplier
        self.action = true
    elseif self.current_action == "JUMP" then
        self:resetPhysics()
        self.lancer:setAnimation("tongue")
        self.current_action = "TONGUE"
        self.action_timer = 999
        self.action = true
    elseif self.current_action == "TONGUE" then
        self.lancer:setSprite("walk/down")
        self.current_action = "DROP_DOWN"
        self:setPhysics({
            gravity = 1
        })
    end
end

function LancerChallengeController:update()
    super.update(self)

    if self.idle then
        self.idle_timer = self.idle_timer - DTMULT
    end

    if self.action then
        self.action_timer = self.action_timer - DTMULT
    end

    if Utils.containsValue({"WALK", "JUMP"}, self.current_action) then
        if self.x < self.min_x or self.x > self.max_x then
            self.physics.speed_x = -self.physics.speed_x
            if self.walk_animation == "walk/right" then self.lancer:setSprite("walk/left")
            elseif self.walk_animation == "walk/left" then self.lancer:setSprite("walk/right") end
        end
    end

    if self.action and self.action_timer < 0 then
        self:processActionEnd()
    end

    if self.current_action == "DROP_DOWN" and self.y > self.max_y then
        self:resetPhysics()
        self.y = self.max_y
        self.idle_timer = 12
        self.idle = true
    end

    if self.idle and self.idle_timer < 0 then
        self:resetPhysics()
        local actions_since_last_jump = self.actions_done - self.last_jump
        if Utils.random(actions_since_last_jump, 3) > 2 and actions_since_last_jump >= 1 then
            self.current_action = "JUMP_PREPARE"
            self.last_jump = self.actions_done + 1
        else
            self.current_action = Utils.pick({"WALK", "WAVE"})
        end
        self.actions_done = self.actions_done + 1
        self:startAction()
    end
end

function LancerChallengeController:getCameraSpawn()
    return SCREEN_WIDTH / 2, 175
end

function LancerChallengeController:checkSuccessAction()
    return self.camera_collider:collidesWith(self.collider) and self.current_action == "TONGUE"
end

function LancerChallengeController:checkSuccessFinal()
    return self:checkSuccessAction()
end

return LancerChallengeController