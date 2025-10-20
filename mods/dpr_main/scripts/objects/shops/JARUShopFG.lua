local JARUShopFG, super = Class(Object)

function JARUShopFG:init()
    super.init(self)

    self.shop_fg = Assets.getTexture("ui/shop/jaru_shop_foreground")
    self.mug = Assets.getTexture("ui/shop/jaru_shop_mug")
    self.gromit_mug = Assets.getTexture("ui/shop/jaru_shop_gromit_mug")
    self.steam = Assets.getFrames("ui/shop/steam")

    self.siner = 0
    self.which_mug = math.floor(Utils.random(1, 50))

    self.debug_select = false
end

function JARUShopFG:update()
    super.update(self)

    self.siner = self.siner + DTMULT
end

function JARUShopFG:draw()
    super.draw(self)
	
    if DEBUG_RENDER then
        love.graphics.setColor(Utils.hexToRgb("#0AC1FF"), 1)
        local font = Assets.getFont("main")
        love.graphics.setFont(font)
        local dbg = string.format(
[[siner=%.2f
which_mug=%.2f]],
            self.siner, 
            self.which_mug
        )
		
        local _, dbg_wrap = font:getWrap(dbg, SCREEN_WIDTH)
        love.graphics.printf(dbg, 0, font:getHeight()*0.5*#dbg_wrap, SCREEN_WIDTH*2, "right", 0, 0.5, 0.5)
    end

    Draw.setColor({COLORS.white}, 1)
    Draw.draw(self.shop_fg, 0, 0, 0, 2, 2)

    if self.which_mug == 1 then
        Draw.draw(self.gromit_mug, 222*2, 82*2, 0, 2, 2)
    else
        Draw.draw(self.mug, 222*2, 82*2, 0, 2, 2)
    end
	
	local steam_frame = math.floor(self.siner / 20) % #self.steam + 1
    Draw.draw(self.steam[steam_frame], 476, (124 + (math.sin(self.siner / 8)) * 2), 0, 2, 2)
end

return JARUShopFG