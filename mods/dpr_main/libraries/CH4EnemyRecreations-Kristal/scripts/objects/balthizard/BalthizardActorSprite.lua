local BalthizardActorSprite, super = Class(ActorSprite)

function BalthizardActorSprite:init(actor)
    super.init(self, actor)

    self.tail = Sprite(self:getTexturePath("tail"), 0, 0)
    self.tail.debug_select = false
    self:addChild(self.tail)

    self.leg1 = Sprite(self:getTexturePath("leg1"), 0, 0)
    self.leg1.debug_select = false
    self:addChild(self.leg1)

    self.leg1_transition = Sprite(self:getTexturePath("leg1_transition"), 0, 0)
    self.leg1_transition.alpha = 0
    self.leg1_transition.debug_select = false
    self:addChild(self.leg1_transition)

    self.body = Sprite(self:getTexturePath("body"), 0, 0)
    self.body.debug_select = false
    self:addChild(self.body)

    self.body_transition = Sprite(self:getTexturePath("body_transition"), 0, 0)
    self.body_transition:setOriginExact(0, 14)
    self.body_transition.alpha = 0
    self.body_transition.debug_select = false
    self:addChild(self.body_transition)

    self.leg2 = Sprite(self:getTexturePath("leg2"), 0, 0)
    self.leg2.debug_select = false
    self:addChild(self.leg2)

    self.leg2_transition = Sprite(self:getTexturePath("leg2_transition"), 0, 0)
    self.leg2_transition.alpha = 0
    self.leg2_transition.debug_select = false
    self:addChild(self.leg2_transition)

    self.leg3 = Sprite(self:getTexturePath("leg3"), 0, 0)
    self.leg3.debug_select = false
    self:addChild(self.leg3)

    self.leg3_transition = Sprite(self:getTexturePath("leg3_transition"), 0, 0)
    self.leg3_transition.alpha = 0
    self.leg3_transition.debug_select = false
    self:addChild(self.leg3_transition)

    self.neckpiece1 = Sprite(self:getTexturePath("neckpiece"), 0, 0)
    self.neckpiece1:setOriginExact(4, 4)
    self.neckpiece1:setColor({166/255, 94/255, 122/255})
    self.neckpiece1.x = self.x + 13
    self.neckpiece1.y = self.y + 28
    self.neckpiece1.debug_select = false
    self:addChild(self.neckpiece1)

    self.neckpiece2 = Sprite(self:getTexturePath("neckpiece"), 0, 0)
    self.neckpiece2:setOriginExact(4, 4)
    self.neckpiece2:setColor({166/255, 94/255, 122/255})
    self.neckpiece2.x = self.x + 13
    self.neckpiece2.y = self.y + 28
    self.neckpiece2.debug_select = false
    self:addChild(self.neckpiece2)

    self.neckpiece3 = Sprite(self:getTexturePath("neckpiece"), 0, 0)
    self.neckpiece3:setOriginExact(4, 4)
    self.neckpiece3:setColor({166/255, 94/255, 122/255})
    self.neckpiece3.x = self.x + 13
    self.neckpiece3.y = self.y + 28
    self.neckpiece3.debug_select = false
    self:addChild(self.neckpiece3)

    self.head = Sprite(self:getTexturePath("head"), 0, 0)
    self.head:setOriginExact(13, 10)
    self.head.x = self.x + 13
    self.head.y = self.y + 28
    self.head.debug_select = false
    self:addChild(self.head)

    self.headfire = Sprite(self:getTexturePath("head_fire"), 0, 0)
    self.headfire:setOriginExact(30, 24)
    self.headfire.x = self.x + 13
    self.headfire.y = self.y + 23
    self.headfire.alpha = 0
    self.headfire.debug_select = false
    self:addChild(self.headfire)

    self.shaking = false
    self.spareable = false

    self.animsiner = 0

    self.headoffsetx = 0
    self.headoffsety = 0

    self.lightup = false
    self.lightupfireframes = 0

    self.headspeed = 0
    self.headgravity = 2.5
    self.headfriction = 1

    self.headindex = 0

    self.eyedelay = 0
    self.eyesiner = 0

    self.headamplitude = 0

    self.transitioncon = 0
    self.transitiontimer = 0
    self.bodyindex = 1
    self.leg1index = 1
    self.head_last_x = 0
    self.head_last_y = 0
end

function BalthizardActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function BalthizardActorSprite:set(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function BalthizardActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function BalthizardActorSprite:update()
    super.update(self)

    if self.headspeed > 2 then
        self.headspeed = self.headspeed - self.headfriction * DTMULT
    end
    if self.headspeed < -2 then
        self.headspeed = self.headspeed + self.headfriction * DTMULT
    end
    if self.headoffsetx > 2 then
        self.headspeed = self.headspeed - self.headgravity * DTMULT
    elseif self.headoffsetx < -2 then
        self.headspeed = self.headspeed + self.headgravity * DTMULT
    else
        self.headoffsetx = 0
        if self.headspeed < 0.5 and self.headspeed > -0.5 then
            self.headspeed = 0
        end
    end
    if self.headoffsetx > 65 then
        self.headoffsetx = 65
        self.headspeed = 0
    end
    if self.headoffsetx < -65 then
        self.headoffsetx = -65
        self.headspeed = 0
    end
    if self.headspeed > 15 then
        self.headspeed = 15
    end
    if self.headspeed < -15 then
        self.headspeed = -15
    end

    self.headoffsetx = self.headoffsetx + self.headspeed * DTMULT

    if self.headoffsety > 0 then
        self.headoffsety = self.headoffsety - 0.5 * DTMULT
    end
    if self.headoffsety < 0 then
        self.headoffsety = self.headoffsety + 0.5 * DTMULT
    end
    if self.eyedelay < 1 then
        self.eyesiner = self.eyesiner + 1 * DTMULT
    end

    self.animsiner = self.animsiner + 1 * DTMULT
	
    if self.shaking then
        self.headamplitude = MathUtils.lerp(self.headamplitude, 0, 0.25)
    else
        self.headamplitude = MathUtils.lerp(self.headamplitude, 5/2, 0.25)
    end
	
    self.eyedelay = self.eyedelay - 1 * DTMULT

    if self.eyedelay < 1 then
        self.headindex = 7 + (math.sin(self.eyesiner / 12)) * 5
    end

    local anim = self.anim or "idle"
    if anim == "idle" or anim == "spared" then
        self.tail.y = self.y + (math.sin(self.animsiner / 8)) * 4
        self.body.y = self.y + (math.sin(self.animsiner / 8)) * 2

        if self.lightup then
            self.headfire.alpha = 1
            self.lightupfireframes = self.lightupfireframes + 0.25 * DTMULT
            self.headfire:setFrame(math.floor(self.lightupfireframes))
            self.headfire.x = self.x + 13 + self.headoffsetx + (math.sin(self.animsiner / 8)) * self.headamplitude --8
            self.headfire.y = self.y + 23 + self.headoffsety + (math.cos(self.animsiner / 6)) * self.headamplitude / 2 -- 6
        else
            self.headfire.alpha = 0
        end

        if anim == "spared" then
            self.head:setSprite(self:getTexturePath("head_spared"))
        end
        self.head:setFrame(math.floor(self.headindex))
        self.head.x = self.x + 13 + self.headoffsetx + (math.sin(self.animsiner / 8) * self.headamplitude)
        self.head.y = self.y + 28 + self.headoffsety + ((math.cos(self.animsiner / 6) * self.headamplitude) / 2)

        if not self.shaking then
            if (self.animsiner % 12) == 0 and not self.lightup then
                local smoke = BalthizardSmoke(-3 + self.x + 13 + self.headoffsetx - 7 + (math.sin(self.animsiner / 8)) * self.headamplitude, self.y + 28 + self.headoffsety + (math.cos(self.animsiner / 6)) * self.headamplitude / 2 - 10, 0.125, 1, self.spareable and 3 or 2)
                smoke.physics.speed = (TableUtils.pick({-1, -2, -3}) + 1)/2
                smoke.alpha = 0.75
                self:addChild(smoke)
            end
            if (self.animsiner % 12) == 6 and not self.lightup then
                local smoke = BalthizardSmoke(3 + self.x + 13 + self.headoffsetx + 10 + (math.sin(self.animsiner / 8)) * self.headamplitude, self.y + 28 + self.headoffsety + (math.cos(self.animsiner / 6)) * self.headamplitude / 2 - 10, 0.125, 1, self.spareable and 3 or 2)
                smoke.physics.speed = (TableUtils.pick({1, 2, 3}) - 1)/2
                smoke.alpha = 0.75
                self:addChild(smoke)
            end
            if (self.animsiner % 20) == 0 then
                local smoke = BalthizardSmoke(self.x + 63, self.y + 10 + (math.sin(self.animsiner / 8)) * 4, 0.175, 1, self.spareable and 3 or 2)
                smoke.physics.speed = (TableUtils.pick({1, -1}))/2
                smoke.alpha = 0.75
                self:addChild(smoke)
            end
        end
        if self.shaking then
            self.neckpiece1.alpha = 1
            self.neckpiece2.alpha = 1
            self.neckpiece3.alpha = 1

            local xx1 = self.x + 13
            local xx2 = self.x + 13 + self.headoffsetx
            local flip = 1
            if self.headoffsetx < 0 then
                flip = -1
            end
            self.neckpiece1.x = xx1 + (MathUtils.dist(xx1, self.y, xx2, self.y)) * 0.1 * flip
            self.neckpiece2.x = xx1 + (MathUtils.dist(xx1, self.y, xx2, self.y)) * 0.33 * flip
            self.neckpiece3.x = xx1 + (MathUtils.dist(xx1, self.y, xx2, self.y)) * 0.55 * flip
            self.neckpiece1.y = self.y + 28 + self.headoffsety
            self.neckpiece2.y = self.y + 28 + self.headoffsety
            self.neckpiece3.y = self.y + 28 + self.headoffsety
        else
            self.neckpiece1.alpha = 0
            self.neckpiece2.alpha = 0
            self.neckpiece3.alpha = 0
        end
    end
    if anim == "transition" then
        if(self.transitioncon == 0) then
            self.animsiner = 0
            self.headoffsetx = 0
            self.headoffsety = 0
            self.headindex = 0
            self.eyedelay = 0
            self.eyesiner = 0
            self.head:setFrame(math.floor(self.headindex))
            self.head.x = self.x + 13
            self.head.y = self.y + 28
            self.head_last_x = self.head.x
            self.head_last_y = self.head.y
            self.transitioncon = 1
            self.tail.y = self.y
            self.body.y = self.y
        end
        if(self.transitioncon == 1) then
            self.transitiontimer = self.transitiontimer + 1
            if(self.transitiontimer == 1) then
                Assets.playSound("equip")
            end
            self.tail.x = MathUtils.lerp(0, -30, self.transitiontimer / 5)
            if(self.transitiontimer < 6) then
                self.body.alpha = 0
                self.body_transition.alpha = 1
                self.body_transition:setFrame(math.floor(self.bodyindex))
                self.bodyindex = self.bodyindex + 1
            end
            self.headfire.alpha = 0
            self.leg1.alpha = 0
            self.leg2.alpha = 0
            self.leg3.alpha = 0
            self.leg1_transition.alpha = 1
            self.leg2_transition.alpha = 1
            self.leg3_transition.alpha = 1
            self.leg1_transition:setFrame(math.floor(self.leg1index))
            self.leg2_transition:setFrame(math.floor(self.leg1index))
            self.leg3_transition:setFrame(math.floor(self.leg1index))
            self.leg1index = self.leg1index + 0.5
            self.head.y = self.head.y + 1
            self.head.scale_x = MathUtils.lerp(1, 0.8, self.transitiontimer / 5);
            self.head.scale_y = MathUtils.lerp(1, 0.8, self.transitiontimer / 5);
            self.leg2_transition.x = MathUtils.lerp(0, 10, self.transitiontimer / 5);
            self.leg3_transition.x = MathUtils.lerp(0, 10, self.transitiontimer / 5);
            self.leg2_transition.y = self.leg2_transition.y - 1
            self.leg3_transition.y = self.leg3_transition.y - 1
            if(self.transitiontimer == 5) then
                self.body_transition:setFrame(5)
                self.bodyindex = 5
                self.transitiontimer = 0
                self.transitioncon = 2
            end
        end
        if(self.transitioncon == 2) then
            self.transitiontimer = self.transitiontimer + 1
            self.head.alpha = MathUtils.lerp(1, 0, self.transitiontimer / 5);
            self.tail.alpha = MathUtils.lerp(1, 0, self.transitiontimer / 5);
            self.leg1_transition.alpha = MathUtils.lerp(1, 0, self.transitiontimer / 5);
            self.leg2_transition.alpha = MathUtils.lerp(1, 0, self.transitiontimer / 5);
            self.leg3_transition.alpha = MathUtils.lerp(1, 0, self.transitiontimer / 5);
            self.leg1_transition.x = MathUtils.lerp(0, 20, self.transitiontimer / 5);
            self.leg2_transition.x = MathUtils.lerp(10, -10, self.transitiontimer / 5);
            self.leg3_transition.x = MathUtils.lerp(10, -15, self.transitiontimer / 5);
            self.head.x = MathUtils.lerp(self.head.x, 20, self.transitiontimer / 5);
            if(self.transitiontimer == 3) then
                Assets.playSound("impact", 1, 2)
            end
            if(self.transitiontimer == 4) then
                self.body_transition:setFrame(self.bodyindex)
                self.bodyindex = self.bodyindex - 1
            end
            if(self.transitiontimer == 5) then
                self.transitiontimer = 0
                self.transitioncon = 3
            end
        end
        if(self.transitioncon == 3) then
            self.transitiontimer = self.transitiontimer + 1
            if(self.bodyindex > 0) then
                self.body_transition:setFrame(self.bodyindex)
                self.bodyindex = self.bodyindex - 1
            end
            self.head.alpha = 0
            self.tail.alpha = 0
            self.leg1_transition.alpha = 0
            self.leg2_transition.alpha = 0
            self.leg3_transition.alpha = 0
            if(self.bodyindex == 0 and self.transitiontimer >= 1) then
                self.transitiontimer = 0
                self.transitioncon = 4
            end
        end
        if(self.transitioncon == 4) then
            self.transitiontimer = self.transitiontimer + 1
            if(self.transitiontimer == 1) then
                self.body_transition.y = self.body_transition.y + 3
            end
            if(self.transitiontimer == 2) then
                self.body_transition.y = self.body_transition.y - 2
            end
            if(self.transitiontimer == 3) then
                self.body_transition.y = self.body_transition.y + 1
            end
            if(self.transitiontimer == 4) then
                self.body_transition.y = self.y
            end
            if(self.transitiontimer == 5) then
                self.body_transition.alpha = 0
            end
        end
    end
    if anim == "transition_end" then
        if(self.transitioncon == 4) then
            self.transitiontimer = 0
            self.body_transition.alpha = 1
            self.transitioncon = 5
        end
        if(self.transitioncon == 5) then
            self.transitiontimer = self.transitiontimer + 1
            if(self.bodyindex == 0) then
                self.body_transition:setFrame(2)
                self.bodyindex = 2
            end
            if(self.transitiontimer == 2) then
                self.transitiontimer = 0
                self.transitioncon = 6
            end
        end
        if(self.transitioncon == 6) then
            self.transitiontimer = self.transitiontimer + 1
            if(self.transitiontimer == 1) then
                Assets.playSound("equip")
            end
            self.head.alpha = MathUtils.lerp(0, 1, self.transitiontimer / 5);
            self.tail.alpha = MathUtils.lerp(0, 1, self.transitiontimer / 5);
            self.leg1_transition.alpha = MathUtils.lerp(0, 1, self.transitiontimer / 5);
            self.leg2_transition.alpha = MathUtils.lerp(0, 1, self.transitiontimer / 5);
            self.leg3_transition.alpha = MathUtils.lerp(0, 1, self.transitiontimer / 5);
            self.leg1_transition.x = MathUtils.lerp(20, 0, self.transitiontimer / 5);
            self.leg2_transition.x = MathUtils.lerp(-10, 10, self.transitiontimer / 5);
            self.leg3_transition.x = MathUtils.lerp(-15, 10, self.transitiontimer / 5);
            self.head.x = MathUtils.lerp(self.head.x, self.head_last_x, self.transitiontimer / 5);
            if(self.bodyindex == 2) then
                self.body_transition:setFrame(3)
                self.bodyindex = 3
            end
            if(self.transitiontimer == 5) then
                self.transitiontimer = 0
                self.transitioncon = 7
            end
        end
        if(self.transitioncon == 7) then
            self.transitiontimer = self.transitiontimer + 1
            self.tail.x = MathUtils.lerp(-30, 0, self.transitiontimer / 5)
            if(self.transitiontimer < 6 and self.bodyindex ~= 0) then
                self.body_transition:setFrame(math.floor(self.bodyindex))
                self.bodyindex = self.bodyindex - 1
            end
            self.leg1_transition:setFrame(math.floor(self.leg1index))
            self.leg2_transition:setFrame(math.floor(self.leg1index))
            self.leg3_transition:setFrame(math.floor(self.leg1index))
            self.leg1index = self.leg1index - 0.5
            self.head.y = self.head.y - 1
            self.head.scale_x = MathUtils.lerp(0.8, 1, self.transitiontimer / 5);
            self.head.scale_y = MathUtils.lerp(0.8, 1, self.transitiontimer / 5);
            self.leg2_transition.x = MathUtils.lerp(10, 0, self.transitiontimer / 5);
            self.leg3_transition.x = MathUtils.lerp(10, 0, self.transitiontimer / 5);
            self.leg2_transition.y = self.leg2_transition.y + 1
            self.leg3_transition.y = self.leg3_transition.y + 1
            if(self.transitiontimer == 5) then
                self.transitiontimer = 0
                self.transitioncon = 0
                if(self.lightup == true) then
                    self.headfire.alpha = 1
                end
                self.leg1.alpha = 1
                self.leg2.alpha = 1
                self.leg3.alpha = 1
                self.body.alpha = 1
                self.leg1_transition.alpha = 0
                self.leg2_transition.alpha = 0
                self.leg3_transition.alpha = 0
                self.body_transition.alpha = 0
                self:setAnimation("idle")
            end
        end
    end
end

return BalthizardActorSprite