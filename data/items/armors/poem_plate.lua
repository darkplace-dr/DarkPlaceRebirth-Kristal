local item, super = Class(Item, "poem_plate")

function item:init()
    super.init(self)

    self.name = "Poem Plate"
    self.type = "armor"
    self.icon = "ui/menu/icon/armor"
    self.effect = "Inversion"
    self.shop = "Offensive\nDefence"
    self.description = "Proof that words hurt."
    self.price = 354
    self.can_sell = false
    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {}
    self.bonus_name = nil
    self.bonus_icon = nil
    self.can_equip = {
        noel = false,
    }
    self.reactions = {
        susie = "What, you want me to read it? Hell no.",
        ralsei = "Oh, a poem? For me?",
        noelle = "(Does Susie like poems...?)",
        dess = "that's some shitty writing",
        ceroba = "How did they write on THAT?",
        noel = "Just no",
        jamm = "I've been meaning to read more...",
    }
end

function item:swapStats(character)
    local stat = character.stats
    local atk = stat.attack
    local def = stat.defense

    character.stats.attack = def
    character.stats.defense = atk
end

function item:onEquip(character, replacement)
    self:swapStats(character)

    return true
end

function item:onUnequip(character, replacement)
    self:swapStats(character)

    return true
end

return item
