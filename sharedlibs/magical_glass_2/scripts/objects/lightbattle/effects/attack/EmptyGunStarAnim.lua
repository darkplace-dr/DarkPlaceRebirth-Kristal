local EmptyGunStarAnim, super = Class(Object, "EmptyGunStarAnim")

function EmptyGunStarAnim:init()
    super.init(self)

    self.inherit_color = true

    self.siner = 0

    self.star_speed = 16
    self.star_radius = 0
    self.star_size = 0.5

    self.stars = {}
    self:createStars()
end

function EmptyGunStarAnim:createStars()
    for i = 0, 7 do
        local star = Sprite("effects/attack/gunshot_stab")
        star:setOrigin(0.5)
        star.rotation = math.rad(20 * i)
        star.inherit_color = true
        star:play(4/30, true)

        self:addChild(star)
        table.insert(self.stars, star)
    end
end

function EmptyGunStarAnim:update()
    self.siner = self.siner + 15 * DTMULT

    self.star_radius = self.star_radius + self.star_speed * DTMULT
    self.star_speed = self.star_speed - 2 * DTMULT

    self.star_size = (1 + (self.star_speed / 20))
    if self.star_size < 0.2 then
        self.star_size = 0
    end

    for i, star in ipairs(self.stars) do
        local angle = math.rad(self.siner + (45 * (i - 1)))

        star.rotation = star.rotation + math.rad(20) * DTMULT
        star.x = star.init_x + math.sin(angle) * self.star_radius
        star.y = star.init_y + math.cos(angle) * self.star_radius

        star:setScale(self.star_size)
    end

    if self.star_speed < 0 then
        self.alpha = self.alpha - 0.07 * DTMULT
    end

    if self.star_radius <= 0.5 then
        for _,star in ipairs(self.stars) do
            star:remove()
        end
        self:remove()
    end

    super.update(self)
end

return EmptyGunStarAnim