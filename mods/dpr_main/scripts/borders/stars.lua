---@class Border.stars: Border
local Stars, super = Class(Border)

function Stars:init()
    super.init(self)
    self.particles = {}
    self.particle_timer = 0
    self.star_tex = Assets.getTexture("effects/star")

end

function Stars:draw()
    local to_remove = {}
    for _,particle in ipairs(self.particles) do
        particle.radius = particle.radius - DT
        particle.y = particle.y - particle.speed * (DTMULT * 2)

        if particle.radius <= 0 then
            table.insert(to_remove, particle)
        end
    end

    for _,particle in ipairs(to_remove) do
        Utils.removeFromTable(self.particles, particle)
    end

    self.particle_timer = self.particle_timer + DT
    if self.particle_timer >= 0.4 then
        self.particle_timer = 0
        local radius = Utils.random(12)
        -- Create a star on each side of the border
        table.insert(self.particles, {
            radius = radius, max_radius = radius,
            x = love.math.random(0, 200), y = SCREEN_HEIGHT+50 + radius,
            speed = Utils.random(0.5, 1)
        })
        table.insert(self.particles, {
            radius = radius, max_radius = radius,
            x = love.math.random(SCREEN_WIDTH+140, SCREEN_WIDTH+300), y = SCREEN_HEIGHT+50 + radius,
            speed = Utils.random(0.5, 1)
        })
    end
	
    love.graphics.setColor(0, 0, 0, BORDER_ALPHA)
    love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH+16, SCREEN_HEIGHT+16)

    for _,particle in ipairs(self.particles) do
        local alpha = (particle.radius / particle.max_radius) * BORDER_ALPHA
    
    	love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.draw(self.star_tex, particle.x, particle.y, particle.radius)
    end

    love.graphics.setColor(1, 1, 1, BORDER_ALPHA)
    local width = 1

    love.graphics.setLineWidth(width)

    local left = 160 - width / 2
    local top = 30 - width / 2

    love.graphics.rectangle("line", left, top, 640 + width, 480 + width)




    love.graphics.setColor(1, 1, 1)
end

return Stars