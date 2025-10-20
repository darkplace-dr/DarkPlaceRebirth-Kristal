local blue_battle_ui, super = Class(Object)

function blue_battle_ui:init()
    super.init(self)
    self.width = 160
    self.height = 144

    self.true_scale = Sprite("true_scale")
    self.true_scale:setScale(2)
    self:addChild(self.true_scale)

    --for i, party in ipairs(Game.party) do
        --table.insert(full_party, party)
        --local ui_box = 
    --end

    --self.true_scale = Sprite("ui_box")
    --self.true_scale:setScale(2)
    --self:addChild(self.true_scale)
    --self.true_scale.x, self.true_scale.y = 12, 204 --slot 1
    --self.true_scale.x, self.true_scale.y = 172, 204 --slot 2 


    --self.true_scale.x, self.true_scale.y = 92, 204 --slot 1 for single battler

    if #Game.party == 2 then
        
    elseif #Game.party == 1 then
    end

end

function blue_battle_ui:update()
    super.update(self)
 
end

function blue_battle_ui:draw()
    Draw.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, 160*2, 144*2)
    super.draw(self)
end

return blue_battle_ui