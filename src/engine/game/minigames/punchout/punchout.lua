---@class PunchOut : Minigame
---@field levelScript? fun(self:PunchOut, wait:fun(time:number))
local PunchOut, super = Class("Minigame")

function PunchOut:init()
    super.init(self)

    self.name = "Punch-Out!!"

    self.state = "TRANSITION" -- TRANSITION, INTRO, MAIN, DEAD, WIN, TRANSITIONOUT1, TRANSITIONOUT2
    --Assets.playSound("minigames/ball_jump/transition")

    self.timer = Timer()
    self:addChild(self.timer)

    self.music = Music()

    self.rectbg = Rectangle(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0)
    self.rectbg:setOrigin(0.5,0.5)
    self.rectbg.color = {0,0,0}
    self:addChild(self.rectbg)

    self.state_timer = 0
    self.state_progress = 0
    
    self.hero_hp = 500
    self.queen_hp = 1000
    
    self.hero_hp_max = self.hero_hp
    self.queen_hp_max = self.queen_hp
    
    self.round_timer = 2970
    
    self.boxing_script_handle = nil

    self.entities = {}

    self.font = Assets.getFont("main", 32)
    self.font2 = Assets.getFont("main", 64)
    
    self.bg = Sprite("minigames/punch_out/bg", 160, 120)
    self.bg.layer = self.rectbg.layer + 2
    self.bg.alpha = 0
    self:addChild(self.bg)
    self.border_bg = Sprite("minigames/punch_out/bg", 0, 0)
    self.border_bg:setScale(2)
    self.border_bg.layer = self.rectbg.layer + 1
    self.border_bg.alpha = -0.3
    self:addChild(self.border_bg)

    self.boxing_phase = 0
    
    self.fade_alpha = 0

    self.attack_type = 0
    self.attack_amount = 0
    self.attack_threshold = 45
    self.attack_threshold_base = 45
    self.attack_count = 0
    self.attack_count_max = 0
    
    self.draw_arrows_mode = 0
    self.pacifist = 1
    self.queen_face_scale = 0.01

    self:resetQueen()
    
    self.hero_hp_text = Assets.getTexture("minigames/punch_out/hero_hp")
    self.queen_hp_text = Assets.getTexture("minigames/punch_out/queen_hp")
    self.time_text = Assets.getTexture("minigames/punch_out/time")
    self.you_lose_text = Assets.getTexture("minigames/punch_out/you_lose")
    self.give_up_text = Assets.getTexture("minigames/punch_out/give_up")
    self.fight_again = Assets.getTexture("minigames/punch_out/fight_again_1")
    self.fight_again_sel = Assets.getTexture("minigames/punch_out/fight_again_2")
    self.retire = Assets.getTexture("minigames/punch_out/retire_1")
    self.retire_sel = Assets.getTexture("minigames/punch_out/retire_2")
    self.arrow = Assets.getTexture("minigames/punch_out/arrow")

    local party = Game.party[1]
    if party and party.color then
        self.hero_color = party.color
    else
        self.hero_color = {0, 1, 1}
    end
end

function PunchOut:postInit()
    self:pauseWorldMusic()
end

function PunchOut:update()
    self.state_timer = self.state_timer + DT
    if self.state == "TRANSITION" then
        self.rectbg.width = SCREEN_WIDTH * self.state_timer
        self.rectbg.height = SCREEN_HEIGHT * self.state_timer
        if self.state_timer > 1 then
            self.fade_alpha = 1
            self.bg.alpha = 1
            self:setState("INTRO")
        end
    elseif self.state == "INTRO" then
        self.fade_alpha = self.fade_alpha - 0.05 * DTMULT
        if self.border_bg.alpha < 0.3 then
            self.border_bg.alpha = self.border_bg.alpha + 0.01 * DTMULT
        end
        if self.state_timer >= 20/30 and self.state_progress == 0 then
            Assets.playSound("minigames/punch_out/boxing_round1_bc")
            self.round_text = Sprite("minigames/punch_out/round_1", 256, 114)
            self.round_text:setScale(2)
            self.round_text.layer = self.bg.layer + 10
            self:addChild(self.round_text)
            self.state_progress = 1
        end
        if self.state_timer >= 50/30 and self.state_progress == 1 then
            self.round_text:remove()
            self:removeChild(self.round_text)
            self.state_progress = 2
        end
        if self.state_timer >= 72/30 and self.state_progress == 2 then
            Assets.playSound("minigames/punch_out/boxing_fight_bc")
            self.fight_text = Sprite("minigames/punch_out/fight", 266, 114)
            self.fight_text:setScale(2)
            self.fight_text.layer = self.bg.layer + 10
            self:addChild(self.fight_text)
            self.state_progress = 3
        end
        if self.state_timer >= 102/30 and self.state_progress == 3 then
            self.fight_text:remove()
            self:removeChild(self.fight_text)
            self.state_progress = 4
        end
        if self.state_timer >= 112/30 then
            self:setState("MAIN")
        end
    elseif self.state == "MAIN" then
        self.round_timer = self.round_timer - DTMULT
        if self.round_timer < 0 then
            self.round_timer = 0
            self:setState("PACIFIST")
        end
    elseif self.state == "PACIFIST" then
        if self.state_timer % (20/30) >= (10/30) then
            self.draw_text.alpha = 0
        else
            self.draw_text.alpha = 1
        end
        if self.state_timer >= 0.8 and (Input.pressed("confirm") or Input.pressed("cancel")) then
            self:setState("MAIN")
            self.boxing_hero.reset_timer = 5
        end
    elseif self.state == "DEAD" then
        if self.state_progress == 0 then
            self.queen_face_scale = self.queen_face_scale + 0.2 * DTMULT
            self.queen_laugh_face:setScale(self.queen_face_scale)
            if self.queen_face_scale >= 5 then
                Assets.playSound("minigames/punch_out/queen_laugh_bc")
                self.queen_laugh_face:setSprite("minigames/punch_out/queen/gianthead_laugh")
                self.queen_laugh_face:play(0.05)
                self.state_timer = 0
                self.state_progress = 1
            end
        end
        if self.state_timer >= 52/30 and self.state_progress == 1 then
            self.queen_laugh_face:remove()
            self.lose_text = Sprite("minigames/punch_out/you_lose", 320, 240)
            self.lose_text.layer = self.bg.layer + 10
            self.lose_text:setOrigin(0.5, 0.5)
            self:addChild(self.lose_text)
            self.state_timer = 0
            self.state_progress = 2
        end
        if self.state_timer >= 60/30 and self.state_progress == 2 then
            self.lose_text:remove()
            self.state_timer = 0
            self.state_progress = 3
        end
        if Input.pressed("right") and self.state_timer > 24/30 and self.state_progress == 3 then
            self.state_progress = 4
        end
        if Input.pressed("left") and self.state_timer > 24/30 and self.state_progress == 4 then
            self.state_progress = 3
        end
        if Input.pressed("confirm") and self.state_timer > 24/30 then
            if self.state_progress == 3 then
                self:setState("MAIN")
                self.boxing_hero.reset_timer = 5
            elseif self.state_progress == 4 then
                self.fade_alpha = 1
                self:setState("TRANSITIONOUT3")
            end
        end
    elseif self.state == "TRANSITIONOUT1" or self.state == "TRANSITIONOUT3" then
        self.fade_alpha = self.fade_alpha - DT
        if self.border_bg.alpha >= 0 then
            self.border_bg.alpha = self.border_bg.alpha - 0.02 * DTMULT
        end
        self.bg:setColor(self.fade_alpha,self.fade_alpha,self.fade_alpha,1)
        if self.state_timer > 1 then
            for k,v in pairs(self.entities) do
                v:remove()
            end
            self.boxing_hero:remove()
            self.boxing_queen:remove()
            self.fade_alpha = 0
            self.border_bg.alpha = 0
            self.bg.alpha = 0
            self:setState("TRANSITIONOUT2")
        end
    elseif self.state == "TRANSITIONOUT2" then
        self.rectbg.width = SCREEN_WIDTH * (1 - self.state_timer)
        self.rectbg.height = SCREEN_HEIGHT * (1 - self.state_timer)
        if self.state_timer > 1 then
            self:endMinigame()
            return
        end
    end
    super.update(self)
end

function PunchOut:drawCharacter(object)
    love.graphics.push()
    local ox = object.x
    local oy = object.y
    if object.janky_pos then -- Apparently Deltarune does this
        object.x = object.x/2
        object.y = object.y/2
    end
    object:preDraw()
    object:draw()
    object:postDraw()
    object.x = ox
    object.y = oy
    love.graphics.pop()
end

function PunchOut:draw()
    super.draw(self)

    local canvas = Draw.pushCanvas(320, 240)
    love.graphics.clear()
    love.graphics.translate(-160, -120)

    for _,ent in ipairs(self.entities) do
        if ent.layer <= Game.minigame.rectbg.layer-3 then
            self:drawCharacter(ent)
        end
    end
    if self.boxing_queen then
        self:drawCharacter(self.boxing_queen)
    end
    for _,ent in ipairs(self.entities) do
        if ent.layer == Game.minigame.rectbg.layer-2 then
            self:drawCharacter(ent)
        end
    end
    if self.boxing_hero then
        love.graphics.setColor(self.boxing_hero.color)
        self:drawCharacter(self.boxing_hero)
        love.graphics.setColor(1,1,1,1)
    end
    for _,ent in ipairs(self.entities) do
        if ent.layer >= Game.minigame.rectbg.layer-1 then
            self:drawCharacter(ent)
        end
    end
    
    Draw.popCanvas()

    Draw.setColor(1, 1, 1, 1)
    Draw.draw(canvas, 160, 120)
    if self.state == "MAIN" or self.state == "PACIFIST" then
        love.graphics.setFont(self.font)
        love.graphics.draw(self.time_text, 280, 91)
        love.graphics.setColor(self.hero_color)
        love.graphics.draw(self.hero_hp_text, 180, 147)
        love.graphics.rectangle("fill", 180, 130, self.hero_hp/5, 10)
        love.graphics.setColor(0,1,0,1)
        love.graphics.draw(self.queen_hp_text, 377, 147)
        love.graphics.rectangle("fill", 460-(self.queen_hp/10), 130, self.queen_hp/10, 10)
        love.graphics.printf(math.ceil(self.round_timer/30), -2, 112, SCREEN_WIDTH, "center")
    end
    if self.state == "DEAD" and self.state_progress >= 3 then
        love.graphics.draw(self.give_up_text, 279, 220)
        if self.state_progress == 3 then
            love.graphics.draw(self.fight_again_sel, 190, 260)
        else
            love.graphics.draw(self.fight_again, 190, 260)
        end
        if self.state_progress == 4 then
            love.graphics.draw(self.retire_sel, 370, 260)
        else
            love.graphics.draw(self.retire, 370, 260)
        end
    end
    if self.boxing_hero then
        if self.draw_arrows_mode == 1 then
            love.graphics.setColor(0,1,0,1)
            love.graphics.draw(self.arrow, self.boxing_hero.base_x/2-64+11, self.boxing_hero.base_y/2-32-17+8, math.rad(180))
            love.graphics.draw(self.arrow, self.boxing_hero.base_x/2+50-11, self.boxing_hero.base_y/2-32-34+8, math.rad(0))
        end
        if self.draw_arrows_mode == 2 then
            if self.state_timer % (11/30) >= (6/30) then
                love.graphics.setColor(0,1,0,1)
                love.graphics.draw(self.arrow, self.boxing_hero.base_x/2-64+11, self.boxing_hero.base_y/2-32+8, math.rad(90))
                love.graphics.draw(self.arrow, self.boxing_hero.base_x/2+50+11, self.boxing_hero.base_y/2-32+8, math.rad(90))
            end
        end
    end
    if self.state ~= "TRANSITIONOUT1" and self.state ~= "TRANSITIONOUT2" and self.state ~= "TRANSITIONOUT3"  then
        love.graphics.setColor(0,0,0,self.fade_alpha)
        love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    end
    love.graphics.setColor(1,1,1,1)
end

function PunchOut:setState(state)
    local last_state = self.state
    self.state = state
    self.state_timer = 0
    self.state_progress = 0
    self:onStateChange(last_state, state)
end

function PunchOut:onStateChange(old, new)
    if old == "MAIN" then
    elseif old == "PACIFIST" then
        self.draw_text:remove()
        self:removeChild(self.draw_text)
    end
    if new == "INTRO" then
        self:changeWindowTitle()
        self.music:play("minigames/punch_out/boxing_game")
        if not self.boxing_hero then
            self.boxing_hero = PunchOutHero()
            self:addChild(self.boxing_hero)
        end
        if not self.boxing_queen then
            self.boxing_queen = PunchOutQueen()
            self:addChild(self.boxing_queen)
        end
    elseif new == "MAIN" then
        self.round_timer = 2970
        self.hero_hp = self.hero_hp_max
        self.queen_hp = self.queen_hp_max
        self:setupAttackA()
        self.boxing_hero.sprite.visible = true
        self.boxing_queen.sprite.visible = true
        self.boxing_hero.can_control = true
        self.boxing_hero:setState("IDLE")
    elseif new == "PACIFIST" then
        self.boxing_hero.can_control = false
        self.draw_text = Sprite("minigames/punch_out/draw", 294, 230)
        self.draw_text.layer = self.bg.layer + 10
        self:addChild(self.draw_text)
    elseif new == "WIN" then
    
    elseif new == "DEAD" then
        self.boxing_hero.can_control = false
        self.boxing_queen.sprite.visible = false
        self.queen_face_scale = 0.01
        self.queen_laugh_face = Sprite("minigames/punch_out/queen/gianthead", 320, 240)
        self.queen_laugh_face:setScale(0.01)
        self.queen_laugh_face:setOrigin(0.5,0.5)
        self.queen_laugh_face.layer = self.bg.layer + 10
        self:addChild(self.queen_laugh_face)
    elseif new == "TRANSITIONOUT1" or new == "TRANSITIONOUT3" then
        self.music:fade(0,1)
    elseif new == "TRANSITIONOUT2" then
        self:preEndCleanup()
    end
end

function PunchOut:makeVectorExplosion(x, y, layer, scale, time)
    Assets.playSound("minigames/punch_out/explosion_8bit")
    local explosion = Sprite("minigames/punch_out/vector_explosion", x, y)
    explosion:play(0.2666)
    explosion:setScale(scale or 1)
    explosion:setOrigin(0.5,0.5)
    explosion.layer = layer or self.layer
    explosion.timer = time or 40
    Utils.hook(explosion, "update", function(orig, self, ...)
        orig(self, ...)
		if self.timer then
			self.timer = self.timer - DTMULT
			if self.timer <= 0 then
				self:remove()
				self.timer = nil
			end
		end
    end)
    self:addChild(explosion)
end

function PunchOut:resetQueen()
    self.attack_count = 1
    self.attack_count_max = 1
    self.atk_type_list = {}
    self.atk_amount_list = {}
    self.atk_variant_list = {}
    self.atk_wait_list = {}
end

function PunchOut:addQueenAttack(type, amount, variant, wait)
    table.insert(self.atk_type_list, type)
    table.insert(self.atk_amount_list, amount)
    table.insert(self.atk_variant_list, variant)
    table.insert(self.atk_wait_list, wait)
    self.attack_count_max = self.attack_count_max + 1
end

function PunchOut:addEntity(entity)
    self:addChild(entity)
    table.insert(self.entities, entity)
    return entity
end

function PunchOut:changeAttack(hp, hp_max)
    return false
end

return PunchOut