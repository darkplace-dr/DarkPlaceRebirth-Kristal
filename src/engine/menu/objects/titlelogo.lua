---@class TitleLogo : Object
---@overload fun(...) : TitleLogo
local TitleLogo, super = Class(Object)

function TitleLogo:init(x, y, splash)
    super.init(self, x, y, 0, 0)

    self.logo = love.graphics.newImage("assets/sprites/kristal/title_logo_shadow.png")
    self.logo_text = love.graphics.newImage("assets/sprites/kristal/title/text.png")
    
    local date = os.date("*t")
    if date.month == 4 and date.day == 1 then
        self.logo_text = love.graphics.newImage("assets/sprites/kristal/title/fool.png")
    end
    
    self.logo_big_star = Sprite("kristal/title/big_star")
    self.logo_big_star:setOrigin(0.5)
    self.logo_big_star.x = 0
    self.logo_big_star.y = 0
    self:addChild(self.logo_big_star)
    
    self.logo_big_star_2 = Sprite("kristal/title/big_star")
    self.logo_big_star_2:setOrigin(0.5)
    self.logo_big_star_2:setScale(1.1)
    self.logo_big_star_2:setLayer(-1)
    self.logo_big_star_2.alpha = 0.5
    self.logo_big_star_2.x = 0
    self.logo_big_star_2.y = 0
    self:addChild(self.logo_big_star_2)
    
    self.logo_tagline = Sprite("kristal/title/tagline")
    self.logo_tagline:setOrigin(0.5)
    self.logo_tagline.x = 0
    self.logo_tagline.y = 70
    self:addChild(self.logo_tagline)
    
    self.splash = splash
    
    self.letter_offsets = {}
    self.letter_w = 52
    for i = 1, 10 do
        self.letter_offsets[i] = {
            quad = love.graphics.newQuad((i - 1) * self.letter_w, 0,
                self.letter_w, self.logo_text:getHeight(),
                self.logo_text:getWidth(), self.logo_text:getHeight()),
            x = -20, y = 0, alpha = 0
        }
    end
    
    self.time = 0

    self.splash_timer = 0
    
    self.fade = 1
end

function TitleLogo:update()
    super.update(self)
    
    self.time = self.time + DTMULT

    self.splash_timer = self.splash_timer + DT
    
    self.logo_big_star.rotation = (math.rad(0.05) * self.time)
    self.logo_big_star_2.rotation = (math.rad(0.049) * self.time)
    
    self.logo_tagline.alpha = self.fade
end

function TitleLogo:draw()
    super.draw(self)
    
    for i = 1, 10 do
        local off = self.letter_offsets[i]
        off.y = math.sin((self.time + i * 10) / 20) * 20 - 240

        if i <= math.min(10, math.floor((self.time + 4) / 4)) then
            off.x = Utils.ease(-10, 10, off.alpha, "out-cubic") - (2*self.logo_text:getWidth()/3) + 10
            off.alpha = MathUtils.approach(off.alpha, 1, 0.05 * DTMULT)
        end
    end
    for i = 1, 10 do
        local off = self.letter_offsets[i]
        love.graphics.setColor(1, 1, 1, off.alpha)
        love.graphics.draw(self.logo_text, off.quad, 66 + (i - 1) * self.letter_w + off.x, 220 + off.y)
    end
    
    self:drawSplashText()
end

function TitleLogo:drawSplashText()
    love.graphics.setColor(1, 1, 0, self.fade)
    local font = Assets.getFont("plain")
    love.graphics.setFont(font)
    local scale = 1 + math.sin(self.splash_timer) / 10
    local splash_angle, splash_x, splash_y
    splash_angle = math.rad(-16)
    splash_x, splash_y = 80, 80
    if DEBUG_RENDER then
        love.graphics.setColor(0.9, 0, 0.75, self.fade)
        love.graphics.rectangle("fill", splash_x, splash_y-5, 2, font:getHeight()+10)
        love.graphics.push()
        love.graphics.translate(splash_x, splash_y)
        love.graphics.rotate(splash_angle)
        love.graphics.setColor(0.5, 0.1, 0.5, self.fade)
        love.graphics.rectangle("fill", -2, 0, 2, font:getHeight()*scale)
        love.graphics.setColor(0.1, 0.5, 0.5, 0.5 * self.fade)
        love.graphics.rectangle("fill", -font:getWidth(self.splash)/2*scale, 0, font:getWidth(self.splash)*scale, font:getHeight()*scale)
        love.graphics.pop()
    end
    --text border
    love.graphics.setColor(0, 0, 0, self.fade)
    love.graphics.print(self.splash, splash_x - 2, splash_y, splash_angle, scale, scale, font:getWidth(self.splash)/2, 0)
    love.graphics.print(self.splash, splash_x - 2, splash_y - 2, splash_angle, scale, scale, font:getWidth(self.splash)/2, 0)
    love.graphics.print(self.splash, splash_x - 2, splash_y + 2, splash_angle, scale, scale, font:getWidth(self.splash)/2, 0)
    love.graphics.print(self.splash, splash_x + 2, splash_y, splash_angle, scale, scale, font:getWidth(self.splash)/2, 0)
    love.graphics.print(self.splash, splash_x + 2, splash_y - 2, splash_angle, scale, scale, font:getWidth(self.splash)/2, 0)
    love.graphics.print(self.splash, splash_x + 2, splash_y + 2, splash_angle, scale, scale, font:getWidth(self.splash)/2, 0)
    love.graphics.print(self.splash, splash_x, splash_y, splash_angle, scale, scale, font:getWidth(self.splash)/2, 0)
    love.graphics.print(self.splash, splash_x, splash_y - 2, splash_angle, scale, scale, font:getWidth(self.splash)/2, 0)
    love.graphics.print(self.splash, splash_x, splash_y + 2, splash_angle, scale, scale, font:getWidth(self.splash)/2, 0)
    --
    love.graphics.setColor(not self.april_fools and 1 or 0, not self.april_fools and 1 or 0, not self.april_fools and 0 or 1, self.fade)
    love.graphics.print(self.splash, splash_x, splash_y, splash_angle, scale, scale, font:getWidth(self.splash)/2, 0)
end

return TitleLogo
