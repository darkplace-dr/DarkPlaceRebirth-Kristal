local TeevieKeyboardTile, super = Class(Event)

function TeevieKeyboardTile:init(data)
    super.init(self, data)
	
    self.idle_sprite = "world/events/teevie_quiz/keyboard_tile_1"
    self.pressed_sprite = "world/events/teevie_quiz/keyboard_tile_2"

    self:setSprite(self.idle_sprite)
	self.sprite:setScale(1,1)
    self:setHitbox(15, 15, 10, 10)
	
	self.letter = "A"
	self.letter_sprite = Sprite("world/events/teevie_quiz/keyboard_text_"..self.letter)
	self.letter_sprite:setScale(2,2)
	self.letter_sprite:setLayer(self.layer + 1)
	self:addChild(self.letter_sprite)

    -- State variables
    self.pressed = false
	
	self.quizzer = nil
end

function TeevieKeyboardTile:setLetter()
    self.letter_sprite:setSprite("world/events/teevie_quiz/keyboard_text_"..self.letter)
end

function TeevieKeyboardTile:reset()
    self:setSprite(self.idle_sprite)
	self.sprite:setScale(1,1)
	self.letter_sprite.y = 0
	self.pressed = false
end

function TeevieKeyboardTile:press()
	if not self.pressed then
		self:setSprite(self.pressed_sprite)
		self.sprite:setScale(1,1)
		self.pressed = true
		self.letter_sprite.y = 4
		Assets.playSound("speak_and_spell_"..self.letter)
	end
end

function TeevieKeyboardTile:onCollide(chara)
	if chara.is_player then
		self:press()
	end
end

return TeevieKeyboardTile