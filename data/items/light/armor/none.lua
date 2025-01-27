local item, super = Class(LightEquipItem, "light/none")

function item:init()
    super.init(self)
    self.name = "None"

    self.type = "armor"
    self.light = true
    self.description = ""
    self.check = ""
    self.usable_in = "all"
    self.result_item = nil
    self.bonuses = {
        attack = 0,
        defense = 0
    }
end

function item:onUnequip(character, replacement)
    local item = replacement
    Utils.hook(item, "onEquip", function (orig, self, character, replacement)
        orig(self, character, replacement)
        if Game.inventory:hasItem("light/none") then
            Game.inventory:removeItem("light/none")
        end
    end)
end

return item