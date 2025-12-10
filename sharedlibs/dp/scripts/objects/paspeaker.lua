---@class PASpeaker: Object
---@field sounds love.Source[]
local PASpeaker, super = Class(Object, "PASpeaker")

---@param text string
---@param voice string
function PASpeaker:init(text, voice)
    super.init(self, 0, 0)
    voice = voice or "voice/tenna/tv_voice_short"
    self:setScale(1)
    self:setParallax(0)
    self.sounds = {}
    local i = 0
    while true do
        i = i + 1
        local snd_path = voice .. "_" .. i
        local sound = Assets.getSound(snd_path)
        if not sound then break end
        table.insert(self.sounds, sound:clone())
    end
    self.mystring = text or "ATTENTION EVERYONE!! ATTENTION EVERYONE!!"
    self.mystring = self.mystring .. "        "

    self.charindex = 0
    self.strtimer = 0
    self.rate = 3
    self.hspace = 10
    self.strlength = Utils.len(self.mystring)
    self.textx = 8
    self.siner = 0
    self.play = 0
    self.minchar = 1
    self.yoff = -4
    self.baralpha = 0
    self.open = false
    self.endtimer = 0
    self.endevent = 0
    self.prevsound = -1
    self.con = 0;
    self.timer = 0;
    self.tween_timer = self:addChild(Timer())
    self.ypos = 0;

    self.xoffset = 580
    local major, minor = love.getVersion()
    local vertexformat = {
        {"VertexPosition", "float", 2},
        {"VertexTexCoord", "float", 2},
    }
    if major >= 12 then
        vertexformat = {
            {location=0, format="floatvec2"},
            {location=1, format="floatvec2"},
            {location=2, format="unorm8vec4"}
        }
    end
    self.mesh = love.graphics.newMesh(vertexformat, {
        {0,0,0,0},
        {0,1,0,1},
        {1,1,1,1},
        {1,0,1,0},
    }, "fan")
    self.off_sprite = Assets.getFramesOrTexture "paspeaker/tenna_off";
    self.on_sprite = Assets.getFramesOrTexture "paspeaker/tenna_on";
    self.sprite_index = self.off_sprite;
    self.image_index = 0
    self.snd_vol = 1
    self.snd_count = 40
    self.add1 = 0.0;
    self.add2 = 0.0;
    self.add3 = 0.0;
    self.add4 = 0.0;
	self.drawtype = 0 
	self.do_once = 0
end

function PASpeaker:update()
    if (self.play == 1) then
        self.play = 0;
        self.sprite_index = Assets.getFramesOrTexture "paspeaker/tenna_on";
        self.image_speed = 0;
        self.maxfunny = 12;
        self.image_index = self.image_index+1;
        self.tween_timer:lerpVar(self, "add1", self.add1, MathUtils.random(-self.maxfunny, self.maxfunny), self.rate - 1, 1, "out");
        self.tween_timer:lerpVar(self, "add2", self.add2, MathUtils.random(-self.maxfunny, self.maxfunny), self.rate - 1, 1, "out");
        self.tween_timer:lerpVar(self, "add3", self.add3, MathUtils.random(-self.maxfunny, self.maxfunny), self.rate - 1, 1, "out");
        self.tween_timer:lerpVar(self, "add4", self.add4, MathUtils.random(-self.maxfunny, self.maxfunny), self.rate - 1, 1, "out");
        self.botpinch = Utils.random(10, 0);
        local soundid = math.random(1, #self.sounds);
        
        if (soundid == self.prevsound) then
            soundid = soundid + 1;
            
            if (soundid > #self.sounds) then
                soundid = 1;
            end
        end
        
        if (self.snd_vol > 0) then
            self.snd_count = self.snd_count - 1;
            
            if (self.snd_count <= 0) then
                self.snd_vol = self.snd_vol - 0.1;
            end
            self.sounds[soundid]:setPitch(Utils.random(1.1, 1.4))
            self.sounds[soundid]:setVolume(self.snd_vol)
            self.sounds[soundid]:play()
        end
        
        self.prevsound = soundid;
        self.drawtype = 0;
    end

    if (self.con == 0) then
        self.timer = self.timer + DTMULT
        
        if (self.timer >= 1 and self.do_once == 0) then
            self.ypos = -20;
			self.tween_timer:lerpVar(self, "ypos", self.ypos, 80, 15, -1, "out")
			self.do_once = 1
        end

        if (self.timer >= 20 and self.do_once == 1) then
            self.baralpha = 0
            self.tween_timer:tween(15/30, self, {baralpha = 1}, "linear");
            self.schmactive = true;
			self.do_once = 2
        end

        if (self.timer > 20 and not self.schmactive) then
            self.con = 1;
            self.timer = 0;
			self.do_once = 0
        end
    end

    if (self.con == 1) then
        self.timer = self.timer + DTMULT
        
        if (self.timer >= 1 and self.do_once == 0) then
			self.tween_timer:lerpVar(self, "ypos", self.ypos, -120, 30, 2, "out")
			self.do_once = 1
        end
        if (self.timer >= 31) then
			self:remove()
		end
    end
    super.update(self)
end

function PASpeaker:drawTexturePos(tex, x1, y1, x2, y2, x3, y3, x4, y4)
    self.mesh:setVertices({
        {x1,y1,1,0},
        {x2,y2,0,0},
        {x3,y3,0,1},
        {x4,y4,1,1},
    })
    self.mesh:setTexture(tex)
    Draw.draw(self.mesh)
    if DEBUG_RENDER then
        love.graphics.polygon("line", x1,y1,x2,y2,x3,y3,x4,y4)
    end
end

function PASpeaker:draw()
--
    love.graphics.push("all")
    love.graphics.translate(580, self.ypos)
    love.graphics.setColor(0,0,0, 0.3 * self.baralpha)
    love.graphics.rectangle("fill",    0,      0 - 10 - 4 - 4, -640, 40)
    love.graphics.setColor(0,0,0, 0.6 * self.baralpha)
    love.graphics.rectangle("fill",    0,      0 - 10 - 2 - 4, -640, 36)
    love.graphics.setColor(0,0,0, 1 * self.baralpha)
    love.graphics.rectangle("fill",    0,      0 - 10 - 4, -640, 32)
    love.graphics.pop()


    self.siner = self.siner + DTMULT;
    self.strtimer = self.strtimer + DTMULT;

    if self.schmactive and (self.strtimer >= self.rate) then
        if (self.charindex < (self.strlength - 1)) then
            self.charindex = self.charindex+1;
            local thisletter = Utils.sub(self.mystring, self.charindex, self.charindex);
            
            if (thisletter ~= " " and thisletter ~= "." and thisletter ~= "!" and thisletter ~= "&" and thisletter ~= "\"") then
                self.play = 1;
            else
                self.image_index = 0;
            end
            
            self.strtimer = 0;
            
            if (self.charindex > 100) then
                self.minchar = self.minchar+1;
            end
            
            self.endtimer = 0;
            self.endevent = 0;
        else
            self.endtimer = self.endtimer + DTMULT;
            
            if (self.endtimer >= 10 and self.endtimer < 120) then
                local __amt = (self.endtimer * 3) / 100;
                self.add1 = self.add1 + Utils.random(-__amt, __amt);
                self.add2 = self.add2 + Utils.random(-__amt, __amt);
                self.add3 = self.add3 + Utils.random(-__amt, __amt);
                self.add4 = self.add4 + Utils.random(-__amt, __amt);
            end
            
            if (self.endtimer >= 120) then
                if (self.endevent == 0) then
                    self.endevent = 1;
                    self.tween_timer.timer:after(15/30, function()
						self.schmactive = false
					end)
                    self.tween_timer:lerpVar(self, "botpinch", self.botpinch, 0, 14, -2, "out");
                    self.tween_timer:lerpVar(self, "add1", self.add1, 0, 14, -2, "out");
                    self.tween_timer:lerpVar(self, "add2", self.add2, 0, 14, -2, "out");
                    self.tween_timer:lerpVar(self, "add3", self.add3, 0, 14, -2, "out");
                    self.tween_timer:lerpVar(self, "add4", self.add4, 0, 14, -2, "out");
                    self.tween_timer:tween(14/30, self, {baralpha=0}, "linear")
                    self.tween_timer.timer:after(16/30, function()
						self.charindex = 0
						self.textx = 8
						self.strtimer = 0
					end)
                    self.sprite_index = self.off_sprite;
                end
            end
        end
    end

    self.textx = self.textx + (self.hspace / self.rate) * DTMULT;
    love.graphics.setFont(Assets.getFont("main"));
    local smallamt = 6;
    local wobbleamount = 2;
    Draw.setColor(1,1,0,self.baralpha);
    local n = smallamt;
    local i = math.max(self.charindex - smallamt, self.minchar);
    love.graphics.setFont(Assets.getFont("main"));
    love.graphics.push("all")
    love.graphics.translate(self.xoffset + 40, self.ypos)
    while (i < self.charindex) do
        love.graphics.print(Utils.sub(self.mystring, i, i), (-self.textx) + (i * self.hspace), (math.sin((self.siner + i) / 8) * wobbleamount) + self.yoff, 0, (n / smallamt)/2, (n / smallamt)/2)
        n = n - 1;
        i = i+1;
    end

    if (self.charindex >= (smallamt + 1)) then
        for i = self.minchar,(self.charindex - smallamt) do
            -- draw_text((x - self.textx) + (i * self.hspace), self.y + (math.sin((self.siner + i) / 8) * wobbleamount) + self.yoff, string_char_at(self.mystring, i));
            love.graphics.print(Utils.sub(self.mystring, i, i), (- self.textx) + (i * self.hspace), (math.sin((self.siner + i) / 8) * wobbleamount) + self.yoff, 0, 0.5, 0.5)
        end
    end
    love.graphics.pop()

	local width = 80
	local xoff = 20
	local yoff = 25
	local x1 = 580-xoff*2
	local y1 = self.ypos-yoff*2
	local x2 = 580-xoff*2 + width
	local y2 = self.ypos-yoff*2
	local x3 = 580-xoff*2 + width
	local y3 = self.ypos-yoff*2 + width
	local x4 = 580-xoff*2
	local y4 = self.ypos-yoff*2 + width
	local sprite
	if #self.sprite_index then
		sprite = self.sprite_index[(math.floor(self.image_index or 0) % #self.sprite_index) + 1]
	else
		sprite = self.sprite_index
	end
    Draw.setColor(COLORS.white);
	if self.drawtype == 0 then
		x1 = x1 + self.add1
		y1 = y1 + self.add2
		x2 = x2 + self.add3
		y2 = y2 + self.add4
		self:drawTexturePos(sprite, x1, y1, x2, y2, x3, y3, x4, y4)
	end
	if self.drawtype == 1 then
		Draw.draw(sprite, 580, self.ypos, 0, 2, 2, xoff, yoff)
	end
--
end

return PASpeaker
