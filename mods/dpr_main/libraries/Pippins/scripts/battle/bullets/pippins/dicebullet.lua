local DiceBullet, super = Class(Bullet)

function DiceBullet:init(x, y, special)
	self.image_index = Utils.pick{1,5,8,12}-- 0 > 4 12 > 3
    self.setsprite = "bullets/pippins/dice_bullet_"
    super.init(self, x, y, self.setsprite..self.image_index)
	--self:setOrigin(0.5) --固定
    self:setHitbox(6, 7, 8, 8)
	self.destroy_on_hit = false --タマシイに被弾した場合消えるかどうか destroyonhit
	self.tp = 1.2 --grazepoints
	self.owner = -4
	self.updateimageangle = false
	self.alpha = 0 --image_alpha
	--self:setSprite("bullets/pippins/dice_bullet", 0) --image_index image_speed
	self.sprite:stop()
	--self.image_index = 12
	self.size = 1
	self:setScale(self.size * 2) --image_xscale image_yscale
	self.physics.speed_y = love.math.random(-2, -4)
	self.physics.speed_x = love.math.random(-5, 5)
	self.max_speed = love.math.random(8, 10)
	self.force_index = -1
	self.timer = 0
	self.slowed_rotate = 0
	self.turn_rate = 0.1
	self.queue_lock = false
	self.rot_speed = (9 + love.math.random(4)) * (Utils.randomSign(-1,1))
	self.tick_count = 0 
	self.decel = -1
    self.physics.match_rotation = true

    self.alarm_1 = 0
    self.alarm_1_start = false

    local mask = ColorMaskFX({1,0,0}, 0)
    self:addFX(mask)
    self.redmask = mask
    self.Coloramount = 0
    --local mercymask = ColorMaskFX(COLORS.lime, 0)
    --self:addFX(mercymask)
    --self.mercymask = mercymask
    self.con = 0
    self.sndcon = 0
    self.kuniku = 0
    self.owari = 0
    self.owarimax = 0
    self.noda = false
end

function DiceBullet:update()
    super.update(self)

    if(self.alarm_1 > 0 and self.alarm_1_start == true) then
        self.alarm_1 = self.alarm_1 - (1 * DTMULT)
        if(self.alarm_1 <= 0) then
            local shockwave = self.wave:spawnBullet("pippins/shockwave", self.x, self.y)
            shockwave.count = 0
            shockwave.scale_x = 1.5
            shockwave.scale_y = 1.5
            self.con = 1
            self.alarm_1_start = false
        end
    end

    if(self.alarm_1 == 9 or self.alarm_1 == 4) then
        self.redmask.amount = 0.3
    elseif(self.alarm_1 == 7 or self.alarm_1 == 2)  then
        self.redmask.amount = 0
    end

    if(self.con == 1) then
        self.image_index = math.floor(self.image_index)
        local pips = self.image_index / 4;
        if(self.setsprite == "bullets/pippins/all4s_") then
            pips = 3
        end

        if(pips == 0) then
            local angle = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
            self.wave:spawnBullet("pippins/smallbullet", self.x, self.y, angle, 4)
            if(self.sndcon == 0) then
                Assets.playSound("gunshot_b", 1, 1.3)
                self.sndcon = 1
            end
            self.con = 2
        else
            for _, attacker in ipairs(self.wave:getAttackers()) do
                if(attacker.bet == true) then
                    self:setColor(1,1,1)   
                end
            end
            Assets.stopSound("bomb")
            Assets.playSound("bomb")

            if(pips == 1) then
                self.kuniku = 90
                self.owarimax = 2
            elseif(pips == 2) then
                self.kuniku = 145
                self.owarimax = 3
            elseif(pips == 3) then
                self.kuniku = 130
                self.owarimax = 4
            end

            local basedir = math.rad(self.kuniku) - (45 * pips) --90 2 --145 3 --135 4
            local rotate = math.rad(180) / (1 + ((pips - 1) / 2)); --1.5 3
            local dir = basedir
            while self.owari <= self.owarimax do
                dir = dir + rotate
                if(self.image_index == 4) then
                    if(dir == 135) then
                        dir = dir + 12
                    end

                    if(dir == 333) then
                        dir = dir - 12
                    end
                end
                if(self.image_index == 12) then
                    --nothing?
                end

                local dir2 = dir + self.rotation
                local dox = self.x + math.cos(dir2) * 20
                local doy = self.y + math.sin(dir2) * 20
                local shockwave = self.wave:spawnBullet("pippins/shockwave", dox, doy)
                shockwave.physics.direction = dir + self.rotation
                if(pips >= 3 or self.image_index >= 8) then
                    shockwave.scale_x = 2
                    shockwave.scale_y = 2
                end
                self.owari = self.owari + (1 * DTMULT)
            

            end
            self.con = 2
        end
    end


	self.rotation = self.rotation + math.rad(self.rot_speed) * DTMULT

	if (math.abs(self.x + self.physics.speed_x - Game.battle.arena.x) > 65) then   
        self.rot_speed = (self.rot_speed * -0.8)
        self.physics.speed_x = (self.physics.speed_x * -0.9)
        self.x = self.x + self.physics.speed_x
    end

	if(self.decel == -1) then
	   self.physics.speed_y = Utils.approach(self.physics.speed_y,self.max_speed,0.4)
    elseif (self.decel > 0) then
		self.physics.speed_y = DiceBullet:scr_approach_curve(self.physics.speed_y, 0, self.decel)
        self.physics.speed_x = DiceBullet:scr_approach_curve(self.physics.speed_x, 0, self.decel *self.decel)
        self.rot_speed = DiceBullet:scr_approach_curve(self.rot_speed, 0, self.decel)
        self.decel = self.decel - (1 * DTMULT)
        if (self.decel == 10) then
            self.queue_lock = true
	    end
        if (self.decel == 0) then
            self.alarm_1 = 20
            self.alarm_1_start = true
            self.decel = -2
	    end
    end

    if((self.y + self.physics.speed_y) > (Game.battle.arena.y + 58) and self.physics.speed_y > 0) then
        self.physics.speed_y = self.physics.speed_y * (Utils.pick{-0.3,-0.6,-0.8,-1} ^ DTMULT)

        Assets.playSound("bump", 1)

	    if(self.decel == -1) then
	        self.decel = 15
	    end
    end

end

function DiceBullet:draw()
    super.draw(self)

	self:setSprite(self.setsprite..self.image_index)

	if (self.force_index == -1) then

        if ((self.image_index % 4) == 0 and self.queue_lock == true) then
            self.force_index = self.image_index
	    end

        self.tick_count = self.tick_count + (self.turn_rate / (1.5 + self.slowed_rotate)) * DTMULT

        local delay = 0.1 + (0.6 * ((self.image_index % 4 == 0) and 1 or 0))

        if self.tick_count >= delay then
            self.tick_count = self.tick_count - delay
            self.image_index = self.image_index + 1
            if(self.image_index == 16) then
                self.image_index = 0
            end
        end
    else
        self.image_index = self.force_index
    end

	if (self.alpha < 1 and self. con == 0) then
        self.alpha = self.alpha + (0.3 * DTMULT)
	end

    if (self.alpha ~= 0 and self. con >= 1) then
        self.alpha = self.alpha - (0.3 * DTMULT)
        self.scale_x = self.scale_x + (0.2 * DTMULT)
        self.scale_y = self.scale_y + (0.2 * DTMULT)
        if(self.alpha <= 0) then
            self:remove()
        end
	end

    for _, attacker in ipairs(self.wave:getAttackers()) do
        if(attacker.bet == true) then
            if (self.image_index >= 10 and self.image_index < 14.5 and self.con <= 1) then
                self:setColor(Utils.mergeColor(self.color, COLORS.lime, 0.2 * DTMULT))
            else
                self:setColor(1,1,1)
            end
        end       
    end

end

function DiceBullet:scr_approach_curve(arg0, arg1, arg2)
    local diff = math.abs(arg1 - arg0)
    local step = math.max(0.1, diff / arg2)
    return Utils.approach(arg0, arg1, step)
end

function DiceBullet:onCollide(soul)
    for _, attacker in ipairs(self.wave:getAttackers()) do
        if(attacker.bet == true) then
            if (self.image_index >= 10 and self.image_index < 14.5) then
                self.noda = true
                attacker:addMercy(35)
                self:remove()
            else
                self.noda = false
            end
        else
            if soul.inv_timer == 0 and self.noda == false then
                self:onDamage(soul)
            end
        end
    end
end

return DiceBullet