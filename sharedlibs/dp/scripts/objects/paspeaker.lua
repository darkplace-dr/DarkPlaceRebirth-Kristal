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
    self.yoff = 10
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
end

function PASpeaker:update()
    if (self.play == 1) then
        self.play = 0;
        -- self.scale_x = 2;
        self.sprite_index = Assets.getFramesOrTexture "paspeaker/tenna_on";
        self.image_speed = 0;
        self.maxfunny = 12;
        self.image_index = self.image_index+1;
        -- scr_lerpvar("add1", add1, Utils.random(-self.maxfunny, self.maxfunny), rate - 1, 1, "out");
        -- scr_lerpvar("add2", add2, Utils.random(-self.maxfunny, self.maxfunny), rate - 1, 1, "out");
        -- scr_lerpvar("add3", add3, Utils.random(-self.maxfunny, self.maxfunny), rate - 1, 1, "out");
        -- scr_lerpvar("add4", add4, Utils.random(-self.maxfunny, self.maxfunny), rate - 1, 1, "out");
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
        self.timer = self.timer+1;
        
        if (self.timer == 1) then
            self.ypos = -20;
            self.y = self.ypos;
            self.tween_timer:tween(15/30, self, {ypos = 80}, "in-elastic");
        end

        if (self.timer == 20) then
            self.baralpha = 0
            self.tween_timer:tween(15/30, self, {baralpha = 1}, "linear");
            self.schmactive = true;
        end

        if (self.timer > 20 and not self.schmactive) then
            self.con = 1;
            self.timer = 0;
        end
    end

    if (self.con == 1) then
        self.timer = self.timer+1;
        
        if (self.timer == 1) then
            self.tween_timer:tween(15/30, self, {ypos = -120}, "linear");
        end
    end
    super.update(self)
end

function PASpeaker:drawTexturePos(tex, x1, y1, x2, y2, x3, y3, x4, y4)
    self.mesh:setVertices({
        {x4,y4,1,0},
        {x1,y1,0,0},
        {x2,y2,0,1},
        {x3,y3,1,1},
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
    love.graphics.translate(580, self.ypos+15)
    love.graphics.setColor(0,0,0, 0.3 * self.baralpha)
    love.graphics.rectangle("fill",    0,      0 - 10 - 4 - 4, -640, 40)
    love.graphics.setColor(0,0,0, 0.6 * self.baralpha)
    love.graphics.rectangle("fill",    0,      0 - 10 - 2 - 4, -640, 36)
    love.graphics.setColor(0,0,0, 1 * self.baralpha)
    love.graphics.rectangle("fill",    0,      0 - 10 - 4, -640, 32)
    love.graphics.pop()


    self.siner = self.siner+1;
    self.strtimer = self.strtimer+1;

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
            self.endtimer = self.endtimer+1;
            
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
                    -- scr_delay_var("schmactive", 0, 15);
                    -- scr_lerpvar("botpinch", botpinch, 0, 14, -2, "out");
                    -- TODO: Use tween type -2 (why is it negative wtf)
                    self.tween_timer:tween(14/30, self, {add1=0,add2=0,add3=0,add4=0}, "linear")

                    self.tween_timer:tween(14/30, self, {baralpha=0}, "linear")
                    -- scr_delay_var("charindex", 0, 16);
                    -- scr_delay_var("charindex", 0, 16);
                    -- scr_delay_var("textx", 8, 16);
                    self.sprite_index = self.off_sprite;
                    -- scr_delay_var("strtimer", 0, 16);
                end
            end
        end
    end

    self.textx = self.textx + (self.hspace / self.rate);
    Draw.setColor(COLORS.yellow);
    love.graphics.setFont(Assets.getFont("main"));
    local smallamt = 6;
    local wobbleamount = 2;
    Draw.setColor(COLORS.yellow, baralpha);
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

    Draw.setColor(COLORS.white);
--
end

return PASpeaker
