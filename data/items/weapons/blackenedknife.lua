local item, super = Class(Item, "blackenedknife")

function item:init()
    super.init(self)

    self.name = "BlckndKnife"

    self.type = "weapon"
    self.icon = "ui/menu/icon/sword"

    self.effect = ""
    self.shop = ""
    self.description = "A darkened blade, black as night.\nChosen weapon of the Roaring Knight."

    self.price = nil
    self.can_sell = false

    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {
        attack = -10,
        defense = 15,
        magic = 55,
    }
    self.bonus_name = nil
    self.bonus_icon = nil

    self.can_equip = {
        dess = true,
        len = true,
    }

    self.reactions = {
        susie = "... I'm not touching that.",
        ralsei = "...",
        noelle = "(It... reminds me of...)",
	    dess = "aw yeah, evil villain time",
	    jamm = "It feels... terrible...",
        calypso = "Too much dark power...",
        ceroba = "No way I'm taking THAT!",
        len = "Holy! how are they able to hold this???",
    }

    self.len_black_knife_progress_flag = "len_black_knife_handling"
end

function item:convertToLightEquip(chara)
    return "light/pencil"
end

function item:getReaction(user_id, reactor_id, miniparty)
    if reactor_id == "len" then
        local len_black_knife_progress = Game:getFlag(self.len_black_knife_progress_flag, 0)
        if len_black_knife_progress > 50 then
            return "That's right guys, im the Roaring Knight."
        elseif len_black_knife_progress > 35 then
            return "Getting the hang of it."
        elseif len_black_knife_progress > 25 then
            return "(It's easier if i hold it like this.)"
        elseif len_black_knife_progress > 10 then
            return "It's still pretty heavy..."
        end
    end
    super.getReaction(self, user_id, reactor_id, miniparty)
end

function item:onAttackHit(battler, enemy, damage)
    if battler.chara.id == "len" then
        local len_black_knife_progress = Game:getFlag(self.len_black_knife_progress_flag, 0)
        Game:addFlag(len_black_knife_progress, 1)
    end
end

function item:onAttackHit(battler, enemy, damage)
    if battler.chara.id == "len" then
        local len_black_knife_progress = Game:getFlag(self.len_black_knife_progress_flag, 0)
        local backslash = 99 / (1 + len_black_knife_progress / 20)
        if backslash > 0 then
            battler:hurt(backslash, true)
        end
    end
    super.onAttackHit(self, battler, enemy, damage)
end

return item
