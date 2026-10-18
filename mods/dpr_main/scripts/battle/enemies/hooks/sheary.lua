local Sheary, super = HookSystem.hookScript("sheary")

function Sheary:init()
    super.init(self)

    self.killable = true

    self.dialogue = {}

    self.dialogue_characters = {
        kris = "Short-Hair?\nLong-Hair?\nNo-Where?",
        susie = "Wash-hair?\nHair-wash?\nCar-wash?",
        ralsei = "Hot-Shave?\nHot-Wax?\nHot-Shock?",
        noelle = "Snow-Flake?\nSnow-Flake?",
        jamm = "Hair-String?\nSling-String?\nPasta-String?",
        zenore = "Hair?\nWhere?\nAnywhere?"
    }

    self.small_bubble = {
        noelle = true
    }

    for _, party in ipairs(Game.party) do
        if self.dialogue_characters[party.id] then
            table.insert(self.dialogue, party:getName() .. ":\n" .. self.dialogue_characters[party.id])
        end
    end
end

function Sheary:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            self:addMercy(40)
            battler:setActSprite("party/jamm/dark/hairs_" .. TableUtils.pick({ 1, 2, 3 }), -5, 0)
            return "* Jamm received a haircut!"
        end
    end

    return super.onShortAct(self, battler, name)
end

function Sheary:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if not self.firstturnballoon then
        return super.getEnemyDialogue(self)

    else
        local function getPartyDialogue(battler)
            return self.dialogue_characters[battler.chara.id] or "No-Thing?\nNo-Thing?\nNo-Thing?"
        end
        local party = Game.battle.party
        if Game.battle.back_row then
            table.insert(party, Game.battle.back_row)
        end
        local battler = TableUtils.pick(party)
        local dialogue = battler.chara:getName() .. ":\n" .. getPartyDialogue(battler)
        if self.small_bubble[battler.chara.id] then
            self.dialogue_bubble = "sheary"
        else
            self.dialogue_bubble = "sheary_long"
        end
        return dialogue
    end
end

return Sheary
