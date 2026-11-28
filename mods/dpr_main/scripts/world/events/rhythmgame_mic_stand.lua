local RhythmGameMicStand, super = Class(Event)

function RhythmGameMicStand:init(data)
    super.init(self, data)

    self:setOrigin(0.5, 1)
    self:setSprite("minigames/rhythmgame_mic_stand_1")
	self:setHitbox(8, 44, 20, 24)
	
	self.outline_sprite = Sprite("minigames/rhythmgame_mic_stand_2")
	self.outline_sprite:addFX(LeaderColorFX())
	self.outline_sprite:setScale(2)
	self:addChild(self.outline_sprite)
	
    self.solid = true
end

function RhythmGameMicStand:onInteract()
    Game.world:startCutscene("floor2.rhythmgame_start")
end

return RhythmGameMicStand