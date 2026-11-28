local ScissorsActPlayer, super = HookSystem.hookScript("ScissorsActPlayer")

function ScissorsActPlayer:onBattlerCollision(battler)
    if battler.chara.id == "jamm" then
        Assets.playSound("magicsprinkle")
        local x, y = battler:getRelativePos()
        for i = 0, 7 do
            local cloud = ShinobeetleSmokecloud(x + 35, y + 30)
            cloud.layer = battler.layer + 1
            cloud:setFrame(i + 1)
            cloud:stop()
            cloud.physics.direction = -math.rad(45 + (i * 90))
            cloud.physics.speed = 2 + MathUtils.random(1)
            cloud.alpha = cloud.alpha - MathUtils.random(0.07)
            Game.battle:addChild(cloud)
        end
        battler:setActSprite("party/jamm/dark/hairs_" .. TableUtils.pick({ 1, 2, 3 }), -5, 0)
    end
	super.onBattlerCollision(self, battler)
end

return ScissorsActPlayer
