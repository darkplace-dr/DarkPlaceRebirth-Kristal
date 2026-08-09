local TripleMizzle, super = Class(Encounter)

function TripleMizzle:init()
    super.init(self)

    self.text = "* Placeholder."

    self.music = "ch4_battle"
    self.background = true

    self.mizzle_1 = self:addEnemy("mizzle", 548, 130)
    self.mizzle_2 = self:addEnemy("mizzle", 526, 210)
    self.mizzle_3 = self:addEnemy("mizzle", 550, 300)
end

function TripleMizzle:getPartyPosition(index)
    local krloc = {94, 50}
    local suloc = {80, 122}
    local raloc = {72, 200}

    if #Game.party == 1 then
        krloc = {80, 122}
    elseif #Game.party == 2 then
        krloc = {94, 86}
        suloc = {80, 166}
    end

    if index == 1 then
        return krloc[1]+(19 + 4), krloc[2]+(38 + 38)
    elseif index == 2 then
        return suloc[1]+(25 + 6), suloc[2]+(43 + 45)
    elseif index == 3 then
        return raloc[1]+(21 + 4), raloc[2]+(40 + 52)
    else
        return super.getPartyPosition(self, index)
    end
end

return TripleMizzle