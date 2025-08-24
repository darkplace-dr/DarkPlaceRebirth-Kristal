---@class RareCatsEntity : Object
local RareCatsEntity, super = Class(Object)

function RareCatsEntity:init(x, y, type)
    super.init(self, x, y, 41, 40)

    self.width = 41
    self.height = 40
    self.collider = Hitbox(self, 0, 0, self.width, self.height)
    self:setScale(1)

    self.type = type or 0

    self.cat_alpha = 1
    self.point_value = 0
    self.kill_cat = false
    self.cat_fade = false
    self.played_sound = false

    self.timer = Timer()
    self:addChild(self.timer)

    self.minigame = Game.minigame
end

function RareCatsEntity:update()
    super.update(self)
	
	--bouncing across screen
    if self.x >= SCREEN_WIDTH - (self.width * self.scale_x) and not self:clicked() then
        self.physics.speed_x = -30 / 10
    elseif self.x <= 0 and not self:clicked() then
        self.physics.speed_x = 30 / 10
    end
	
    if self.y <= 0 and not self:clicked() then
        self.physics.speed_y = 30 / 10
    elseif self.y >= SCREEN_HEIGHT - (self.height * self.scale_y) and not self:clicked() then
        self.physics.speed_y = -30 / 10
    end
	
	--clicking stuff
    local mx, my = Input.getMousePosition()
    if (Input.mousePressed() and not clicked) and self.minigame.cats_clicked < 100 then
        if self:clicked() and not self.kill_cat then
            self.minigame.cats_clicked = self.minigame.cats_clicked + 1
			
            self.physics.speed_x = 0
            self.physics.speed_y = 0
			
            self.kill_cat = true
			
            if not self.played_sound then
                Assets.playSound("wing")
			
                if self.type == 0 then
                    Assets.playSound("meow", nil, 2)
                    Assets.playSound("magicsprinkle", 0.8)
                    self.point_value = 10
                end
                if self.type == 1 then
                    Assets.playSound("meow", nil, 1.86)
                    Assets.playSound("magicsprinkle", 0.9, 0.95)
                    self.point_value = 50
                end
                if self.type == 2 then
                    Assets.playSound("meow", nil, 1.58)
                    Assets.playSound("magicsprinkle", 1, 0.9)
                    self.point_value = 100
                end
                if self.type == 3 then
                    Assets.playSound("meow", nil, 1)
                    Assets.playSound("magicsprinkle", 1, 0.8)
                    self.point_value = 250
                end
                if self.type == 4 then
                    Assets.playSound("meow_angry", nil, 1)
                    Assets.playSound("cd_bagel/susie", 0.8, 1.3 + Utils.random(0.1))
                    self.point_value = 500
                end
                if self.type == 5 then
                    Assets.playSound("meow_angry", nil, 0.86)
                    Assets.playSound("magicsprinkle", 1, 0.5)
                    Assets.playSound("cd_bagel/ralsei_stereo", 1, 1)
                    self.point_value = 1500
                end
                if self.type == 6 then
                    Assets.playSound("meow_angry", nil, 0.72)
                    Assets.playSound("magicsprinkle", 1, 0.25)
                    Assets.playSound("cd_bagel/ralsei_stereo", 1, 0.8)
                    Assets.playSound("cd_bagel/ralsei_stereo", 1, 0.81)
                    self.point_value = 5000
                end
                if self.type == 7 then
                    Assets.playSound("meow_angry", nil, 0.5)
                    Assets.playSound("magicsprinkle", 1, 0.1)
                    Assets.playSound("cd_bagel/ralsei_stereo", 1, 0.6)
                    Assets.playSound("cd_bagel/ralsei_stereo", 1, 0.62)
                    self.point_value = 10000
                end

                self.played_sound = true
            end
			
            self.minigame.score = self.minigame.score + self.point_value
			
            self.points_txt = Text("+"..self.point_value, self.width/2 - 12, 0)
            self.points_txt:setScale(0.5)
            self.points_txt.alpha = 0
            self:addChild(self.points_txt)
			
            if self.y < 160 then
                self.points_txt.y = self.height
                self.timer:tween(0.4, self.points_txt, {y = self.points_txt.y + 10, alpha = 1})
                self.timer:after(0.8, function()
                    self.cat_fade = true
                    self.timer:tween(0.4, self.points_txt, {y = self.points_txt.y + 40, alpha = 0})
                end)
            else
                self.points_txt.y = -12
                self.timer:tween(0.4, self.points_txt, {y = self.points_txt.y - 10, alpha = 1})
                self.timer:after(0.8, function()
                    self.cat_fade = true
                    self.timer:tween(0.4, self.points_txt, {y = self.points_txt.y - 40, alpha = 0})
                end)
            end
        end
    end
	
    if self.kill_cat then
        if self.cat_fade then
            self.cat_alpha = self.cat_alpha - 0.1 * DTMULT
        end
        if self.cat_alpha <= 0 then
            self:remove()
            self.points_txt:remove()
            self.minigame.spawn_cat = false
            self.kill_cat = false
        end
    end
end

local function draw_sprite_ext(tex, x, y, sx, sy, angle, color, alpha)
    local r,g,b,a = love.graphics.getColor()
    if color then
        Draw.setColor(color, alpha)
    end
    Draw.draw(tex, x, y, angle, sx, sy)
    love.graphics.setColor(r,g,b,a)
end

local function scr_dso(tex, x, y, sx, sy, angle, color, alpha, offset) -- used for the glowing outline on the cat
    draw_sprite_ext(tex, x - offset, y, sx, sy, angle, color, alpha)
    draw_sprite_ext(tex, x + offset, y, sx, sy, angle, color, alpha)
    draw_sprite_ext(tex, x, y - offset, sx, sy, angle, color, alpha)
    draw_sprite_ext(tex, x, y + offset, sx, sy, angle, color, alpha)
    draw_sprite_ext(tex, x - offset, y - offset, sx, sy, angle, color, alpha)
    draw_sprite_ext(tex, x + offset, y - offset, sx, sy, angle, color, alpha)
    draw_sprite_ext(tex, x - offset, y + offset, sx, sy, angle, color, alpha)
    draw_sprite_ext(tex, x + offset, y + offset, sx, sy, angle, color, alpha)
end

function RareCatsEntity:draw()
    local current_time = RUNTIME * 1500

    local function fcolor(h, s, v)
        self.hue = (h / 255) % 1
        return Utils.hsvToRgb((h / 255) % 1, s / 255, v / 255)
    end
    local _f = Utils.clamp(0.5 + (math.sin(current_time / 200) * 0.5), 0, 1)
    local _rainbow = {fcolor(math.sin(current_time / 500) * 255, 255, 255)}
    local drawcat = true
	
    local cat = Assets.getFrames("minigames/rarecats/cat_dance")
    local aura = Assets.getFrames("minigames/rarecats/cat_aura")
    local wings = Assets.getFrames("minigames/rarecats/cat_wings")
    local cat_frames = (math.floor(current_time / 100) % #cat) + 1
    local aura_frames = (math.floor(current_time / 100) % #aura) + 1
    local wings_frames = (math.floor(current_time / 100) % #wings) + 1

    if self.type == 1 then
        scr_dso(cat[cat_frames], 0, 0, 1, 1, 0, Utils.mergeColor(COLORS.blue, COLORS.black, _f), 1 * self.cat_alpha, 2)
    end
    if self.type == 2 then
        scr_dso(cat[cat_frames], 0, 0, 1, 1, 0, Utils.mergeColor(COLORS.yellow, COLORS.black, _f), 1 * self.cat_alpha, 2)
    end
    if self.type == 3 then
        scr_dso(cat[cat_frames], 0, 0, 1, 1, 0, _rainbow, 1 * self.cat_alpha, 2)
    end
    if self.type == 4 then
        draw_sprite_ext(aura[aura_frames], -10, -14, 1, 1, 0, _rainbow, 0.5 * self.cat_alpha)
        scr_dso(cat[cat_frames], 0, 0, 1, 1, 0, _rainbow, 1 * self.cat_alpha, 2)
    end
    if self.type == 5 then -- unfinished, needs the afterimage effect
        draw_sprite_ext(wings[wings_frames], -9, -8, 1, 1, 0, Utils.mergeColor(COLORS.lime, COLORS.white, _f), 0.5 * self.cat_alpha)
    end
    if self.type == 6 then -- unfinished, needs the afterimage effect
        love.graphics.setColor(1, 1, 1, 0.2 * self.cat_alpha)
        Draw.rectangle("fill", -40, -500, 80 + (math.sin(current_time / 200) * 10), 1000 + math.sin(current_time / 200))
        draw_sprite_ext(wings[wings_frames], -9, -8, 1, 1, 0, COLORS.white, 1 * self.cat_alpha)
    end
    if self.type == 7 then -- unfinished, needs the afterimage effect
        love.graphics.setColor(1, 0.625, 0.25, 0.2 * self.cat_alpha)
        Draw.rectangle("fill", -60, -500, 120 + (math.sin(current_time / 200) * 10), 1000 + math.sin(current_time / 200))
        draw_sprite_ext(wings[wings_frames], -9, -8, 1, 1, 0, COLORS.white, 1 * self.cat_alpha)
    end
	
    if drawcat then
        draw_sprite_ext(cat[cat_frames], 0, 0, 1, 1, 0, COLORS.lime, 1 * self.cat_alpha)
    end

    super.draw(self)
end

return RareCatsEntity