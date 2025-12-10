---@class UsefountainSoul : Object
local PurifySoul, super = Class(Object)

-- Soul sprite used in the fountain sealing cutscene
function PurifySoul:init(x, y)
    self.texture = Assets.getTexture("player/heart")
    super.init(self, x, y, self.texture:getWidth(), self.texture:getHeight())

    self:setOrigin(0.5, 0.5)
    --self:setColor(COLORS.red)

    self.siner = 0
    self.t = 395
    self.image_alpha = 1
    self.timer = 0
end


function PurifySoul:draw()
    super.draw(self)



    self.siner = self.siner + 3 * DTMULT
    self.t = self.t + 2 * DTMULT


    local r, g, b, a = self:getDrawColor()
    local function drawSprite(x_scale, y_scale, alpha)
        love.graphics.setColor(r, g, b, a * alpha)
        love.graphics.draw(self.texture, self.width / 2, self.height / 2, nil, self.scale_x * x_scale,
            self.scale_y * y_scale, self.width * self.origin_x, self.width * self.origin_y)
    end



    if self.t >= 540 then
        self.image_alpha = self.image_alpha - 0.2 * DTMULT
        drawSprite(1, 1, self.image_alpha)
    else

        drawSprite(1, 1, self.siner / 8)

        if self.t >= 430 then
            if self.t <= 440 then
                self.timer = self.timer + 20 * DTMULT
            end

            if self.t >= 450 then
                self.timer = self.timer - 2 * DTMULT
            end

            drawSprite(1, 1, self.timer / 100)
        else
            drawSprite(self.siner / 4, self.siner / 4, 1 + 0.6 - self.siner / 16)
            drawSprite(self.siner / 8, self.siner / 8, 1 + 0.6 - self.siner / 24)
        end
    end

    if self.t >= 550 then
        self:remove()
    end

        --love.graphics.setFont(Assets.getFont("main_mono"))
            --love.graphics.print("drawing?:" .. tostring(self.t), 0, 120)

    love.graphics.setColor(1, 1, 1, 1)
end

function PurifySoul:shine()
    self.siner = 3
end

return PurifySoul
