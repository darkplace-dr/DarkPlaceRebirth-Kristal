local item, super = Class(Item, "fluffy_bandana")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Fluffy Bandana"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Abandoned\nscarf"
    -- Menu description
    self.description = "A bandana made of fluff"

    -- Default shop price (sell price is halved)
    self.price = 300
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        defense = 25,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {
        susie = "Its red, nice.",
        ralsei = "Do i look good on red?",
        noelle = "It's like a comfy bed!",
        dess = "Yummy red",
        jamm = "How do i even put this on?",
        calypso = "It be very fluffy...",
        brenda = "Its soo red!",
        mario = "Lets a go!",
        noel = "This isn't stolen ... right?",
        ceroba = "Red's nice...",
        len = "Fluffy, and somehow comforting.",
    }
end

---@param character PartyMember
function item:onEquip(character, replacement)
    if character.id == "len" then
        local resolution = Game:getFlag("ken_quest_resolution")
        if resolution == 3 then
            Game:setFlag("ken_quest_gaveBandana", false)
        end
    end

    return true
end

---@param character Character
function item:onUnequip(character, replacement)
    if character.id == "len" then
        local resolution = Game:getFlag("ken_quest_resolution")
        if resolution == 3 then
            return false
        end
    end

    return true
end

function item:getReaction(user_id, reactor_id, miniparty)
    if user_id == "len" then
        local resolution = Game:getFlag("ken_quest_resolution")
        if resolution == 3 then
            return "I think it'll be safer with me..."
        end
    end
end

function item:onPedestalSelect()
    return not Game:getQuest("delivering_a_bandana"):isCompleted()
end

---@param cutscene WorldCutscene
function item:onPedestalUse(cutscene)
    Game.inventory:removeItem(self)
    Game:getQuest("delivering_a_bandana"):addProgress(1)
    cutscene:text("* ([color:yellow]" .. self:getName() .. "[color:reset] has been delivered correctly.)")
end

return item
