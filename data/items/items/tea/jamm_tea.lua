local item, super = Class(HealItem, "jamm_tea")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Jamm Tea"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Healing\nvaries"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "It's own-flavored tea.\nThe flavor just says \"Jamm.\""
    -- Amount healed (HealItem variable)
    self.heal_amount = 50
    -- Amount this item heals for specific characters
    -- Party member this tea is from
    local tea_self = "jamm"
    local placeholder = 50
    self.heal_amounts = {
        ["kris"] = placeholder,
        ["susie"] = placeholder,
        ["noelle"] = placeholder,
        ["dess"] = 60,
        ["jamm"] = 40,
        ["mario"] = 65,
        ["pauling"] = 40,
        ["ceroba"] = 70,
    }

    -- Default shop price (sell price is halved)
    self.price = 10
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions (key = party member id)
    self.reactions = {
		jamm = {
            susie = "It tastes like color?! Gimme some!",
			jamm = "Orange flavored. Neat.",
		},
		noel = {
			noel = "Did you feed me bacon grease???",
			jamm = "(That says a lot...)",
		},
		mario = {
			mario = "Mmm, pasta sauce!",
			jamm = "Wow, you chugged that down quickly!",
		},
		pauling = {
			jamm = "(She gave it a thumbs up...!)",
		},
        ceroba = {
            ceroba = "Usual black tea. Not that it's bad, though.",
			jamm = "", -- 'kay Jamm if you'd be willing to write an accurate reaction here that'd be awesome thanks in advance :) -N
		},
    }
end

function item:getBattleHealAmount(id)
    -- Dont heal less than 40HP in battles
    return math.max(40, super.getBattleHealAmount(self, id))
end

return item