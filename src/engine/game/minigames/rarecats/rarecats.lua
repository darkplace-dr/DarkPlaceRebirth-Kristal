---@class RareCats : Minigame
local RareCats, super = Class("Minigame")

function RareCats:init()
    super.init(self)

    self.name = "Rare Cats"

    self.state = "TRANSITION" -- TRANSITION, INTRO, MAIN, WIN, TRANSITIONOUT1, TRANSITIONOUT2, TRANSITIONOUT3

    self.timer = Timer()
    self:addChild(self.timer)

    self.music = Music()

    self.bg = Rectangle(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0)
    self.bg:setOrigin(0.5,0.5)
    self.bg.color = {0,0,0}
    self:addChild(self.bg)

    self.state_timer = 0

    self.score = 0
    self.cats_clicked = 0

    self.font = Assets.getFont("main", 32)
    self.font2 = Assets.getFont("small", 32)
	
    self.hud_x, self.hud_y = 230, 484
	
    self.spawn_cat = false
    self.type = 0
end

function RareCats:postInit()
    self:pauseWorldMusic()
end

function RareCats:update()
    if self.score < 0 then
        self.score = 0
    end
    self.state_timer = self.state_timer + DT
    if self.state == "TRANSITION" then
        self.bg.width = SCREEN_WIDTH * self.state_timer
        self.bg.height = SCREEN_HEIGHT * self.state_timer
        if self.state_timer > 1 then
            self:setState("INTRO")
        end
    elseif self.state == "INTRO" then
        Kristal.showCursor()
		
        self.score = 0
        self.cats_clicked = 0
        self.spawn_cat = false
		
        if self.state_timer < 1 then
            if self.hud_y > 420 then
                self.hud_y = self.hud_y - 4 * DTMULT
            end
        else
            self:setState("MAIN")
        end
    elseif self.state == "MAIN" then
        self.hud_y = 420
        if not self.spawn_cat then
            self:summonCat()
        end
    elseif self.state == "WIN" then
        self.hud_y = 484
        if self.cat then
            self.cat:remove()
        end
    elseif self.state == "TRANSITIONOUT1" then
        if self.state_timer > 1 then
            self:setState("TRANSITIONOUT2")
        end
    elseif self.state == "TRANSITIONOUT3" then
        if self.state_timer > 1 then
            self:setState("INTRO")
        end
    elseif self.state == "TRANSITIONOUT2" then
        self.bg.width = SCREEN_WIDTH * (1 - self.state_timer)
        self.bg.height = SCREEN_HEIGHT * (1 - self.state_timer)
        if self.state_timer > 1 then
            self:endMinigame()
            return
        end
    end
	
    super.update(self)
end

function RareCats:draw()
    super.draw(self)

    love.graphics.setColor(1, 1, 1, self.hud_alpha)
    love.graphics.setFont(self.font2)

    if self.state == "INTRO" or self.state == "MAIN" then
        local score = string.format("%d", self.score)
        local cats_clicked = string.format("%d", self.cats_clicked)

		--text
        love.graphics.setColor(1, 1, 1, self.hud_alpha)
        love.graphics.printf("SCORE: "..score, 160, self.hud_y + 6, SCREEN_WIDTH, "center", 0, 0.5, 0.5)
        love.graphics.printf("CATS CLICKED: "..cats_clicked.."/100", 160, self.hud_y + 28, SCREEN_WIDTH, "center", 0, 0.5, 0.5)
    end
	
    local function pressToContinue()
        if Input.active_gamepad then
            love.graphics.printf("PRESS    TO QUIT", 160, 380, SCREEN_WIDTH, "center", 0, 0.5, 0.5, 0.5)
            love.graphics.draw(Input.getTexture("confirm"), (SCREEN_WIDTH/2) - 16, 378, 0, 1, 1)
            love.graphics.printf("PRESS    TO RETRY", 160, 400, SCREEN_WIDTH, "center", 0, 0.5, 0.5, 0.5)
            love.graphics.draw(Input.getTexture("cancel"), (SCREEN_WIDTH/2) - 20, 398, 0, 1, 1)
        else
            love.graphics.printf("PRESS " .. Input.getText("confirm") .. " TO QUIT", 160, 380, SCREEN_WIDTH, "center", 0, 0.5, 0.5, 0.5)
            love.graphics.printf("PRESS " .. Input.getText("cancel") .. " TO RETRY", 160, 400, SCREEN_WIDTH, "center", 0, 0.5, 0.5, 0.5)
        end
    end
	
    if self.state == "WIN" then
        Draw.setColor(1, 1, 1, self.hud_alpha)
        love.graphics.setFont(self.font)
        love.graphics.printf("CONGRATULATIONS!!!", 0, 70, SCREEN_WIDTH, "center")

        local score = string.format("%d", self.score)
        love.graphics.printf("SCORE: "..score, 0, 220, SCREEN_WIDTH, "center")
	
        love.graphics.setFont(self.font2)
        Draw.setColor(0.5, 0.5, 0.5, self.hud_alpha)
        pressToContinue()
    end
end

function RareCats:onKeyPressed(key)
    super.onKeyPressed(self, key)
    if self.state == "WIN" then
        if Input.pressed("confirm") then --quit
            self:setState("TRANSITIONOUT1")
        end
        if Input.pressed("cancel") then --restart
            self:setState("TRANSITIONOUT3")
        end
    end
end

function RareCats:setState(state)
    local last_state = self.state
    self.state = state
    self.state_timer = 0
    self:onStateChange(last_state, state)
end

function RareCats:onStateChange(old, new)
    if new == "MAIN" then
        self.music:play("deltarune/spamton_dance")
    elseif new == "TRANSITIONOUT1"then
    elseif new == "TRANSITIONOUT2" then
        self:preEndCleanup()
    end
end

function RareCats:summonCat()
    self.spawn_cat = true
    local o = math.floor(love.math.random() * 1000) + 1
	
    if self.cats_clicked >= 100 then
        self:hardReset()
    else
        if o <= 700 then      --normal
            self.type = 0
        elseif o <= 879 then  --blue ora
            self.type = 1
        elseif o <= 959 then  --rock & roll
            self.type = 4
        elseif o <= 989 then  --ANGLE WING!!!!
            self.type = 5
        elseif o <= 999 then  --SUPER HOLY ANGlE WING!!!!
            self.type = 6
        end
    end
	
    self.cat = RareCatsEntity(math.floor(love.math.random(160, 480)), math.floor(love.math.random(160, 320)), self.type)
    self.cat.physics.speed_x = Utils.pick({-30, 30}) / 10
    self.cat.physics.speed_y = Utils.pick({-30, 30}) / 10
    self.cat:setScale(2)
    if self.cats_clicked < 100 then
        self:addChild(self.cat)
    end
end

function RareCats:hardReset()
    self.music:stop()

    Assets.stopSound()
    Assets.playSound("face", 2, 1)

    self.friend = Sprite("IMAGE_FRIEND_W", 320, 240, nil, nil, "minigames/rarecats")
    self.friend.scale = 0.1
    self.friend.layer = 9999
    self.friend:setOriginExact(14, 12)
    self.friend.graphics.grow = 1
    self:addChild(self.friend)	

    self.timer:after(1, function()
        Assets.playSound("won")
        self.friend:remove()
        self:setState("WIN")
	end)
end

return RareCats