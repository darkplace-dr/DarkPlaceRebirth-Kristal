local actor, super = Class(Actor, "noel")

function actor:pickRandomDigit()
    local number = "82352941176471"
    local index = math.random(1, #number)
    return number:sub(index, index)
end

local function h(hex)
    return {tonumber(string.sub(hex, 2, 3), 16)/255, tonumber(string.sub(hex, 4, 5), 16)/255, tonumber(string.sub(hex, 6, 7), 16)/255, value or 1}
end

function actor:normalUpdates(sprite)
    if sprite.sprite.cust then
        local fx = sprite.sprite:getFX(OutlineFX)
        local col = sprite.sprite.cust.outline
        fx:setColor(col[1], col[2], col[3])
        sprite:setColor(sprite.sprite.cust.color)
    end
end

function actor:onSpriteInit(sprite)
    sprite:addFX(OutlineFX(self.color))
    --print(sprite.sprite_options[1])
    self.b_tog = math.random(10)

    if self.b_tog == 9 and Noel:isDess() == false then

        self.next_time = (os.date("%S") + self:pickRandomDigit())

        function self:onWorldDraw(chara)
            self:blinkDraw(chara)
        end
        function self:onBattleDraw(chara)
            self:blinkDraw(chara)
        end
    else
        function self:onWorldDraw(chara)
            self:normalUpdates(chara)
        end
        function self:onBattleDraw(chara)
        end
    end

    local fun = Noel:getFlag("FUN")
    if fun == 56 then
        sprite.cust = {outline = {0, 0, 1}, color = {1, 0, 0}}
    end

    if Game:getPartyMember("noel").kills >= 100 then
        sprite:addFX(PaletteFX({h '#585858', h '#272727',}, {h '#a6504d',h '#6a2020',}))
    end

    if Noel:isDess() then
        self.default = "dess_mode/walk"
        self.animations["battle/idle"] = {"dess_mode/battle/idle", 0.2, true}
        self.menu_anim = "dess_mode/walk/down_1"
    else
        self.default = "walk"
        
        self.menu_anim = "brella"
    end
end

--Up and down didnt look nice enough
--[[
--print(Game.world.player.sprite.sprite_options[1])
function Actor:onWorldDraw(chara)
    if chara.running and chara.running == true and not chara.running == false then
        --print("woah")
        if chara.facing == "left" then
            chara.rotation = 0.2
            chara.scale_y = 2
        elseif chara.facing == "right" then
            chara.rotation = -0.2
            chara.scale_y = 2
        elseif chara.facing == "down" then
            chara.rotation = 0
            chara.scale_y = 2.1
        elseif chara.facing == "up" then
            chara.rotation = 0
            chara.scale_y = 1.9
        else
            chara.rotation = 0
            chara.scale_y = 2

        end
    elseif chara.rotation ~= 0 or chara.scale_y ~= 2 then
        chara.rotation = 0
        chara.scale_y = 2
    end
end
-- this was another running thingy

function Actor:onWorldDraw(chara)

    local player = Game.world.player

    if chara.is_follower and player.run_timer > 0 then
        local sprite = chara.sprite.sprite_options[1]
        if self.sprite_runs[sprite] then
            chara.sprite.y = 2
        else
            chara.sprite.y = 0
        end
    end
end
]]

function actor:init()
    super.init(self)

    local save = Noel:loadNoel()

    self.noel = true

    self.name = "Noel"
    self.width = 33
    self.height = 40
    self.hitbox = {7, 28, 19, 14}
    self.color = {1, 1, 1}
    self.path = "party/noel"

    if Noel:isDess() then
        self.default = "dess_mode/walk"
        
        self.menu_anim = "dess_mode/walk/down_1"
    else
        self.default = "walk"
        
        self.menu_anim = "brella"
    end

    self.voice = "noel"

    self.portrait_path = "face/noel"

    self.portrait_offset = {-22, -24}

    self.can_blush = false

    self.animations = {
        ["stop"]         = {"stop/stop", 1/12, false},
        ["battle/a"]         = {"battle/a", 0.2, true},
        ["battle/idle"]         = {"battle/idle", 0.2, true},
        ["battle/defeat"]         = {"battle/down", 0.2, false},
        ["battle/swooned"]      = {"battle/down", 1/15, false},
        ["battle/attack_ready"] = {"battle/attack_ready", 1/60, false},
        ["battle/spell_ready"]  = {"battle/attack_ready", 1/8, false},
        ["battle/attack"]         = {"battle/attack", 1/35, false},

        ["battle/attack_repeat"] = {"battle/attack", 1/60, false, next="battle/attack_ready"},

        ["sitting"] = {"sitting"},
        ["brella"] = {"brella"},
        ["ashes_0"] = {"ashes_0"},
        ["ashes_1"] = {"ashes_1"},
        ["landed"] = {"landed", 1/15},
        ["jump_ball"] = {"ball", 1/15, true},
    }

    self.offsets = {
        ["battle/a"] = {-28, -18},
        ["stop/stop"] = {-28, -18},
        ["battle/idle"] = {-28, -18},
        ["dess_mode/battle/idle"] = {-28, -18},
        ["battle/down"] = {-28, -18},
        ["battle/you_gonna_hit_me"] = {-28, -18},
        ["battle/boo_you_suck"] = {-28, -18},
        ["battle/attack"] = {-28, -18},
        ["battle/attack_ready"] = {-28, -18},

        ["sitting"] = {0, 13},

        ["brella"] = {-6, -7},

        --["dess_mode/walk"] = {-4, -10},

        ["dess_mode/walk/up"] = {-4, -10},
        ["dess_mode/walk/down"] = {-4, -10},
        ["dess_mode/walk/left"] = {-4, -10},
        ["dess_mode/walk/right"] = {-4, -10},

        ["walk/down"] = {0, 1},
        ["walk/up"] = {0, 1},
        ["walk/left"] = {0, 1},
        ["walk/right"] = {0, 1},


        ["sneak/left"] = {-4, -10},

        ["sneak/right"] = {-4, -10},

    }

    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
        
        ["dess_mode/walk/down"] = "walk/up",
        ["dess_mode/walk/up"] = "walk/down",
        ["dess_mode/walk/left"] = "walk/left",
        ["dess_mode/walk/right"] = "walk/right",
    }


    self.sprite_runs = {
        "walk/up_2",
        "walk/up_4",
        "walk/down_2",
        "walk/down_4",
        "walk/left_2",
        "walk/left_4",
        "walk/right_2",
        "walk/right_4",
    }

    self.sprite_rects = {
        brella = {
            {14, 11, 6, 2},
            {14, 14, 6, 1}
        },
        ["walk/down_1"] = {
            {13, 10, 7, 3},
            {13, 14, 7, 1}
        },
        ["walk/down_3"] = {
            {13, 10, 7, 3},
            {13, 14, 7, 1}
        },
        ["walk/down_2"] = {
            {13, 11, 7, 3},
            {13, 15, 7, 1}
        },
        ["walk/down_4"] = {
            {13, 11, 7, 3},
            {13, 15, 7, 1}
        },
        ["walk/left_1"] = {
            {12, 10, 3, 3},
            {12, 14, 3, 1}
        },
        ["walk/left_3"] = {
            {12, 10, 3, 3},
            {12, 14, 3, 1}
        },
        ["walk/left_2"] = {
            {12, 12, 3, 3},
            {12, 15, 3, 1}
        },
        ["walk/left_4"] = {
            {11, 11, 3, 3},
            {11, 15, 3, 1}
        },
        ["walk/right_1"] = {
            {18, 10, 3, 3},
            {18, 14, 3, 1}
        },
        ["walk/right_3"] = {
            {18, 10, 3, 3},
            {18, 14, 3, 1}
        },
        ["walk/right_2"] = {
            {18, 11, 3, 3},
            {18, 15, 3, 1}
        },
        ["walk/right_4"] = {
            {19, 11, 3, 3},
            {19, 15, 3, 1}
        }
    }

end

function actor:onTextSound(node)
    Assets.playSound("voice/noel/"..string.lower(node.character), 1, 1)
    return true
end

function actor:blinkDraw(chara)
    local s = 195/255
    self.second = os.date("%S") + 0

    if self.next_time <= self.second then
        self.next_time = self:pickRandomDigit() + os.date("%S")
        if self.next_time > (59) then
            self.next_time = (self.next_time - 59)
        end
        self.blink = 0
    end
    if self.blink then
        local sprite = chara.sprite.sprite_options[1]
        Draw.setColor(s, s, s, 1)

        if self.sprite_rects[sprite] then
            for _, rect in ipairs(self.sprite_rects[sprite]) do
                love.graphics.rectangle("fill", rect[1], rect[2], rect[3], rect[4])
            end
        end

        if self.blink >= 1 then
            self.blink = nil
        else
            self.blink = (self.blink + DTMULT)
        end
    end
end

return actor