local item, super = Class(Item, "flowerclip")

function item:init()
    super.init(self)

    self.name = "FlowerClip"

    self.type = "armor"
    self.icon = "ui/menu/icon/armor"

    self.effect = ""
    self.shop = ""
    self.description = "An old, traditional Japanese hairclip with a flower arrangement. Tension gain inc. by 15%."

    self.price = 200
    self.can_sell = true

    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {
        defense = 4,

        graze_tp = 0.15,
    }
    self.bonus_name = "TPGain"
    self.bonus_icon = "ui/menu/icon/up"

    self.can_equip = {
        susie = false,
		jamm = false,
    }

    self.reactions = {
        susie = "Uhh no. Not my thing.",
        ralsei = "Do I... Look cute?",
        noelle = {
            noelle = "Konnichiwa, minna!", -- "Hello, everyone!"
            ceroba = "*smile*" -- she's just happy someone else knows Japan stuff
        },
		dess = "日本語", -- "Japanese"
        ceroba = "Ah, my hair needed that back.",
        noel = "",
		jamm = "",
        ["jamm+marcy"] = "",
        calypso = "",
        len = "",
    }
end

function item:convertToLightEquip(chara)
    return "light/old_clip"
end

return item
