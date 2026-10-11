local Holywatercooler, super = Class(Encounter)

function Holywatercooler:init()
    super.init(self)

    self.text = "* This is not your typical watercooler!"

    self.music = "ch4_battle"
    self.background = true

    self.holywatercooler = self:addEnemy("holywatercooler", 484 + 27, 138 + 43 * 2)
end

function Holywatercooler:getDialogueCutscene()
    local miss_mizzle = self.holywatercooler
    if not miss_mizzle.amimissmizzle and (miss_mizzle.mercy >= 60 or (miss_mizzle.gothurtlastturn and miss_mizzle.violenceturn == 3)) then
        return function(cutscene)
            if miss_mizzle.gothurtlastturn and miss_mizzle.violenceturn == 3 then
                miss_mizzle.violenceturn = 4
                cutscene:battlerText(miss_mizzle, {
                    "What have you done?\nYou have broken my\nchamber!",
                    "Now I will seem as\nall the others...",
                    "Oh, young soldiers,\nhow cruel you are,\nthat in your quest\nto make me yours,",
                    "You would reduce\nme to this terrible\nstate...",
                    "...\nGoodbye..."
                })
            else
                cutscene:battlerText(miss_mizzle, {
                    "Ah! What is this?\nThe chamber can\nno longer hold me.",
                    "It seems your affection\nhas caused some change\nin my form...",
                    "Ah, it's breaking!"
                })
            end
            miss_mizzle.transformationcon = 1
            cutscene:wait(function() return miss_mizzle.amimissmizzle end)
        end
    end
end

function Holywatercooler:getPartyPosition(index)
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

return Holywatercooler