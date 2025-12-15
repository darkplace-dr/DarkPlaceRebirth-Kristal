local Whirlwind, super = Class(Object)

function Whirlwind:init(x, y)
    super.init(self, x, y)

    self.width = 150
    self.height = 333
    self:setOrigin(0.5, 0)

    self.x_start = x
    self.alpha = 0
    self.state = "SPINUP"
    self.move_across_duration = 50
    self.spin_speed = 0.1
    self.parts = 10
    self.min_width = 50
    self.max_width = 150
    self.wave_length = 10
    self.x_end = 540

    self.timer = 0
    self.move_across_time = 0
    self.spindown_timer = 1.5

    self.tex_scale_x = 3
    self.tex_scale_y = 4/3

    self.whirl_x_offset = 0
    self.whirl_y_offset = 0

    self.canvas_1 = love.graphics.newCanvas(self.max_width, self.height)
    self.canvas_2 = love.graphics.newCanvas(self.max_width, self.height)
    self.texture = Assets.getTexture('textures/noise')

    local vertexFormat = {
        {"VertexPosition", "float", 2},
        {"VertexTexCoord", "float", 2}
    }
    local vertices = {}
    for i = 1, self.parts do
        local vertex_1, vertex_2 = self:getVertexAttributes(i)
        table.insert(vertices, vertex_1)
        table.insert(vertices, vertex_2)
    end

    self.mesh_1 = love.graphics.newMesh(vertexFormat, vertices, "strip", "static")
    self.mesh_2 = love.graphics.newMesh(vertexFormat, vertices, "strip", "static")
end

function Whirlwind:getVertexAttributes(number)
    local percent = (number - 1) / (self.parts - 1)
    local width = MathUtils.lerp(self.min_width, self.max_width, percent)
    local middle_x = math.sin(number * 8 / 10 + self.timer * self.spin_speed / 10) * self.wave_length
    local y = MathUtils.lerp(self.height, 0, percent)
    local v = percent
    local u_diff = 0.5 * (percent)
    return {middle_x - width / 2, y, 0, v},
           {middle_x + width / 2, y, 1, v}
end

function Whirlwind:update()
    super.update(self)
    self.timer = self.timer + DTMULT

    local tex_width, tex_height = self.texture:getDimensions()
    self.whirl_x_offset = self.whirl_x_offset + ((MathUtils.clamp(self.spin_speed, 0, 1) * 0.5) + 0.5) / 40 * DTMULT
    self.whirl_y_offset = self.whirl_y_offset + 0.4 * DTMULT

    for i = 1, self.mesh_1:getVertexCount(), 2 do
        local vertex_1, vertex_2 = self:getVertexAttributes(math.floor(i / 2) + 1)
        self.mesh_1:setVertexAttribute(i, 1, TableUtils.unpack(vertex_1))
        self.mesh_1:setVertexAttribute(i + 1, 1, TableUtils.unpack(vertex_2))
    end
    for i = 1, self.mesh_2:getVertexCount(), 2 do
        local vertex_1, vertex_2 = self:getVertexAttributes(math.floor(i / 2) + 1)
        self.mesh_2:setVertexAttribute(i, 1, TableUtils.unpack(vertex_1))
        self.mesh_2:setVertexAttribute(i + 1, 1, TableUtils.unpack(vertex_2))
    end

    if self.state == "SPINUP" then
        self.spin_speed = self.spin_speed + 0.05 * DTMULT
        if self.spin_speed > 0.2 then
            self.alpha = MathUtils.clamp(self.alpha + 0.05 * DTMULT, 0, 1)
        end
        if self.spin_speed >= 1.5 then
            self.spin_speed = 1.5
            self.alpha = 1
            self.state = "MOVE_TO_END"
        end
    elseif self.state == "MOVE_TO_END" then
        self.move_across_time = self.move_across_time + DTMULT
        self.x = Utils.ease(self.init_x, self.x_end, self.move_across_time / self.move_across_duration, 'inOutSine')
        if self.move_across_time >= self.move_across_duration then
            self.state = "SPINDOWN"
        end
    elseif self.state == "SPINDOWN" then
        self.spindown_timer = self.spindown_timer - 0.05 * DTMULT
        self.alpha = self.alpha - 0.05 * DTMULT
        if self.spindown_timer <= 0 then
            self.state = "DONE"
        end
    elseif self.state == "DONE" then
        self:remove()
    end
end

function Whirlwind:getEndCallback()
    return function()
        return self:isRemoved()
    end
end

function Whirlwind:draw()
    super.draw(self)
    local tex_width, tex_height = self.texture:getDimensions()

    Draw.pushCanvas(self.canvas_1)
    love.graphics.clear()
    for x = -1, math.ceil((1 / self.tex_scale_x) * (self.max_width / tex_width)) + 1 do
        for y = -1, math.ceil((1 / self.tex_scale_y) * (self.height / tex_height)) + 1 do
            local draw_x = x * tex_width * self.tex_scale_x - (self.whirl_x_offset + 75) % (tex_width * self.tex_scale_x)
            local draw_y = y * tex_height * self.tex_scale_y + (self.whirl_y_offset + 75) % (tex_height * self.tex_scale_y)
            Draw.draw(self.texture, draw_x, draw_y, 0, self.tex_scale_x, self.tex_scale_y)
        end
    end
    Draw.popCanvas()

    Draw.pushCanvas(self.canvas_2)
    love.graphics.clear()
    for x = -1, math.ceil((1 / self.tex_scale_x) * (self.max_width / tex_width)) + 1 do
        for y = -1, math.ceil((1 / self.tex_scale_y) * (self.height / tex_height)) + 1 do
            local draw_x = x * tex_width * self.tex_scale_x - self.whirl_x_offset % (tex_width * self.tex_scale_x)
            local draw_y = y * tex_height * self.tex_scale_y + self.whirl_y_offset % (tex_height * self.tex_scale_y)
            Draw.draw(self.texture, draw_x, draw_y, 0, self.tex_scale_x, self.tex_scale_y)
        end
    end
    Draw.popCanvas()

    self.mesh_1:setTexture(self.canvas_1)
    self.mesh_2:setTexture(self.canvas_2)

    local width, height = self.canvas_1:getDimensions()
    Draw.pushShader("pixelate", {
        size = {width, height},
        factor = 3
    })
    local r1, g1, b1 = TableUtils.unpack(ColorUtils.hexToRGB('#9E7FFF'))
    Draw.setColor(r1, g1, b1, 0.6 * self.alpha)
    love.graphics.setBlendMode('add')
    Draw.draw(self.mesh_1, self.width / 2 - 1, -1)
    local r2, g2, b2 = TableUtils.unpack(ColorUtils.hexToRGB('#7FC2FF'))
    Draw.setColor(r2, g2, b2, 0.6 * self.alpha)
    Draw.draw(self.mesh_2, self.width / 2)
    love.graphics.setBlendMode('alpha')
    Draw.popShader()
end

return Whirlwind