local Voidspawn, super = Class(Encounter)

function Voidspawn:init()
    super.init(self)

    self.text = "* Voidspawn ambushes you.\n* [color:yellow]TP[color:reset] Gain reduced outside of [color:yellow]???[color:reset]"

    self.music = "titan_spawn"
    self.background = true

    self.reduced_tension = true
    self.light_radius = 48

    self:addEnemy("voidspawn")
    self.flee = false
end

function Voidspawn:onTurnEnd()
    super.onTurnEnd(self)
	self.light_radius = 48
end

function Voidspawn:onBattleEnd()
    super.onBattleEnd(self)

    if not Game:getFlag("topfloor_ambush") then
        Game:setFlag("topfloor_ambush", true)
        Game.world:getCharacter("voidspawn"):remove()

        for _, member in ipairs(Game.party) do
            Game.world:getCharacter(member.id):setAnimation("battle/idle")
        end
    end
end

return Voidspawn