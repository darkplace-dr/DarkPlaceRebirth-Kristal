local hub, super = Class(Map)

function hub:init(world, data)
    super.init(self, world, data)
end

function hub:load()
    super.load(self)
	local xx, yy = self:getMarker("clock")
	self.world:spawnObject(WarpHubClock(xx, yy), "objects")
end

function hub:diamond_hole() -- this should be an event... but i really dont feel like making one right now
    local p = Game.world.player
    if p and p.x > 120 and p.x < 240 and p.y < 200 and p.y > 120 then
        local diamond = Game.world:getCharacter("diamond_giant")
        local option = diamond.sprite.sprite_options
        if option[2] == "hole_empty" then
            diamond:setAnimation("rise")
        end
    else
        local diamond = Game.world:getCharacter("diamond_giant")
        local option = diamond.sprite.sprite_options
        if option[1] == "hole_idle" then

            diamond:setAnimation("fall")
        end
    end
end

function hub:update()
    super.update(self)

    self:diamond_hole()
end

function hub:onFootstep(char, num)
    local brenda = Game.world:getCharacter("brenda")
    if (brenda and Game:getPartyMember("brenda").love >= 5)
        and (love.math.random(1, 1000) == 55 and not Game:getFlag("thoughts"))
    then
        Game.world:startCutscene("thoughts", "b")
    end
end

return hub