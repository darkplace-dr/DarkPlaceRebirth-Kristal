local item, super = Class(Item, "nobodyweapon")

function item:init()
    super.init(self)

    self.name = "NobodyWeapon"
    self.type = "weapon"
    self.icon = nil
    self.effect = ""
    self.shop = ""
    self.description = "* A legendary weapon that only the chosen one can wield, unfortunately that's nobody you'd know..."
    self.price = 1
    self.can_sell = true
    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    local num = math.huge

    self.bonuses = {
        attack  = num,
        defense = num,
        magic   = num,
    }
    self.bonus_name = nil
    self.bonus_icon = nil

    self.can_equip = {}

    self.reactions = {
        noel = "Concerning...",
        ceroba = "... so why bother giving it?",
        jamm = "...Okay, now you're just taunting us.",
        calypso = "Ye should be ashamed...",
        len = "What? it slips off!",
    }
end

function item:canEquip(character, slot_type, slot_index)
    if character.id == "len" then
        local party = Game:getPartyMember("len")
        if party then
            self.old_weapon = party:getWeapon()
            Game.world.timer:after(0.3, function()
                local weapon = party:getWeapon()
                if weapon == self then
                    Assets.playSound("equip")
                    party:setWeapon(self.old_weapon)
                end
            end)
            return true
        end
    end
    return false
end

return item
