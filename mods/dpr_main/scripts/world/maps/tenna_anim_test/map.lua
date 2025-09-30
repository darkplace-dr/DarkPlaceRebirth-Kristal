local TennaAnimTest, super = Class(Map)

function TennaAnimTest:init(world, data, ...)
    super.init(self, world, data)

    self.ind = 0

    self.anim_changed = false
    self.tenna_voicetimer = 0
end

function TennaAnimTest:update()
    super.update(self)
	
    Game.world.tenna = Game.world:getCharacter("tenna")

    if not OVERLAY_OPEN then
        if Input.pressed("right") then
            if self.ind < 69 then
                self.ind = self.ind + 1
            elseif self.ind >= 69 then
                self.ind = -3
            end
			
            if self.ind > 37 then
                self.ind = 69
            end
			
            Game.world.tenna.sprite:setPreset(self.ind)
        end

        if Input.pressed("left") then
            if self.ind > -3 then
                self.ind = self.ind - 1
            elseif self.ind <= -3 then
                self.ind = 69
            end
			
            if self.ind > 37 and self.ind < 69 then
                self.ind = 37
            end
			
            Game.world.tenna.sprite:setPreset(self.ind)
        end
	
	    if Input.pressed("left") or Input.pressed("right") then
            self.tenna_voice = true
            self.tenna_voicetimer = 0
        end

        if Input.pressed("b") then
            Game.world.tenna:setAnimation("idle")
        end
    end
	
    if self.tenna_voice then
        self.tenna_voicetimer = self.tenna_voicetimer + 1 * DTMULT
        if (self.tenna_voicetimer % 3) == 0 then
            Assets.stopAndPlaySound(Utils.pick{
                "voice/tenna/tv_voice_short_1",
                "voice/tenna/tv_voice_short_2",
                "voice/tenna/tv_voice_short_3",
                "voice/tenna/tv_voice_short_4",
                "voice/tenna/tv_voice_short_5",
                "voice/tenna/tv_voice_short_6",
                "voice/tenna/tv_voice_short_7",
                "voice/tenna/tv_voice_short_8",
                "voice/tenna/tv_voice_short_9"
            })
        end
        if self.tenna_voicetimer > 18 then
            self.tenna_voice = false
            self.tenna_voicetimer = 0
        end
    end
end

function TennaAnimTest:draw()
    super.draw(self)
	
    love.graphics.setFont(Assets.getFont("main"))
    love.graphics.printfOutline("Preset: "..self.ind, 6, 0, 2)
end

function TennaAnimTest:onEnter()
    super.onEnter(self)

    Game.world.music:setVolume(0.7)

    Game.lock_movement = true
end

return TennaAnimTest