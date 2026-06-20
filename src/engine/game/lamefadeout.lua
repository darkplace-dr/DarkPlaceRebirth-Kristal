---@class LameFadeout
-- Shows a screenshot fading out while the next DLC is loading.
local LameFadeout = {}

function LameFadeout:init()
    self.screenshot = nil
    self.type = nil
    self.progress = 0
    self.on_finish = nil

    self.whiten_speed = 80/30
    self.darken_speed = 2
end

function LameFadeout:enter(_, type)
    self.type = type
    self.progress = 0
    self.screenshot = love.graphics.newImage(SCREEN_CANVAS:newImageData())
    self.on_finish = nil
end

function LameFadeout:update()
    self.progress = MathUtils.approach(self.progress, self.type == "WHITEN" and 2 or 1, DT)
    if self.progress >= 1 and self.on_finish then
        self.on_finish = nil
        self.on_finish()
    end
end

function LameFadeout:setFinishCallback(on_finish)
    if self.progress >= 1 then
        self.on_finish()
    else
        self.on_finish = on_finish
    end
end

function LameFadeout:draw()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.setColor(1, 1, 1, 1)

    local mode, alphamode = love.graphics.getBlendMode()
    love.graphics.setBlendMode(mode, "premultiplied")
    Draw.draw(self.screenshot)
    love.graphics.setBlendMode(mode, alphamode)

    if self.type == "WHITEN" then
        local whiten_alpha = math.min(self.progress, 1) * self.whiten_speed
        love.graphics.setColor(1, 1, 1, whiten_alpha)
        love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    end

    local darken_alpha = (self.type == "WHITEN" and (self.progress - 1) or self.progress) * self.darken_speed
    love.graphics.setColor(0, 0, 0, darken_alpha)
    love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
end

function LameFadeout:leave()
    self.screenshot = nil
    self.on_finish = nil
end

return LameFadeout
