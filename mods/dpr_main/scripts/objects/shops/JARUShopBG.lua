local JARUShopBG, super = Class(Object)

function JARUShopBG:init()
    super.init(self)

    self.shop_bg = Assets.getTexture("ui/shop/jaru_shop_background")
    self.space_bg = Assets.getTexture("world/maps/devroom/spacebg")
    self.vhs = Assets.getTexture("ui/shop/jaru_shop_vapor_vhs")

    self.siner = 0
    self.hue = math.random()
    self.random_trinkets = math.floor(Utils.random(1, 3))

    self.debug_select = false
end

function JARUShopBG:update()
    super.update(self)

    self.siner = self.siner + 0.3 * DTMULT

    self.hue = self.hue + DTMULT/640
    if self.hue > 1 then
        self.hue = self.hue - 1
    end
end

function JARUShopBG:draw()
    super.draw(self)

    Draw.setColor({self:HSV(self.hue, 1, 1)}, 1)
    Draw.drawWrapped(self.space_bg, true, false, self.siner, 0, 0, 1, 1)

    Draw.setColor({COLORS.black}, 1)
    Draw.rectangle("fill", 0, self.shop_bg:getHeight()*2, SCREEN_WIDTH, self.space_bg:getHeight() - self.shop_bg:getHeight())

    Draw.setColor({COLORS.white}, 1)
    Draw.draw(self.shop_bg, 0, 0, 0, 2, 2)

    if self.random_trinkets == 1 then
        Draw.draw(Assets.getTexture("ui/shop/jaru_shop_trinkets_1"), 0, 27*2, 0, 2, 2)
    elseif self.random_trinkets == 2 then
        Draw.draw(Assets.getTexture("ui/shop/jaru_shop_trinkets_1"), 0, 27*2, 0, 2, 2)
    elseif self.random_trinkets == 3 then
        Draw.draw(Assets.getTexture("ui/shop/jaru_shop_trinkets_1"), 0, 27*2, 0, 2, 2)
    end

    Draw.draw(self.vhs, 34*2, 37*2, 0, 2, 2)
end

-- Function from the love2d wiki, converts HSV to RGB
function JARUShopBG:HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end

return JARUShopBG