local GameNotOver, super = Class(Object, "GameNotOver")

function GameNotOver:init(x, y)
    super.init(self, 0, 0)

    self.screenshot = love.graphics.newImage(SCREEN_CANVAS:newImageData())

    self.music = Music()

    self.soul = Sprite("player/heart")
    self.soul:setOrigin(0.5, 0.5)
    self.soul:setColor(Game:getSoulColor())
    self.soul.x = x
    self.soul.y = y

    self:addChild(self.soul)

    self.current_stage = 0
    self.fader_alpha = 0

    self.timer = 0
    self.shake_timer = 0
    
    local encounter = Game.battle and Game.battle.encounter and Game.battle.encounter.id
    local shop = Game.shop and Game.shop.id
    if encounter then
        self.reload = {"BATTLE", encounter}
    elseif shop then
        self.reload = {"SHOP", shop}
    end

    if Game:isLight() then
        self.timer = 28 -- We only wanna show one frame if we're in Undertale mode
    end
    
    if Game.battle then -- Battle type correction
        if Game.battle.light then
            self.timer = 28
        else
            self.timer = 0
        end
    end
end

function GameNotOver:onRemove(parent)
    super.onRemove(self, parent)

    self.music:remove()
end


function GameNotOver:update()
    super.update(self)

    self.timer = self.timer + DTMULT
    if (self.timer >= 30) and (self.current_stage == 0) then
        self.screenshot = nil
        self.current_stage = 1
    end
    if (self.timer >= 50) and (self.current_stage == 1) then
        Assets.playSound("break1")
        self.soul:setSprite("player/heart_break")
        if MagicalGlassLib.revived_once then
            self.current_stage = 11
        else
            self.current_stage = 2
        end
    end
    if (self.timer >= 130) and (self.current_stage == 2) or (self.timer >= 70) and (self.current_stage == 11) then
        self.shake_timer = self.shake_timer + DTMULT
        if self.shake_timer >= 1 then
            self.soul:shake(Utils.random(-3, 3), Utils.random(-3, 3))
            self.shake_timer = 0
        end
    end
    if (self.timer >= 170) and (self.current_stage == 2) or (self.timer >= 90) and (self.current_stage == 11) then
        self.soul:stopShake()
        Assets.playSound("break1")
        self.soul:setSprite("player/heart")
        self.soul.x = self.soul.x + 2
        self.current_stage = self.current_stage + 1 -- 3 // 12
    end
    if (self.timer >= 200) and (self.current_stage == 3) then
        self.dialogue = DialogueText("[noskip][speed:0.5][voice:none]* But it refused.", 205, 120, {style = "none"})
        self:addChild(self.dialogue)
        self.current_stage = 4
    end
    if (self.timer >= 270) and (self.current_stage == 4) or (self.timer >= 110) and (self.current_stage == 12) then
        self.fader_alpha = self.fader_alpha + 0.03 * DTMULT
    end
    if (self.timer >= 287) and (self.current_stage == 4) and self.dialogue.parent then
        self.dialogue:remove()
    end
    if (self.timer >= 308) and (self.current_stage == 4) or (self.timer >= 148) and (self.current_stage == 12) then
        MagicalGlassLib.revived_once = true
        for _,party in pairs(Game.party_data) do
            party:heal(math.huge, false)
        end
        Game:saveQuick()
        Game:loadQuick()
        if self.reload then
            if self.reload[1] == "BATTLE" then
                Game:encounter(self.reload[2], false)
                if Game.battle.light then
                    local function has_soul() return Game.battle.soul end
                    Game.battle.timer:afterCond(has_soul, function() -- apply inv frames
                        Game.battle.soul.inv_timer = Game:isLight() and 1 or (4/3)
                        local best_amount
                        for _,battler in ipairs(Game.battle.party) do
                            local equip_amount = 0
                            for _,equip in ipairs(battler.chara:getEquipment()) do
                                if equip.getInvBonus then
                                    equip_amount = equip_amount + equip:getInvBonus()
                                end
                            end
                            if not best_amount or equip_amount > best_amount then
                                best_amount = equip_amount
                            end
                        end
                        Game.battle.soul.inv_timer = Game.battle.soul.inv_timer + best_amount
                    end)
                end
            elseif self.reload[1] == "SHOP" then -- If we were in a shop, re-enter it
                Game:enterShop(self.reload[2])
            end
        end
        Game.fader:fadeIn(nil, {alpha = 1, speed = 1.2, color = {1, 1, 1}})
    end
end

function GameNotOver:draw()
    super.draw(self)

    if self.screenshot then
        Draw.setColor(1, 1, 1, 1)
        Draw.draw(self.screenshot)
    end

    Draw.setColor(1, 1, 1, self.fader_alpha)
    love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    Draw.setColor(1, 1, 1, 1)
end

function GameNotOver:onKeyPressed(key)
    -- ?
end

return GameNotOver