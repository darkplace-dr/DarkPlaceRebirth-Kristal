local item, super = Class(Item, "berserkeraxe")

function item:init()
    super.init(self)

    self.name = "BerserkerAxe"

    self.type = "weapon"
    self.icon = "ui/menu/icon/axe"

    self.effect = ""
    self.shop = ""
    self.description = "An axe stained from combat. Lowers defense,\nbut critical hits will deal double damage."

    self.price = nil
    self.can_sell = false

    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {
        attack = 10,
        defense = -5
    }
    self.bonus_name = "Berserk Crits"
    self.bonus_icon = "ui/menu/icon/angry"

    self.can_equip = {
        susie = true,
        len = true,
    }

    self.reactions = {
        susie = {
            susie = "...",
            brenda = "(Is she doing okay...?)"
        },
        ralsei = "Is that... blood on it?",
        noelle = "E-EEK!! TH-THERE'S BLOOD ON IT!",
	    dess = "do i look like a viking to you",
        brenda = "Uh... no.",
        jamm = "I don't feel comfortable with this...",
        calypso = "...Disturbing.",
        ceroba = "(Who's blood is that...?)",
        noel = "Reckless, and soon rusted...",
        len = "Still just as *uf* heavy!",
    }

    self.len_axe_progress_flag = "len_axe_handling"
end

function item:getReaction(user_id, reactor_id, miniparty)
    if reactor_id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        if len_axe_progress > 12 then
            return "Berserker mode, ON!"
        elseif len_axe_progress > 7 then
            return "I can handle it."
        elseif len_axe_progress > 3 then
            return "It got... lighter?"
        end
    end
    return super.getReaction(self, user_id, reactor_id, miniparty)
end

function item:onAttackHit(battler, enemy, damage)
    if battler.chara.id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        local backslash = 40 / (1 + len_axe_progress / 20)
        if backslash > 0 then
            battler:hurt(backslash, true)
        end
        Game:addFlag(len_axe_progress, 1)
    end
end

return item
