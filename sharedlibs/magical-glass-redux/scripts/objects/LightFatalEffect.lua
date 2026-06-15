local LightFatalEffect, super = Class(Object)

function LightFatalEffect:init(texture, x, y, after)
    super.init(self, x, y)

    if type(texture) == "string" then
        texture = Assets.getTexture(texture) or (Assets.getFrames(texture)[1])
    end
    self.texture = texture

    self.start_color = { 1, 1, 1 }
    self.red_timer = 0

    self.done = false
    self.after_func = after

    self.width, self.height = texture:getWidth(), texture:getHeight()
    self.block_size = 3
    if self.width >= 50 or self.height >= 50 then
        self.block_size = 8
    elseif self.width >= 25 or self.height >= 25 then
        self.block_size = 4
    end
    self.blocks_x = math.ceil(self.width / self.block_size)
    self.blocks_y = math.ceil(self.height / self.block_size)
    self.blocks = {}
    for i = 0, self.blocks_x do
        self.blocks[i] = {}
        for j = 0, self.blocks_y do
            local block = {}

            local qx = (i * self.block_size)
            local qy = (j * self.block_size)
            local qw = MathUtils.clamp(self.block_size, 0, self.width - qx)
            local qh = MathUtils.clamp(self.block_size, 0, self.height - qy)

            block.quad = love.graphics.newQuad(qx, qy, qw, qh, self.width, self.height)

            block.x = i * self.block_size
            block.y = j * self.block_size
            block.speed = 0
            block.delay = (i + j) * 1.5

            self.blocks[i][j] = block
        end
    end
end

function LightFatalEffect:onAdd(parent)
    super.onAdd(self, parent)

    self.start_color = self.color
end

function LightFatalEffect:update()
    self.red_timer = self.red_timer + DTMULT
    self.color = ColorUtils.mergeColor(self.start_color, { 1, 0, 0 }, self.red_timer / 10)

    for i = 0, self.blocks_x do
        for j = 0, self.blocks_y do
            local block = self.blocks[i][j]
            if block.delay <= 0 then
                block.speed = block.speed + DTMULT
            end
            local move = block.speed * DTMULT / 2
            block.x = block.x - move
            block.y = block.y - move
            block.delay = block.delay - DTMULT
        end
    end

    if self.blocks[self.blocks_x][self.blocks_y].speed >= 6 then
        self.done = true
        if self.after_func then
            self.after_func()
        end
        self:remove()
    end

    super.update(self)
end

function LightFatalEffect:draw()
    local r, g, b, a = self:getDrawColor()

    for i = 0, self.blocks_x do
        for j = 0, self.blocks_y do
            local block = self.blocks[i][j]
            Draw.setColor(r, g, b, a * (1 - (block.speed / 6)))
            Draw.draw(self.texture, block.quad, block.x, block.y)
        end
    end

    super.draw(self)
end

return LightFatalEffect
