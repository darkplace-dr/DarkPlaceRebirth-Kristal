local Stardust, super = Class(Wave)

function Stardust:init()
    super.init(self)
    self.time = 14
    self.starwalker = self:getAttackers()[1]
    self.starwalker.layer = self.starwalker.layer + 500
	
	self:setArenaSize(240, 110)

    self.spawn_bullets = true
end

function Stardust:onStart()
    self.starwalker:setMode("flying")

    self.timer:after(0.1, function()
        self.timer:every(0.1, function()
            if self.spawn_bullets then
                local stardust = self:spawnBullet("starwalker/stardust", self.starwalker.x, self.starwalker.y - 20)
                stardust.inv_timer = 10/30
            end
        end)
        self.timer:every(0.2, function()
            if self.spawn_bullets then
                Assets.playSound("sparkle_glock", 0.5, Utils.random(1.2, 1.5))
            end
        end)
    end)

    if not Game:isSpecialMode "BLUE" then
        self.timer:after(10, function()
            self.spawn_bullets = false

            self.starwalker:setMode("still")
            self.starwalker.sprite:set("reaching")
            Assets.playSound("ui_select")
		
            self.timer:after(2, function()
                self.starwalker.sprite:set("acting")
                Assets.playSound("sparkle_glock")
                local afterimage = AfterImage(self.starwalker, 0.5)
                afterimage.graphics.grow_x = 0.05
                afterimage.graphics.grow_y = 0.05
                afterimage.layer = self.starwalker.layer - 1
                Game.battle:addChild(afterimage)

                self.timer:after(0.5, function()
                    Assets.playSound("great_shine", 1, 0.8)
                    Assets.playSound("great_shine")
                    Assets.playSound("closet_impact", 1, 1.5)
                    Game.battle:swapSoul(Soul())

                    local soulafterimage = AfterImage(Game.battle.soul.sprite, 1)
                    soulafterimage.graphics.grow_x = 0.2
                    soulafterimage.graphics.grow_y = 0.2
                    Game.battle.soul:addChild(soulafterimage)
                    soulafterimage.y = soulafterimage.y - 8
                end)
            end)
        end)
    end
end

function Stardust:onEnd()
    self.starwalker:setMode("normal")
    self.starwalker.sprite:set("wings")
    self.starwalker.layer = self.starwalker.layer - 500
    self.starwalker.blue = false

    super.onEnd(self)
end

function Stardust:update()
    super.update(self)
end

return Stardust
