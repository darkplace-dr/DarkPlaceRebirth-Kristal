local BurntPanStarAnim, super = Class(Object, "BurntPanStarAnim")

function BurntPanStarAnim:init()
    super.init(self)

    self.inherit_color = true

    self.star_angle = 12.25

    self.stars = {}
    self:createStars()
end

function BurntPanStarAnim:createStars()
    for i = 0, 8 do
        local star = Sprite("effects/attack/frypan_star")
        star:setOrigin(0.5)
        star.inherit_color = true
        star.physics = {
            direction = math.rad(360 * i / 8),
            friction = 0.34,
            speed = 8
        }
        self:addChild(star)
        table.insert(self.stars, star)
    end
end

function BurntPanStarAnim:update()
    if self.star_angle > 1 then
        self.star_angle = self.star_angle - 0.5 * DTMULT
    end

    for _,star in ipairs(self.stars) do
        if star.physics.speed < 6 then
            star.alpha = star.alpha - 0.05 * DTMULT
            star.rotation = star.rotation + math.rad(self.star_angle) * DTMULT

            if star.alpha < 0.05 then
                star:remove()
            end
        end
    end

    super.update(self)
end

return BurntPanStarAnim