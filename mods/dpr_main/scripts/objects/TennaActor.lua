---@class TennaActor: ActorSprite
local TennaActor, super = Class(ActorSprite)

function TennaActor:init(actor)
    super.init(self, actor)

    self:setAnimation(self.actor.default)

    self:setScale(1)
    self:setScaleOrigin(0.5, 1)

    self.xscale = 2
    self.yscale = 2
    self.cur_xscale = 1
    self.cur_yscale = 1

    if self.texture then
        self.vertices = {
            {0, 0,
            0, 0,
            1, 1, 1},
            {self.texture:getWidth(), 0,
            1, 0,
            1, 1, 1},
            {self.texture:getWidth(), self.texture:getHeight(),
            1, 1,
            1, 1, 1},
            {0, self.texture:getHeight(),
            0, 1,
            1, 1, 1}
        }
        self.mesh = love.graphics.newMesh(self.vertices, "fan")
        self.mesh:setTexture(self.texture)
    end

    self.facing = "down" -- up, down, left, right

    self.wobblestate = 0
    self.wobbleamt = 8
    self.wobbletime = 4
    self.drawtype = 0
    self.reversal = 0

    self.speedscale = 1
    self.animchangetimer = 0
    self.changespeed = 20

    self.shakeamt = 0
    self.shaketime = 1
    self.shaketimer = 0
    self.shakex = 0
    self.shakey = 0
    
    self.scaled_bounce = false
    self.bounce = 0

    self.pointcon = 0

    self.rate = 0
    self.shtimer = 0

    self.siner = 0
    self.siner0 = 0
    self.siner1 = 0
    self.siner2 = 0

    self.rosecon = 0
    self.rosetimer = 0
    self.rosetennasprite = nil

    self.animsiner = 0
    self.animsinerb = 0
    self.armshake = 1
    self.armshakesiner = 0
	
	
    --battle idle sprites
    self.battle_leg_l = Sprite("world/npcs/tenna/battle/leg_l", 58-28, 135-17)
    self.battle_leg_l:setOriginExact(45, 115)
    self.battle_leg_l.visible = false
    self.battle_leg_l.debug_select = false
    self:addChild(self.battle_leg_l)

    self.battle_leg_r = Sprite("world/npcs/tenna/battle/leg_r", 58-28, 135-17)
    self.battle_leg_r:setOriginExact(45, 115)
    self.battle_leg_r.visible = false
    self.battle_leg_r.debug_select = false
    self:addChild(self.battle_leg_r)

    self.battle_tails = Sprite("world/npcs/tenna/battle/tails", 58-28, 135-17)
    self.battle_tails:setOriginExact(45, 115)
    self.battle_tails.visible = false
    self.battle_tails.debug_select = false
    self:addChild(self.battle_tails)

    self.battle_arm_back = Sprite("world/npcs/tenna/battle/arm_back", 58-28, 135-17)
    self.battle_arm_back:setOriginExact(45, 115)
    self.battle_arm_back.visible = false
    self.battle_arm_back.debug_select = false
    self:addChild(self.battle_arm_back)
	
    self.battle_torso = Sprite("world/npcs/tenna/battle/torso", 58-28, 135-17)
    self.battle_torso:setOriginExact(45, 115)
    self.battle_torso.visible = false
    self.battle_torso.debug_select = false
    self:addChild(self.battle_torso)

    self.battle_tie = Sprite("world/npcs/tenna/battle/tie", 58-28, 135-17)
    self.battle_tie:setOriginExact(45, 115)
    self.battle_tie.visible = false
    self.battle_tie.debug_select = false
    self:addChild(self.battle_tie)

    self.battle_face = Sprite("world/npcs/tenna/battle/face", 58-28, 135-17)
    self.battle_face:setOriginExact(45, 115)
    self.battle_face.visible = false
    self.battle_face.debug_select = false
    self:addChild(self.battle_face)

    self.battle_arm_front = Sprite("world/npcs/tenna/battle/arm_front", 58-28, 135-17)
    self.battle_arm_front:setOriginExact(45, 115)
    self.battle_arm_front.visible = false
    self.battle_arm_front.debug_select = false
    self:addChild(self.battle_arm_front)
	
	
    --segmented laugh_pose sprites
    self.laugh_leftarm = Sprite("world/npcs/tenna/laugh_pose_segmented/leftarm", 58-28, 135-17)
    self.laugh_leftarm:setOriginExact(42, 92)
    self.laugh_leftarm.visible = false
    self.laugh_leftarm.debug_select = false
    self:addChild(self.laugh_leftarm)

    self.laugh_body = Sprite("world/npcs/tenna/laugh_pose_segmented/body", 58-28, 135-17)
    self.laugh_body:setOriginExact(42, 92)
    self.laugh_body.visible = false
    self.laugh_body.debug_select = false
    self:addChild(self.laugh_body)
	
    self.laugh_rightarm = Sprite("world/npcs/tenna/laugh_pose_segmented/rightarm", 58-28, 135-17)
    self.laugh_rightarm:setOriginExact(42, 92)
    self.laugh_rightarm.visible = false
    self.laugh_rightarm.debug_select = false
    self:addChild(self.laugh_rightarm)
	
    self.changed_to_segmented_laugh = false
end

function TennaActor:setFacing(facing)
    self.facing = facing
    if facing == "right" then
        self.reversal = 1
    end
    if facing == "left" then
        self.reversal = 0
    end
end

function TennaActor:resetMesh()
    if self.texture then
        self.vertices = {
            {0, 0,
            0, 0,
            1, 1, 1},
            {self.texture:getWidth(), 0,
            1, 0,
            1, 1, 1},
            {self.texture:getWidth(), self.texture:getHeight(),
            1, 1,
            1, 1, 1},
            {0, self.texture:getHeight(),
            0, 1,
            1, 1, 1}
        }
        self.mesh = love.graphics.newMesh(self.vertices, "fan")
        self.mesh:setTexture(self.texture)
    end
end

function TennaActor:setPreset(preset)
    local preset = preset or 0

    self.drawtype = 0
    if preset ~= -1 then
        if preset == 0 then     -- disable wobbling
            self.wobblestate = 0
            self.wobbletime = 0
            self.wobbleamt = 0
            self.drawtype = 1
        end
        if preset == 1 then     -- tenna laugh pose
            self:setAnimation("laugh_pose")
            self.wobblestate = 1
            self.wobbletime = 4
            self.wobbleamt = 10
        end
        if preset == 2 then     -- tenna point up
            self:setAnimation("point_up")
            self.wobblestate = 1
            self.wobbletime = 4
            self.wobbleamt = 8
        end
        if preset == -2 then
            self.wobblestate = 1
            self.wobbletime = 4
            self.wobbleamt = 8
        end
        if preset == -3 then    -- tenna pose podium 1
            self:setSprite("pose_podium_1")
            self.wobblestate = 1
            self.wobbletime = 4
            self.wobbleamt = 30
        end
        if preset == 2.5 then   -- tenna point top (used for the shadowguy encounter in the doom board iirc)
            self:setAnimation("point_top")
            self.wobblestate = 1
            self.wobbletime = 4
            self.wobbleamt = 8
        end
        if preset == 3 then     -- tenna listening
            self:setSprite("listening")
            self.wobblestate = 1
            self.wobbletime = 4
            self.wobbleamt = 30
        end
        if preset == 4 then     -- tenna laugh pose (reversal)
            self:setSprite("laugh_pose")
            self.wobblestate = 3
            self.wobbletime = 3
            self.wobbleamt = 15
        end
        if preset == 5 then     -- tenna excited pointing
            self.reversal = 0
            self.wobblestate = 4
            self.animchangetimer = 8
            self.changespeed = 20
            self.wobbletime = 4
            self.wobbleamt = 40
        end
        if preset == 6 then     -- tenna bow 1
            self:setAnimation("bow")
            self.wobblestate = 5
            self.wobbletime = 3
            self.wobbleamt = 10
        end
        if preset == 7 then     -- tenna sad
            self:setSprite("sad")
            self.wobblestate = 6
            self.wobbletime = 12
            self.wobbleamt = 20
        end
        if preset == 8 then
            self.wobblestate = 6
            self.wobbletime = 1
            self.wobbleamt = 2
        end
        if preset == 9 then
            self.wobblestate = 7
            self.wobbletime = 0.5
            self.wobbleamt = 2
        end
        if preset == 10 then
            self.wobblestate = 0
            self.wobbletime = 0
            self.wobbleamt = 0
            self.drawtype = 1
        end
        if preset == 11 then    -- tenna bow 2
            self:setAnimation("bow")
            self.wobblestate = 8
            self.wobbletime = 1
            self.wobbleamt = 10
        end
        if preset == 12 then    -- tenna grasp anim
            self:setAnimation("grasp_anim")
            self.wobblestate = 1
            self.wobbletime = 2
            self.wobbleamt = 20
        end
        if preset == 13 then    -- tenna grasp anim b
            self:setAnimation("grasp_anim_b")
            self.wobblestate = 6
            self.wobbletime = 2
            self.wobbleamt = 20
            self.drawtype = 1
        end
        if preset == 14 then    -- tenna evil
            self:setSprite("evil")
            self.wobblestate = 7
            self.wobbletime = 1
            self.wobbleamt = 2
        end
        if preset == 15 then
            self.wobblestate = 6
            self.wobbletime = 0.5
            self.wobbleamt = 6
        end
        if preset == 16 then
            self.wobblestate = 10
            self.wobbletime = 3
            self.wobbleamt = 30
        end
        if preset == 17 then    -- tenna dance cane 2
            self:setAnimation("dance_cane")
            self.wobblestate = 0
            self.wobbletime = 0
            self.wobbleamt = 0
            self.drawtype = 1
        end
        if preset == 18 then    -- tenna excited pointing 2
            self.reversal = 0
            self.wobblestate = 4
            self.animchangetimer = 4
            self.wobbletime = 4
            self.wobbleamt = 40
        end
        if preset == 19 then    -- tenna flower nose bloom
            self.rosecon = 1
            self.rosetimer = 0
            self.drawtype = 3
            --self.scale_x = 0.5 * Utils.sign(self.scale_x)
            --self.scale_y = 0.5
        end
        if preset == 20 then
            self.wobblestate = 5
            self.wobbletime = 3
            self.wobbleamt = 30
        end
        if preset == 21 then    -- tenna point at screen
            self:setSprite("point_at_screen")
            self.wobblestate = 12
            self.wobbletime = 4.5
            self.wobbleamt = 7
            self.drawtype = 0
        end
        if preset == -21 then
            self.wobblestate = 12
            self.wobbletime = 4.5
            self.wobbleamt = 7
            self.drawtype = 0
        end
        if preset == 22 then    -- tenna pose
            self:setSprite("pose")
            self.wobblestate = 7
            self.wobbletime = 2.4
            self.wobbleamt = 5.9
        end
        if preset == 23 then    -- tenna blossom animation
            self.wobblestate = 8
            self.wobbletime = 6
            self.wobbleamt = 7.7
        end
        if preset == 24 then    -- tenna dance cabbage
            self:setAnimation("dance_cabbage")
            self.wobblestate = 8
            self.wobbletime = 6
            self.wobbleamt = 7.7
        end
        if preset == 25 then    -- tenna dance cane 2
            self:setAnimation("dance_cane")
            self.wobblestate = 8
            self.wobbletime = 6
            self.wobbleamt = 7.7
        end
        if preset == 26 then 
            self.wobblestate = 5.5
            self.wobbletime = 10
            self.wobbleamt = 40
            self.siner = 1.5707963267948966 * self.wobbletime
        end
        if preset == 27 then    -- tenna hooray 1
            self:setSprite("hooray_1")
            self.bounce = 0
        end
        if preset == 28 then    -- tenna hooray 2
            self:setSprite("hooray_4")
            self.wobblestate = 1
            self.wobbletime = 10
            self.wobbleamt = 30
            self.bounce = 1
        end
        if preset == 30 then    -- tenna twirl
            self:setAnimation("twirl")
            self.wobblestate = 0
            self.wobbletime = 0
            self.wobbleamt = 0
            self.drawtype = 1
        end
        if preset == 31 then 
            self.wobblestate = 12
            self.wobbletime = 5
            self.wobbleamt = 15
            self.bounce = 0
        end
        if preset == 32 then    -- tenna pose 2
            self:setSprite("pose")
            self.wobblestate = 12
            self.wobbletime = 4.5
            self.wobbleamt = 7
        end
        if preset == -32 then
            self.wobblestate = 12
            self.wobbletime = 4.5
            self.wobbleamt = 7
        end
        if preset == 33 then 
            self.reversal = 0
            self.wobblestate = 8
            self.wobbletime = 4
            self.wobbleamt = 40
        end
        if preset == 34 then 
            self.reversal = 0
            self.wobblestate = 13
            self.changespeed = 15
            self.animchangetimer = 0
            self.pointcon = 0
            self.wobbletime = 4
            self.wobbleamt = 10
        end
        if preset == 35 then    -- tenna laugh pose (segmented)
            self.reversal = 0
            self.wobblestate = -1
            self.rate = 2
            self.shtimer = 0
            self.pointcon = 0
            self.drawtype = 2
        end
        if preset == 36 then 
            self.reversal = 0
            self.drawtype = 0
            self.siner = 0
            self.wobbletime = 10
            self.wobbleamt = 16
        end
        if preset == 37 then 
            self.reversal = 0
            self.drawtype = 0
            self.siner = 0
            self.wobbletime = 10
            self.wobbleamt = 14
        end
        if preset == 69 then    -- tenna bulletin
            self:setAnimation("bulletin")
            self.wobblestate = 6
            self.wobbletime = 4
            self.wobbleamt = 20
            self.drawtype = 0
        end

        preset = -1
    end
end

function TennaActor:setBounce(bounce, scaled)
    self.bounce = bounce or 0
    self.scaled_bounce = scaled or false
end

function TennaActor:setShaking(amount)
    self.shakeamt = amount
end

function TennaActor:update()
    if self.shakeamt > 0 then
        self.shaketimer = self.shaketimer - DTMULT

        if self.shaketimer <= 0 then
            self.shakex = Utils.random(-self.shakeamt, self.shakeamt)
            self.shakey = Utils.random(-self.shakeamt, self.shakeamt)
            self.shaketimer = self.shaketime
        end
    else
        self.shakex = 0
        self.shakey = 0
    end

    if self.anim == "idle" and self.drawtype == 0 then
        self.battle_leg_l.visible = true
        self.battle_leg_r.visible = true
        self.battle_tails.visible = true
        self.battle_arm_back.visible = true
        self.battle_torso.visible = true
        self.battle_tie.visible = true
        self.battle_face.visible = true
        self.battle_arm_front.visible = true
		
        self.animsiner = self.animsiner + DTMULT
			
        local bx = (math.sin(self.animsiner / 6) * 5) / 2
        local by = (-math.abs(math.cos(self.animsiner / 4)) * 5) / 2
        local armx = (math.sin(self.animsiner / 6) * 9) / 2
        local army = (math.cos(self.animsiner / 6) * 6) / 2
        local headx = (math.sin(self.animsiner / 6) * 8) / 2
        local heady = ((math.sin(self.animsiner / 6) * 6) + 4) / 2
        local legx = (math.sin((self.animsiner + 4) / 6) * 5) / 2
        local legy = (math.cos(self.animsiner / 6) * 2) / 2
			
        self.animsinerb = self.animsinerb + DTMULT
			
        local image = self.animsiner / 6
        local loopimage = 1.5 + (math.sin(image) * 1.5)
        local loopimage1 = 1 + (math.sin(image) * 1)
        local tailimage = image
			
        self.armshake = self.armshake * -1
        self.armshakesiner = self.armshakesiner + DTMULT
        local chargingup = 1
        local armshakevalue = Utils.clamp((math.sin((self.armshakesiner / 18) - 1) * 1.5) - 1, 0, 4)
        local armshakey = armshakevalue * self.armshake
			
        local headimage = 3
            
        if (chargingup == 0) then
            armshakey = 0
            armshakevalue = 0
        end

        self.battle_leg_l:setFrame(math.floor(image))
        self.battle_leg_l.x = (58-28) - legx
        self.battle_leg_l.y = (135-17) + legy
			
        self.battle_leg_r:setFrame(math.floor(image))
        self.battle_leg_r.x = (58-28) + legx
        self.battle_leg_r.y = (135-17) - (legy / 4)


        self.battle_tails:setFrame(math.floor(tailimage))
        self.battle_tails.x = ((58-28) + (bx / 2)) - 4
        self.battle_tails.y = (135-17) + by

        self.battle_arm_back:setFrame(math.floor(4 - loopimage))
        self.battle_arm_back.x = ((58-28) + bx) - (armx * 1.5) + 12
        self.battle_arm_back.y = ((135-17) + by) - army

        self.battle_torso:setFrame(1)
        self.battle_torso.x = (58-28) + bx
        self.battle_torso.y = (135-17) + by

        self.battle_tie:setFrame(1)
        self.battle_tie.x = (58-28) + bx
        self.battle_tie.y = (135-17) + by

        self.battle_face:setFrame(headimage - math.floor(armshakevalue * 6))
        self.battle_face.x = (((58-28) + bx) - headx) + 2 + (armshakey / 2)
        self.battle_face.y = ((135-17) + by + heady) - 2 - (armshakey / 2)

        self.battle_arm_front:setFrame(math.floor(1 + loopimage))			
        self.battle_arm_front.x = (((58-28) + bx) - armx) + armshakey
        self.battle_arm_front.y = (((135-17) + by) + army) + armshakey

    else
        self.battle_leg_l.visible = false
        self.battle_leg_r.visible = false
        self.battle_tails.visible = false
        self.battle_arm_back.visible = false
        self.battle_torso.visible = false
        self.battle_tie.visible = false
        self.battle_face.visible = false
        self.battle_arm_front.visible = false
    end
    if self.drawtype == 2 then
        if self.changed_to_segmented_laugh == false then
            self:setAnimation("laugh_pose_segmented")
            self.changed_to_segmented_laugh = true
        end

        self.shtimer = self.shtimer + DTMULT

        self.laugh_leftarm.visible = true
        self.laugh_body.visible = true
        self.laugh_rightarm.visible = true

        self.laugh_leftarm.x = (58-28) + ((math.sin(self.shtimer / self.rate) * 2) + 3) 
        self.laugh_leftarm.y = (135-17) + (math.cos(self.shtimer / self.rate) * 2)

        self.laugh_body.scale_y = 1 + (math.sin(self.shtimer / self.rate) * 0.05)

        self.laugh_rightarm.x = (58-28) - ((math.sin(self.shtimer / self.rate) * 2) + 3)
        self.laugh_rightarm.y = (135-17) - (-math.cos(self.shtimer / self.rate) * 2)
    else
        self.laugh_leftarm.visible = false
        self.laugh_body.visible = false
        self.laugh_rightarm.visible = false

        self.changed_to_segmented_laugh = false
    end

    super.update(self)
end

function TennaActor:draw()
    self.siner = self.siner + self.speedscale * DTMULT
    self.siner0 = self.siner0 + self.speedscale * DTMULT
    self.siner1 = self.siner1 + self.speedscale * DTMULT
    self.siner2 = self.siner2 + self.speedscale * DTMULT
	
    if not self.scaled_bounce then
        if self.bounce == 1 then
            self.scale_y = 1.25
            self.scale_x = (self.scale_x < 0) and -0.75 or 0.75
            self.bounce = 2
        end
        if self.bounce == 2 then
            local target_scale = (self.scale_x < 0) and -1 or 1
            Game.stage.timer:lerpVar(self, "scale_x", self.scale_x, target_scale, 16, -2, "out")
            Game.stage.timer:lerpVar(self, "scale_y", self.scale_y, 1, 16, -2, "out")
            self.bounce = 3
        end
        if self.bounce == 3 then
            if self.scale_y <= (2.01 / 2) then
                self.scale_y = 1
                self.bounce = 0
            end
        end
    else
        if self.bounce == 1 then
            self.cur_xscale = self.scale_x
            self.cur_yscale = self.scale_y
            self.bounce = 2
        end
        if self.bounce == 2 then
            self.scale_y = self.cur_yscale * (1.25 / 2)
            self.scale_x = self.cur_xscale * (0.75 / 2)
            self.bounce = 3
        end
        if self.bounce == 3 then
            Game.stage.timer:lerpVar(self, "scale_x", self.scale_x, self.cur_xscale, 16, -2, "out")
            Game.stage.timer:lerpVar(self, "scale_y", self.scale_y, self.cur_yscale, 16, -2, "out")
            self.bounce = 4
        end
        if self.bounce == 4 then
            if (self.scale_y <= (self.cur_yscale + (0.1 / 2))) then
                self.scale_y = self.cur_yscale
                self.bounce = 0
            end
        end
    end
    
    if self.texture and self.mesh then
        self.mesh:setTexture(self.texture)
		
        self.x1 = 0
        self.y1 = 0
        self.x2 = self.texture:getWidth() * 2
        self.y2 = 0
        self.x3 = self.texture:getWidth() * 2
        self.y3 = self.texture:getHeight() * 2
        self.x4 = 0
        self.y4 = self.texture:getHeight() * 2
		
        local reversalsign = 1
        if self.reversal == 1 then
            reversalsign = -1
        end

        local wobblestate = self.wobblestate
        local wobbleamt = self.wobbleamt
        local wobbletime = self.wobbletime
		
        local _keep_pivot = false
		
        if wobblestate == 1 then
            self.x1 = self.x1 + (math.abs(math.sin(self.siner / wobbletime) * wobbleamt) * reversalsign)
            self.x2 = self.x2 + (math.abs(math.sin(self.siner / wobbletime) * wobbleamt) * reversalsign)
            self.y1 = self.y1 - math.abs(math.sin(self.siner / wobbletime) * wobbleamt)
            self.y2 = self.y2 + math.abs(math.sin(self.siner / wobbletime) * wobbleamt)
        end
        if wobblestate == 2 then
            self.x1 = self.x1 + (math.sin(self.siner / wobbletime) * 10) * reversalsign
            self.x2 = self.x2 + (math.sin(self.siner / wobbletime) * 10) * reversalsign
            self.y1 = self.y1 - math.abs(math.sin(self.siner / wobbletime) * 0.9) * 14
            self.y2 = self.y2 + math.abs(math.sin(self.siner / wobbletime) * 1.1) * 14
        end
        if wobblestate == 3 then
            if math.sin(self.siner / wobbletime) < 0 then
                self.reversal = 1
            else
                self.reversal = 0
            end
            local addamt = math.abs(math.sin(self.siner / wobbletime) * wobbleamt)
            local addamt2 = addamt
            if self.reversal == 1 then
                addamt = -addamt
            end
            self.x1 = self.x1 + addamt
            self.x2 = self.x2 + addamt
            self.y1 = self.y1 - addamt2
            self.y2 = self.y2 + addamt2
        end
        if wobblestate == 4 then
            self.siner = self.siner - (self.speedscale - 1) * DTMULT
            self.animchangetimer = self.animchangetimer + self.speedscale * DTMULT
    
            if self.animchangetimer >= self.changespeed and self.pointcon == 0 then
                self.reversal = 0
                self:setSprite("point_left")
                self:setBounce(1)
                self.pointcon = self.pointcon + 1
            end
    
            if self.animchangetimer >= (self.changespeed * 2) and self.pointcon == 1 then
                self.reversal = 0
                self:setSprite("point_up")
                self.x1 = 0
                self.y1 = 0
                self.x2 = self.texture:getWidth() * 2
                self.y2 = 0
                self.x3 = self.texture:getWidth() * 2
                self.y3 = self.texture:getHeight() * 2
                self.x4 = 0
                self.y4 = self.texture:getHeight() * 2
                self:setBounce(1)
                self.pointcon = self.pointcon + 1
            end
    
            if self.animchangetimer >= (self.changespeed * 3) and self.pointcon == 2 then
                self:setSprite("point_left")
                self.reversal = 1
                self:setBounce(1)
                self.pointcon = self.pointcon + 1
            end
    
            if self.animchangetimer >= (self.changespeed * 4) then
                self.reversal = 1
                self:setSprite("point_up")
                self.x1 = 0
                self.y1 = 0
                self.x2 = self.texture:getWidth() * 2
                self.y2 = 0
                self.x3 = self.texture:getWidth() * 2
                self.y3 = self.texture:getHeight() * 2
                self.x4 = 0
                self.y4 = self.texture:getHeight() * 2
                self:setBounce(1)
                self.animchangetimer = 0
                self.pointcon = 0
            end
    
            if self.pointcon == 3 then
                _keep_pivot = true
            end
    
            local addamt = math.abs(math.sin(self.siner / wobbletime) * wobbleamt)
            local addamt2 = addamt
    
            if self.reversal == 1 then
                addamt = -addamt
            end
    
            self.x1 = self.x1 + addamt
            self.x2 = self.x2 + addamt
            self.y1 = self.y1 - addamt2
            self.y2 = self.y2 + addamt2
        end
        if wobblestate == 5 then
            if math.sin(self.siner / wobbletime) < 0 then
                self.reversal = 1
            else
                self.reversal = 0
            end
            local addamt = math.abs(math.sin(self.siner / wobbletime) * wobbleamt)
            local addamt2 = addamt
            if self.reversal == 1 then
                addamt = -addamt
            end
            self.x1 = self.x1 + addamt
            self.x2 = self.x2 + addamt
            self.y1 = self.y1 - addamt2
            self.y2 = self.y2 + addamt2
        end
        if wobblestate > 5 and wobblestate < 6 then
            if wobblestate == 5.5 then
                self.x1 = self.x1 + ((math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt) * reversalsign)
                self.x2 = self.x2 + ((math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt) * reversalsign)
                self.y1 = self.y1 - (math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt)
                self.y2 = self.y2 + ((math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt) / 2)
        
                if (math.sin((self.siner + 1) / wobbletime) <= 0.5) then
                    wobblestate = 5.6
                    self:setSprite("sad")
                end
            end
    
            if wobblestate == 5.6 then
                self.x1 = self.x1 + ((math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - (wobbleamt / 2)) * reversalsign)
                self.x2 = self.x2 + ((math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - (wobbleamt / 2)) * reversalsign)
                self.y1 = self.y1 - (math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - (wobbleamt / 2))
                self.y2 = self.y2 + ((math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - (wobbleamt / 2)) / 2)
        
                if (math.sin((self.siner + 1) / wobbletime) <= 0) then
                    self:setPreset(7)
                end
            end
        end
        if wobblestate == 6 then
            self.x1 = self.x1 + ((math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt) * reversalsign)
            self.x2 = self.x2 + ((math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt) * reversalsign)
            self.y1 = self.y1 - (math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt)
            self.y2 = self.y2 + (math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt) / 2
        end
        if wobblestate == 7 then
            self.x1 = self.x1 + ((math.sin(self.siner / wobbletime) * wobbleamt) * reversalsign)
            self.x2 = self.x2 + ((math.sin(self.siner / wobbletime) * wobbleamt) * reversalsign)
            self.y1 = self.y1 - ((math.sin((self.siner / wobbletime) * 0.5) - wobbleamt) / 2) * -1
            self.y2 = self.y2 + (math.sin((self.siner / wobbletime) * 0.5) * wobbleamt) / 3
        end
        if wobblestate == 8 then
            local addamt = math.abs(math.sin(self.siner / wobbletime) * wobbleamt)
            local addamt2 = addamt
            if self.reversal == 1 then
                addamt = -addamt
            end
            self.x1 = self.x1 + addamt
            self.x2 = self.x2 + addamt
            self.y1 = self.y1 - addamt2
            self.y2 = self.y2 + addamt2
        end
        if wobblestate == 9 then
            self.y1 = self.y1 - math.abs(math.sin(self.siner / wobbletime) * 0.9) * 14
            self.y2 = self.y2 + math.abs(math.sin(self.siner / wobbletime) * 1.1) * 14
        end
        if wobblestate == 10 then
            local localReverse = 0
            
            if math.sin(self.siner / wobbletime) < 0 then
                localReverse = 1
            else
                localReverse = 0
            end
            local addamt = math.abs(math.sin(self.siner / wobbletime) * wobbleamt)
            local addamt2 = addamt
            if localReverse == 1 then
                addamt = -addamt
            end
            self.x1 = self.x1 + addamt
            self.x2 = self.x2 + addamt
            self.y1 = self.y1 - addamt2
            self.y2 = self.y2 + addamt2
        end
        if wobblestate == 11 then
            self.siner = self.siner - (self.speedscale - 1) * DTMULT
            self.animchangetimer = self.animchangetimer + self.speedscale * DTMULT
    
            if self.animchangetimer >= self.changespeed and self.pointcon == 0 then
                self.reversal = 0
                self:setSprite("point_left")
                self:setBounce(1)
                self.pointcon = self.pointcon + 1
            end
    
            if self.animchangetimer >= (self.changespeed * 2) and self.pointcon == 1 then
                self.reversal = 0
                self:setSprite("point_at_screen")
                self.x1 = 0
                self.y1 = 0
                self.x2 = self.texture:getWidth() * 2
                self.y2 = 0
                self.x3 = self.texture:getWidth() * 2
                self.y3 = self.texture:getHeight() * 2
                self.x4 = 0
                self.y4 = self.texture:getHeight() * 2
                self:setBounce(1)
                self.pointcon = self.pointcon + 1
            end
    
            if self.animchangetimer >= (self.changespeed * 3) and self.pointcon == 2 then
                self:setSprite("salute_b")
                self.reversal = 1
                self:setBounce(1)
                self.pointcon = self.pointcon + 1
            end
    
            if self.animchangetimer >= (self.changespeed * 4) then
                self.reversal = 1
                self:setSprite("point_up")
                self.x1 = 0
                self.y1 = 0
                self.x2 = self.texture:getWidth() * 2
                self.y2 = 0
                self.x3 = self.texture:getWidth() * 2
                self.y3 = self.texture:getHeight() * 2
                self.x4 = 0
                self.y4 = self.texture:getHeight() * 2
                self:setBounce(1)
                self.animchangetimer = 0
                self.pointcon = 0
            end
    
            if self.pointcon == 3 then
                _keep_pivot = true
            end
    
            local addamt = math.abs(math.sin(self.siner / wobbletime) * wobbleamt)
            local addamt2 = addamt
    
            if self.reversal == 1 then
                addamt = -addamt
            end
    
            self.x1 = self.x1 + addamt
            self.x2 = self.x2 + addamt
            self.y1 = self.y1 - addamt2
            self.y2 = self.y2 + addamt2
        end
        if wobblestate == 12 then
            local amt = math.abs(math.sin(self.siner / wobbletime) * wobbleamt)
            local amt2 = math.abs(math.cos(self.siner / wobbletime) * wobbleamt)
            self.x1 = self.x1 + amt
            self.x2 = self.x2 + amt2 /2
            self.y1 = self.y1 + amt
            self.y2 = self.y2 + amt
        end
        if wobblestate == 13 then
            self.siner = self.siner - (self.speedscale - 1) * DTMULT
            self.animchangetimer = self.animchangetimer + self.speedscale * DTMULT

            if self.pointcon == 0 then
                self:setSprite("laugh_pose_alt")
                self.x1 = 0
                self.y1 = 0
                self.x2 = self.texture:getWidth() * 2
                self.y2 = 0
                self.x3 = self.texture:getWidth() * 2
                self.y3 = self.texture:getHeight() * 2
                self.x4 = 0
                self.y4 = self.texture:getHeight() * 2
                self.timediff = 0
                self.pointcon = self.pointcon + 1
                wobbletime = 1
                wobbleamt = 2
            end
        end
        if wobblestate == 14 then
            self:setSprite("frightened")
            self.shakex = math.sin(self.siner / 4) * math.sin(self.siner / 3) * 12
            self.shakey = -math.abs(math.cos(self.siner / 2) * math.cos(self.siner / 1.5) * 28)
            self.drawtype = 0
            self.siner = math.floor(self.siner)
            self:setFrame(1 + (math.sin(self.siner / 4) * 3) + 3)
        end
        if wobblestate == 17 then
            self.x1 = self.x1 - ((math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt) * reversalsign)
            self.x2 = self.x2 - ((math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt) * reversalsign)
            self.y1 = self.y1 + (math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt)
            self.y2 = self.y2 - (math.abs(math.sin(self.siner / wobbletime) * wobbleamt) - wobbleamt) / 2
        end

        if self.reversal == 1 then
            local remx1 = self.x1
            local remx2 = self.x2
            local remx3 = self.x3
            local remx4 = self.x4
			
            self.x1 = remx2
            self.x2 = remx1
            self.x3 = remx4
            self.x4 = remx3

            if _keep_pivot then
                self.x1 = self.x1 + (self.texture:getWidth() / 2)
                self.x2 = self.x2 + (self.texture:getWidth() / 2)
                self.x3 = self.x3 + (self.texture:getWidth() / 2)
                self.x4 = self.x4 + (self.texture:getWidth() / 2)
            end
        end

        if self.drawtype == 0 then
            if self.xscale ~= 2 then
                self.x1 = self.x1 * (self.xscale / 2)
                self.x2 = self.x2 * (self.xscale / 2)
                self.x3 = self.x3 * (self.xscale / 2)
                self.x4 = self.x4 * (self.xscale / 2)
            end
            if self.yscale ~= 2 then
                self.y1 = self.y1 * (self.yscale / 2)
                self.y2 = self.y2 * (self.yscale / 2)
                self.y3 = self.y3 * (self.yscale / 2)
                self.y4 = self.y4 * (self.yscale / 2)
            end
            if self.shakex ~= 0 then
                self.x1 = self.x1 + self.shakex
                self.x2 = self.x2 + self.shakex
                self.x3 = self.x3 + self.shakex
                self.x4 = self.x4 + self.shakex
            end
            if self.shakey ~= 0 then
                self.y1 = self.y1 + self.shakey
                self.y2 = self.y2 + self.shakey
                self.y3 = self.y3 + self.shakey
                self.y4 = self.y4 + self.shakey
            end
            self.mesh:setVertex(1, self.x1 / 2, self.y1 / 2, 0, 0, 1, 1, 1, 1)
            self.mesh:setVertex(2, self.x2 / 2, self.y2 / 2, 1, 0, 1, 1, 1, 1)
            self.mesh:setVertex(3, self.x3 / 2, self.y3 / 2, 1, 1, 1, 1, 1, 1)
            self.mesh:setVertex(4, self.x4 / 2, self.y4 / 2, 0, 1, 1, 1, 1, 1)
            love.graphics.draw(self.mesh, 0, 0)
            return true
        elseif self.drawtype == 1 then
        elseif self.drawtype == 3 then
        end
    end

    super.draw(self)
end

return TennaActor
