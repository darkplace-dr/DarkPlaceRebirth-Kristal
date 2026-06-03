local RecruitMenu, super = HookSystem.hookScript(RecruitMenu)

function RecruitMenu:init()
    super.init(self)
    
    if Game:isLight() then
        if self.heart then
            self.heart:remove()
            self.heart = nil
        end
        self.heart = Sprite("player/heart_menu", 65, 117)
        self.heart:setScale(2)
        self.heart:setOrigin(0.5, 0.5)
        self.heart:setColor(Game:getSoulColor())
        self.heart.layer = 100
        self:addChild(self.heart)
    end
end

function RecruitMenu:update()
    super.update(self)

    if Game:isLight() then
        -- Instantly update position
        if self.state == "SELECT" then
            self.heart.x = 65
            self.heart.y = 117 + (self.selected - (self.selected_page - 1) * self:getLimit() - 1) * 35
            self.heart_target_x, self.heart_target_y  = self.heart.x, self.heart.y
        else
            self.heart.x = 65
            self.heart.y = 416
            self.heart_target_x, self.heart_target_y  = self.heart.x, self.heart.y
        end
    end
end

return RecruitMenu