local LightShopbox, super = Class(Object, "LightShopbox")

function LightShopbox:init()
    super.init(self, 432, 208)

    self:setParallax(0, 0)

    self.box = UIBox(0, 0, 154, 60)
    self.box.layer = -1
    self:addChild(self.box)

    self.font = Assets.getFont("main")
end

function LightShopbox:draw()
    super.draw(self)

    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])
    love.graphics.print("$ - " .. (Game:getConfig("lightCurrencyShort") ~= "$" and Game.lw_money..Game:getConfig("lightCurrencyShort") or Game:getConfig("lightCurrencyShort")..Game.lw_money), 40 - 36, 312 - 220 - 100)
    love.graphics.print("SPACE - " .. Game.inventory:getItemCount("items", false) .. "/" .. Game.inventory:getStorage("items").max , 40 - 36, 300 + 60 - 8 - 220 - 100)
end

return LightShopbox