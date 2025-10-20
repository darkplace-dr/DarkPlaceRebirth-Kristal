---@class Savepoint : Savepoint
local Savepoint, super = Utils.hookScript(Savepoint)

function Savepoint:init(x, y, properties)
    super.init(self,x,y,properties)

    self.override_power = properties and properties["override_power"] or false
end

function Savepoint:update()
    super.update(self)

    --For Hirty Dackers
    if Game.world.player and Game.world.player.actor.noel then
        self:remove()
    end
end

function Savepoint:onInteract(player, dir)
    if Game:getFlag("weird") and (self.text and #self.text > 0) and not self.override_power then
        local party_text = ""
        for i,member in ipairs(Game.party) do
            party_text = party_text .. member.name
            if i < #Game.party-1 then
                party_text = party_text ..",[wait:2] "
            elseif i == #Game.party-1 then
                party_text = party_text .." and "
            end
        end
        local verb = #Game.party == 1 and "is" or "are"
        if Game:hasPartyMember("jamm") and Game:getPartyMember("jamm").name == "J+M" then
            verb = "are"
        end
        self.text = {"* " .. party_text .. " "..verb.." filled with power."}
    end

    super.onInteract(self, player, dir)
end

return Savepoint