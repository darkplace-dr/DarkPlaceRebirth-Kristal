local actor, super = Class(Actor, "diamond_giant_shop")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Diamond"
    self.voice = nil
    self.width = 164
    self.height = 202

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 0, 164, 202}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 1, 1}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = 0

    -- Path to this actor's sprites (defaults to "")
    self.path = "shopkeepers/diamond_giant"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "torso"

    -- Table of sprite animations
    self.animations = {
        ["idle"]               = {"torso"},
        ["talk"]         = {"torso"},
    }
    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["torso"] = {0, 130},
        ["blink"] = {0, 130},
        ["talk"] = {0, 130},
        ["talk_3"] = {0, 130},
        ["huh"] = {0, 130},
        ["lookdown"] = {0, 130},
        ["look_left"] = {0, 130},
    }
end

function actor:onSpriteInit(sprite)
    super.onSpriteInit(sprite)
    sprite.alpha = 0

    sprite.head = Sprite(self.path.."/head")
    sprite.head.x = 79
    sprite.head.y = 92 - 3
    sprite.head:setOrigin(0.5, 1)
    sprite:addChild(sprite.head)

    sprite.c_1 = Sprite(self.path.."/circle")
    sprite.c_1.x = 55
    sprite.c_1.y = 73
    sprite.c_1:setOrigin(0.5, 0.5)
    sprite:addChild(sprite.c_1)

    sprite.c_2 = Sprite(self.path.."/circle")
    sprite.c_2.x = 103
    sprite.c_2.y = 73
    sprite.c_2:setOrigin(0.5, 0.5)
    sprite:addChild(sprite.c_2)

    sprite.e_1 = Sprite(self.path.."/eye")
    sprite.e_1.x = 58
    sprite.e_1.y = 66
    sprite.e_1:setOrigin(0.5, 1)
    sprite:addChild(sprite.e_1)

    sprite.e_2 = Sprite(self.path.."/eye")
    --sprite.e_2.x = 58
    --sprite.e_2.y = 66
    sprite.e_2:setOrigin(0.5, 1)
    sprite:addChild(sprite.e_2)

    sprite.torso = Sprite(self.path.."/torso")
    sprite.torso.x = -3
    sprite.torso.y = 90 - 3
    sprite:addChild(sprite.torso)

    sprite.timer = 0
    sprite.next_time = (os.date("%S") + self:pickRandomDigit())

end

function actor:pickRandomDigit()
    local number = "82352941176471"
    local index = math.random(1, #number)
    return number:sub(index, index)
end

function actor:onSpriteDraw(sprite)
    super.onSpriteDraw(sprite)
    local h = sprite.head
    local max = 0.09
    local s = sprite
    
    local spx = math.sin(love.timer.getTime()) * max
    s.head.rotation = spx/2

    s.timer = sprite.timer + DT
    if s.timer >= 6.3 then
        s.spin1 = nil
        s.spin2 = nil
        s.timer = 0
        s.c_1.rotation = 0
        s.c_2.rotation = 0
    elseif s.timer >= 2.2 and not s.spin2 then 
        s.spin2 = true
        local b = s.c_2
        Game.shop.timer:tween(1, b, {rotation = math.pi*2}, "out-sine")
    elseif sprite.timer >= 2 and not sprite.spin1 then 
        s.spin1 = true
        local w = sprite.c_1
        Game.shop.timer:tween(1, w, {rotation = math.pi*2}, "out-sine")
    end
    local sp = spx
    if sp > 0 then sp = sp*-1 end

    s.head:setOrigin(0.5 + -spx/6, 1 + sp/6)
    s.torso:setOrigin(-spx/10, 0 + sp/10)

    s.c_1.x = 56 + spx*25
    s.c_1.y = 73 - sp*25

    s.c_2.x = 103 + spx*25
    s.c_2.y = 73 - sp*25
    

    local e1 = s.e_1
    local e2 = s.e_2
    e1.rotation = spx*1.5
    e1.x = 60 + spx*40
    e1.y = 66 - sp*25

    e2.rotation = spx*1.5
    e2.x = 98 + spx*40
    e2.y = 66 - sp*25

    s.second = os.date("%S") + 0
    if s.next_time <= s.second then
        s.next_time = self:pickRandomDigit() + os.date("%S")
        if s.next_time > (59) then
            s.next_time = (s.next_time - 59)
        end
        e1:setScale(2, 0.2)
        Game.shop.timer:tween(0.1, e1, {scale_x = 1, scale_y = 1})
        e2:setScale(2, 0.2)
        Game.shop.timer:tween(0.1, e2, {scale_x = 1, scale_y = 1})
    end


end
return actor