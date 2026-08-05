local item, super = Class(Item, "voidaxe")

function item:init()
    super.init(self)

    self.name = "VoidAxe"

    self.type = "weapon"
    self.icon = "ui/menu/icon/axe"

    self.effect = ""
    self.shop = ""
    self.description = "An axe forged from the nothingness of the void.\nGrants high attack but lowers defense."

    self.price = 1500
    self.can_sell = true

    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {
        attack = 15,
        defense = -5
    }
    self.bonus_name = "Defense DOWN"
    self.bonus_icon = "ui/menu/icon/down"

    self.can_equip = {
        susie = true,
        len = true,
    }

    self.reactions = {
        susie = "Feels weightless.",
        ralsei = "I know I'm the prince of darkness, but...",
        noelle = "It feels... cold?",
		dess = "no way jose",
        brenda = "... No.",
        jamm = "*Kirby flashbacks*",
        calypso = "This material be intimidating...",
        ceroba = "I have so many questions.",
        noel = "Even nothing is something.",
        len = "The void is *üf* really heavy!",
    }
    self.len_axe_progress_flag = "len_axe_handling"
end

function item:getReaction(user_id, reactor_id, miniparty)
    if reactor_id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        if len_axe_progress > 100 then
            return "One with the void."
        elseif len_axe_progress > 60 then
            return "Don't you have anything else?"
        elseif len_axe_progress > 20 then
            return "The void's really voidless..."
        end
    end
    super.getReaction(self, user_id, reactor_id, miniparty)
end

function item:onAttackHit(battler, enemy, damage)
    if battler.chara.id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        local backslash = 990 / (1 + len_axe_progress / 20)
        if backslash > 0 then
            battler:hurt(backslash, true)
        end
        Game:addFlag(len_axe_progress, 1)
    end
end

return item
