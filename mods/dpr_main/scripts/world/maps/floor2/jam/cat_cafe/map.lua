local cat_cafe, super = Class(Map)

function cat_cafe:init(world, data)
	super.init(self, world, data)
end

function cat_cafe:onEnter()
	super.onEnter(self)

	        Game.world.music:play("caramelldansen", 1)

        Game.world.music:seek(Game.world.caramell_constant)
        self.sought = true
        Game.world.map.cpoint = 0
    self.minigame_remain = 0
               Game.world.map.combo = 1

self.text = Text("HI SCORE: ".. Game:getFlag("cat_cafe_hi_score", 0) , 54, 334)
--self.text:setScale(2)
self.text.layer = 1
Game.world:addChild(self.text)

self.tex = Text("POINTS: ".. self.cpoint .."\nTIME: ".. (math.floor(self.minigame_remain)) , 420, 260)
self.tex.layer = Game.world.player.layer
Game.world:addChild(self.tex)

    self.cats = {}
    self.cats[1] = Game.world:getEvent(14)
    self.cats[2] = Game.world:getEvent(15)
    self.cats[3] = Game.world:getEvent(16)
    self.cats[4] = Game.world:getEvent(17)
    self.cats[5] = Game.world:getEvent(18)
    self.cats[6] = Game.world:getEvent(19)

end

function cat_cafe:onExit()
	super.onExit(self)
        if self.sought then
            Game.world.caramell_constant = Game.world.music:tell()
        end
end

function cat_cafe:draw()
	super.draw(self)

    local r, g, b = Utils.hslToRgb(Kristal.getTime() / 4 % 1, 1, 0.5)

    Draw.setColor(r, g, b, 0.2)
    love.graphics.rectangle("fill", 0, 0, 25*40, 20*40)

end


function cat_cafe:update()
	super.update(self)

        if Game.world.map.minigame and not Game.world.menu and not Game.world.cutscene then

            self.minigame_remain = self.minigame_remain - DT
            self.tex:setText("POINTS: ".. (math.floor(self.cpoint)) .."\nTIME: ".. (math.floor(self.minigame_remain)) )

            if math.floor(self.minigame_remain) <= 0 then
                Game.world.map.minigame = nil
                Game.world:startCutscene("cat_cafe.finished")
            end
        end



        if self.sought then
            Game.world.caramell_constant = Game.world.music:tell()
        end

    local r, g, b = Utils.hslToRgb(Kristal.getTime() / 4 % 1, 1, 0.5)

    --Draw.setColor(r, g, b, 0.2)


    Game.world:getEvent(7).spotlight:setTopColor(r, g, b, 0.75)
    Game.world:getEvent(7).spotlight:setBottomColor(r, g, b, 0.1)
    Game.world:getEvent(7).spotlight.lock_source = true
    Game.world:getEvent(7).spotlight:setPosition(Game.world.player.x,Game.world.player.y + 4)


    local spx = math.sin(love.timer.getTime() / 3) * 300

    if spx < 0 then spx = -spx end

    Game.world:getEvent(8).spotlight:setTopColor(r, g, b, 0.75)
    Game.world:getEvent(8).spotlight.lock_source = true
    Game.world:getEvent(8).spotlight:setPosition(420 + spx, 438)
    Game.world:getEvent(8).spotlight:setBottomColor(r, g, b, 0.1)

    Game.world:getEvent(13).spotlight:setTopColor(r, g, b, 0.75)
    Game.world:getEvent(13).spotlight.lock_source = true
    Game.world:getEvent(13).spotlight:setPosition(900 - spx, 438)
    Game.world:getEvent(13).spotlight:setBottomColor(r, g, b, 0.1)

end

return cat_cafe