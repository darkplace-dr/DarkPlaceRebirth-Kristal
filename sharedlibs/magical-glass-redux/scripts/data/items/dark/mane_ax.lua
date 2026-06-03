local item, super = Class("mane_ax", true)

function item:init()
    super.init(self)

    self.temp_equipabble = true
    Game.world.timer:after(1/30, function()
        self.temp_equipabble = nil
    end)
end

function item:convertToLightEquip(chara)
    return "mg/hairbrush"
end

function item:canEquip(character, slot_type, slot_index)
    if self.temp_equipabble and character.id == "susie" then
        return true
    else
        return super.canEquip(self, character, slot_type, slot_index)
    end
end

return item