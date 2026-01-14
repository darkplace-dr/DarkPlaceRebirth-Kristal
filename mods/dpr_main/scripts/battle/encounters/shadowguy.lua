local Shadowguy, super = Class(Encounter)

function Shadowguy:init()
    super.init(self)

    self.text = "* Shadowguys play on in."

    self.music = "deltarune/rudebuster_boss"
    self.background = true

    self.shadows = {
        self:addEnemy("shadowguy", 476 + 58, 70 + 59*2),
        self:addEnemy("shadowguy", 454 + 58, 168 + 59*2)
    }

	for _,enemy in ipairs(self.shadows) do
		enemy.shoot_target = "SOCKS"
	end
	self.flee = false
end

function Shadowguy:onReturnToWorld(events)
    Game:setFlag("shadowmen_violence", Game.battle.used_violence)
    if self.shadows[1].done_state == "FROZEN" and self.shadows[2].done_state == "FROZEN" then
        Game:setFlag("shadowmen_special_end", "FROZEN")
        for i,event in ipairs(events) do
            local statue = FrozenEnemy(event.actor, event.x, event.y, {encounter = self})
            statue.sprite.frozen = true
            statue.sprite.freeze_progress = 1
            statue.layer = event.layer
            Game.world:addChild(statue)
            event:remove()
            event.sprite:remove()
        end
    elseif self.shadows[1].done_state == "KILLED" and self.shadows[2].done_state == "KILLED" then
        Game:setFlag("shadowmen_special_end", "KILLED")
        for i,event in ipairs(events) do
            event:remove()
            event.sprite:remove()
        end
    end
end

return Shadowguy
