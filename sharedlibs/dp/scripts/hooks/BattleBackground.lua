---@class BattleBackground
---@field private date std.osdate
---@field private offset number
local BattleBackground, super = HookSystem.hookScript(BattleBackground)

function BattleBackground:init()
    super.init(self)
    self.date = os.date("*t", os.time())
    self.offset = 0.0

    if self.date.month == 10 and self.date.day == 31 then
        local skeledance = Sprite("battle/skeledance/skeledance", SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        skeledance:setOrigin(0.5)
        skeledance:setColor(self.color)
        skeledance:play(1/15, true)
        skeledance:setScale(5, 2)
        skeledance.alpha = 14/255
        skeledance.debug_select = false
        self:addChild(skeledance)

        skeledance.layer = BATTLE_LAYERS["bottom"]
    end

    self.lines = {}
    if self.date.month == 10 then
        for _=1,4 do
            self:spawnWeb(0,love.math.random(40,480), love.math.random(40,120),0)
            self:spawnWeb(640,love.math.random(40,480), 640-love.math.random(40,120),0)
        end
    end
end

function BattleBackground:draw()
    self:drawBackground()
    self:drawChildren()
end

function BattleBackground:update()
    super.update(self)
    self.offset = (self.offset + DTMULT) % 100
end

function BattleBackground:spawnWeb(x1, y1, x2, y2)
    local curve = love.math.newBezierCurve(x1,y1, (x1+x2)/2,(y1+y2)/2 + love.math.random(20,100), x2,y2)
    table.insert(self.lines, curve)
end

-- TODO: Re-accuracy-ify
function BattleBackground:drawBackground()
    Draw.setColor(0, 0, 0, self.alpha)
    love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH + 16, SCREEN_HEIGHT + 16)

    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(1)

    for i = 2, 16 do
        if self.date.month == 2 and self.date.day == 14 then
            Draw.setColor(128/255, 0/255, 85/255, self.alpha / 2)
        elseif self.date.month == 10 then
            Draw.setColor(204/255, 85/255, 0/255, (self.alpha) / 2)
        else
            Draw.setColor(66/255, 0, 66/255, (self.alpha) / 2)
        end
        love.graphics.line(0, -210 + (i * 50) + math.floor(self.offset / 2), 640, -210 + (i * 50) + math.floor(self.offset / 2))
        love.graphics.line(-200 + (i * 50) + math.floor(self.offset / 2), 0, -200 + (i * 50) + math.floor(self.offset / 2), 480)
    end

    for i = 3, 16 do
        if self.date.month == 2 and self.date.day == 14 then
            Draw.setColor(128/255, 0/255, 85/255, self.alpha)
        elseif self.date.month == 10 then
            Draw.setColor(204/255, 85/255, 0/255, self.alpha)
        else
            Draw.setColor(66/255, 0, 66/255, self.alpha)
        end
        love.graphics.line(0, -100 + (i * 50) - math.floor(self.offset), 640, -100 + (i * 50) - math.floor(self.offset))
        love.graphics.line(-100 + (i * 50) - math.floor(self.offset), 0, -100 + (i * 50) - math.floor(self.offset), 480)
    end

    if self.enable_particles then
        local particle_to_remove = {}
        for _,particle in ipairs(self.particles) do
            particle.radius = Utils.approach(particle.radius, 0, DT)
            particle.y = particle.y - particle.speed * DTMULT

            if particle.radius <= 0 then
                table.insert(particle_to_remove, particle)
            end
        end
        for _,particle in ipairs(particle_to_remove) do
            Utils.removeFromTable(self.particles, particle)
        end

        self.particle_interval = self.particle_interval + DT
        if self.particle_interval >= 0.4 then
            self.particle_interval = 0
            local radius = Utils.random(2, 12)
		
            table.insert(self.particles, {
                type = "hearts",
                radius = radius, max_radius = radius,
                x = Utils.random(SCREEN_WIDTH), y = SCREEN_HEIGHT + radius,
                speed = 4 * Utils.random(0.5, 1),
                scale = Utils.pick{1, 1.5, 2},
            })
        end
		
        for _,particle in ipairs(self.particles) do
            if self.date.month == 2 and self.date.day == 14 then
                Draw.setColor(196/255, 20/255, 152/255, (particle.radius / particle.max_radius) * self.alpha)
            else
                Draw.setColor(1, 1, 1, (particle.radius / particle.max_radius) * self.alpha)
            end
            if self.particles.type == "hearts" then
                self.particle_tex = Assets.getTexture("player/heart_menu_outline")
            end
            local particle_ox, particle_oy = 0, 0
            love.graphics.draw(self.particle_tex, particle.x, particle.y, particle.radius, particle.scale, particle.scale, particle_ox, particle_oy)
        end
    end
	
    if self.date.month == 2 and self.date.day == 14 then
        self.enable_particles = true
    else
        self.enable_particles = false
    end

    if self.date.month == 10 then
        for _,line in ipairs(self.lines) do
            Draw.setColor(0.7, 0.7, 0.72, self.alpha)
            love.graphics.line(line:render())
        end
    end
end

return BattleBackground
