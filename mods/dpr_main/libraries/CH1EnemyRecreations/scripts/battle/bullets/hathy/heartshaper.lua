local HeartShaper, super = Class(Bullet)

function HeartShaper:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/hathy/heart")
    self:setScale(1)
    self.sprite.visible = false
    self.collider = nil

    self.siner = 0
    self.radius = 160
    self.dir = 0
    self.norot = false
    self.actual = true
    self.thisx, self.thisy = Game.battle.soul.x, Game.battle.soul.y

    self.damage = 100
    self.type = 0
    self.maxradius = 80
    self.movespeed = 0.5
    self.radcon = 0

    self.subs = {}
    self.bullets = 16
end

function HeartShaper:onCollide()
    return
end

function HeartShaper:onAdd(parent)
    super.onAdd(self, parent)

    for i = 1, self.bullets do
        table.insert(self.subs, self.wave:spawnBullet("hathy/heart", -2, -2))
    end
end

function HeartShaper:onRemove(parent)
    super.onRemove(self, parent)
    for _, bul in ipairs(self.subs) do
        bul:remove()
        TableUtils.removeValue(self.subs, bul)
    end
end

function HeartShaper:update()
    if self.actual == false then                --unused in DR?
        self.siner = self.siner + (1 * DTMULT)
        self.dir = self.dir + (2 * DTMULT)
        local xdir = self.dir + 180

        if self.norot == true then
            for i = 0, 20-1 do
                local t = ((i * 2 * math.pi) / 20) + (self.siner / 60)
                local xx = 16 * (math.sin(t) * math.sin(t) * math.sin(t))
                local yy = (13 * math.cos(t)) - (5 * math.cos(2 * t)) - (2 * math.cos(3 * t)) - math.cos(4 * t)
                local xxx = self.thisx + (xx * self.radius)
                local yyy = self.thisy - (yy * self.radius)

                self.fake_bul = Sprite("battle/bullets/hathy/heart", xxx, yyy)
                self.fake_bul.debug_select = false
                self:addChild(self.fake_bul)
            end
        end
    end

    if self.actual == true then
        if self.type == 0 then
            if self.radius > self.maxradius then
                self.radius = self.radius - 5 * DTMULT
            else
                self.radius = self.radius + (math.sin(self.siner / 10) / 2)
            end
        end
    
        if self.type == 1 then
            if self.radius > self.maxradius and self.radcon == 0 then
                self.radius = self.radius - (4 * DTMULT)
            else
                self.radcon = 1
                self.radius = self.radius + 8 * DTMULT
                self.collidable = false
                self.alpha = self.alpha - 0.1 * DTMULT
            end
        end
    
        self.dir = self.dir + 2 * DTMULT
        self.siner = self.siner + 1.5 * DTMULT

        local tcount = 0
    
        for t = 1, self.bullets do
            tcount = tcount + 1

            if self.radcon == 0 then
                self.subs[t]:fadeToSpeed(1, 0.1)
            end

            local xx = math.sin(((math.pi * t) / 8) + (self.siner / 20)) * self.radius
            local yy = math.cos(((math.pi * t) / 8) + (self.siner / 20)) * self.radius
            local xxx = self.thisx + xx
            local yyy = self.thisy - yy
            self.subs[t].x = xxx
            self.subs[t].y = yyy
            
            if self.radcon == 1 then
                self.subs[t]:fadeToSpeed(0, 0.1)
                self.subs[t].collidable = false

                if self.subs[t].alpha <= 0.1 then
                    self.subs[t]:remove()
                end
            end
        end
    
        if tcount == 0 then
            self:remove()
        end
    end

    super.update(self)
end

return HeartShaper