local RambActorSprite, super = Class(ActorSprite)

function RambActorSprite:init(actor)
    super.init(self, actor)

	self.anim_timer = 0
    self.load_sprite = false

    self.body_x, self.body_y = 2, 19
    self.head_x, self.head_y = 0, 0
    self.body_anim = 1
    self.head_sprite_index = 0

    self.body = Sprite(self:getTexturePath("body"), self.body_x, self.body_y)
    if Game.world.map.id == "floortv/green_room" then
        self.body:setSprite(self:getTexturePath("body_clean"))
    else
        self.body:setSprite(self:getTexturePath("body"))
    end
    self.body.debug_select = false
    self:addChild(self.body)

    self.head = Sprite(self:getTexturePath("head_happy"), self.head_x, self.head_y)
    if Game.world.map.id == "floortv/green_room" then
        self.head:setSprite(self:getTexturePath("head_turned"))
    else
        self.head:setSprite(self:getTexturePath("head_happy"))
    end
    self.head.debug_select = false
    self:addChild(self.head)
end

function RambActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function RambActorSprite:set(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function RambActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function RambActorSprite:update()
    super.update(self)

    -- cleaning animation
    self.body_anim = self.body_anim + (0.1 * DTMULT)

    -- head animations
    if self.anim == "annoyed" then
        self.head:setSprite(self:getTexturePath("head_annoyed"))

    elseif self.anim == "happy" then
        self.head:setSprite(self:getTexturePath("head_happy"))

    elseif self.anim == "happy_nostalgic" then
        self.head:setSprite(self:getTexturePath("head_happy_nostalgic"))
        self.head:setFrame(math.floor(self.head_sprite_index))

    elseif self.anim == "nostalgic" then
        self.head:setSprite(self:getTexturePath("head_nostalgic"))

    elseif self.anim == "surprised" then
        self.head:setSprite(self:getTexturePath("head_surprised"))

    elseif self.anim == "turn" then
        self.head:setSprite(self:getTexturePath("head_turn"))
        self.head:setFrame(math.floor(self.head_sprite_index))

    elseif self.anim == "turn_look" then
        self.head:setSprite(self:getTexturePath("head_turn_look"))

    elseif self.anim == "turn_look_side" then
        self.head:setSprite(self:getTexturePath("head_turn_look_side"))

    elseif self.anim == "turn_subtle" then
        self.head:setSprite(self:getTexturePath("head_turn_subtle"))

    elseif self.anim == "turned" then
        self.head:setSprite(self:getTexturePath("head_turned"))
        self.head:setFrame(math.floor(self.head_sprite_index))

    else
        if Game.world.map.id == "floortv/green_room" then
            self.head:setSprite(self:getTexturePath("head_turned"))
            self.body:setFrame(math.floor(self.body_anim))
        else
            self.head:setSprite(self:getTexturePath("head_happy"))
            self.body:setFrame(1)
        end
    end
	
    -- this code is fucking abysmal, but hey it works lol
    if not self.load_sprite then
        self.load_sprite = true
        self.head_sprite_index = 1
    end
    if self.load_sprite then
        if self.anim == "happy_nostalgic" or self.anim == "turn" then
            self.head_sprite_index = self.head_sprite_index + (0.3 * DTMULT)
        else
            self.head_sprite_index = 1
        end

        if self.head_sprite_index > 4 then
            self.load_sprite = false

            if self.anim == "happy_nostalgic" then
                self.anim = "nostalgic"
            elseif self.anim == "turn" then
                self.anim = "happy"
            end
        end
    end
end

return RambActorSprite