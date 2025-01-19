local dog, super = Class(Item, "mg_item/annoying_dog")

function dog:init()
    super.init(self)

    -- Display name
    self.name = "Annoying Dog"
    -- Name displayed in the normal item select menu
    self.short_name = "AnnoyDog"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Dog"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 999
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of the debug menu)
    self.description = "A little white dog.\nIt's fast asleep..."

    -- Light world check text
    self.check = "Dog\n* A little white dog.[wait:10]\n* It's fast asleep..."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "world"
end

function dog:onWorldUse()
    local result
    if Game.world.map.onDogUse then result = Game.world.map:onDogUse() end
    if result == nil then
        Game.world:showText("* You deployed the dog.")
        local items = {
            "mg_item/dog_residue_1",
            "mg_item/dog_residue_2",
            "mg_item/dog_residue_3",
            "mg_item/dog_residue_4",
            "mg_item/dog_residue_5",
            "mg_item/dog_residue_6",
        }
        Game.inventory:replaceItem("mg_item/annoying_dog", Utils.pick(items))       
    end
end

function dog:onToss()
    local result
    if Game.world.map.onDogDropped then result = Game.world.map:onDogDropped() end
    if result == nil then
        Game.world:showText("* (You put the dog on the\nground.)")
        local items = {
            "mg_item/dog_residue_1",
            "mg_item/dog_residue_2",
            "mg_item/dog_residue_3",
            "mg_item/dog_residue_4",
            "mg_item/dog_residue_5",
            "mg_item/dog_residue_6",
        }
        Game.inventory:replaceItem("mg_item/annoying_dog", Utils.pick(items))
    end
    return false
end

return dog