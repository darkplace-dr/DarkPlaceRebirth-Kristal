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
    
    for _,party in ipairs(Game.party) do
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

return Sheary
