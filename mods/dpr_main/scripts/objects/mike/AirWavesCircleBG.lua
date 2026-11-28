local AirWavesCircleBG, super = Class(Object)

function AirWavesCircleBG:init()
    super.init(self)

    self:setSize(640, 480)

    self.fus = ColorUtils.mergeColor(COLORS.black, COLORS.fuchsia, 0.1)
    self.surf = nil
    self.surf2 = nil
    self.timer = 0
    self.siner = 0
    self.count = 0
    self.circarray = {}
    self.rate = 1
end

function AirWavesCircleBG:makeCircle()
    self.count = self.count + 1

    local thiscirc = Sprite("effects/circle_256_aa", 0, 0)
    thiscirc:setScale(0)
    thiscirc:setOriginExact(128, 128)
    thiscirc:setLayer(1000)
    thiscirc.index = self.count
    thiscirc.iscircle = true

    if (thiscirc.index % 2) == 0 then
        thiscirc:setColor(0, 0, 0, 0)
    else
        thiscirc:setColor(self.fus[1], self.fus[2], self.fus[3], 0)
    end
    thiscirc.siner = 0
    thiscirc.fakealpha = 1
    thiscirc.timer = 0
    thiscirc.debug_select = false
    Game.battle:addChild(thiscirc)
    table.insert(self.circarray, thiscirc)
end

function AirWavesCircleBG:drawSelf()
    super.drawSelf(self)

    local h = (math.sin(self.siner / 300) * 127) + 127
    local rainbow = { ColorUtils.HSVToRGB((h/255) % 1, 1, 1) }
    self.fus = ColorUtils.mergeColor(COLORS.black, rainbow, 0.1)

    local surfwid, surfhei = 160, 120
    if self.surf == nil then
        self.surf = love.graphics.newCanvas(surfwid, surfhei)
    end

    local old_t = self.timer
    self.timer = self.timer + DTMULT
    self.siner = self.siner + self.rate * DTMULT

    if Kristal.isDevMode() and not OVERLAY_OPEN then
        if Input.down("up") then
            self.rate = self.rate + 0.01 * DTMULT
        end
        if Input.down("down") then
            self.rate = self.rate - 0.01 * DTMULT
        end
    end

    self.rate = MathUtils.clamp(self.rate, 0.1, 5)
 
    local old_modu = old_t % math.ceil(60 / self.rate)
    local modu = self.timer % math.ceil(60 / self.rate)
    if (modu < old_modu) then
        self:makeCircle()
    end

    local canvas = Draw.pushCanvas(self.surf)
    love.graphics.clear(0, 0, 0, 1)

    for i = 1, #self.circarray do
        self.circarray[i].scale_x = self.circarray[i].scale_x + (0.002 * self.rate) * DTMULT
        self.circarray[i].scale_y = self.circarray[i].scale_y + (0.0025 * self.rate) * DTMULT

        if self.circarray[i].scale_x > 1 then
            self.circarray[i].fakealpha = self.circarray[i].fakealpha - 0.02 * DTMULT
        end
        
        Draw.setColor(self.circarray[i].color[1], self.circarray[i].color[2], self.circarray[i].color[3], self.circarray[i].fakealpha)
        Draw.draw(Assets.getTexture(self.circarray[i].texture_path), surfwid / 2, surfhei / 2, self.circarray[i].rotation, self.circarray[i].scale_x, self.circarray[i].scale_y, 128, 128)
        Draw.setColor(1, 1, 1, 1)
    end

    Draw.popCanvas(true)

    local ang = 0
    local yoff = (math.sin(self.siner / 30) * (self.rate - 1)) + (self.rate - 1)

    Draw.setColor(1, 1, 1, 1)
    Draw.drawCanvas(self.surf, 320, 0 - ((yoff * surfhei) / 2), -math.rad(ang), 4, 4 + yoff)
    Draw.drawCanvas(self.surf, 320, 0 - ((yoff * surfhei) / 2), -math.rad(ang), -4, 4 + yoff)

    -- not sure how exactly to port this part over

    -- for _, circ in ipairs(Game.stage:getObjects(Sprite)) do
    --     if circ.iscircle then
    --         if circ.fakealpha <= 0 then

    --             local me = id
    --             local ind = -1

    --             for i = 1, #self.circarray do
    --                 if circarray[i] == me then
    --                     with (circarray[i])
    --                         instance_destroy()
                        
    --                     circarray[i] = -4
    --                     break
    --                 end
    --             end
                
    --             if ind ~= -1 then
    --                 array_delete(circarray, ind, 1)
    --             end

    --         end
    --     end
    -- end

    if DEBUG_RENDER then
        Draw.setColor(rainbow[1], rainbow[2], rainbow[3], 1)
        love.graphics.setFont(Assets.getFont("main"))
		
        local dbg = string.format("timer=%d\ncount=%d\nrate=%.2f",
            self.timer,
            self.count,
            self.rate
        )
        love.graphics.printfOutline(dbg, 0, 40, 2, SCREEN_WIDTH*2, "right", 0, 0.5, 0.5)
    end
end

function AirWavesCircleBG:onRemoveFromStage(stage)
    super.onRemove(self, stage)

    if self.surf then
        self.surf:release()
        self.surf = nil
    end

    if self.surf2 then
        self.surf2:release()
        self.surf2 = nil
    end

    for _, circ in ipairs(Game.stage:getObjects(Sprite)) do
        if circ.iscircle then
            circ:remove()
        end
    end
end

return AirWavesCircleBG