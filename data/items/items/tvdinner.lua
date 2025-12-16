local item, super = Class(HealItem, "tvdinner")

function item:init()
    super.init(self)

    -- Display name
    self.name = "TVDinner"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"

    -- Battle description
    self.effect = "Heals\n100HP"
    -- Shop description
    self.shop = "Even non-TVs\ncan eat it\nHP+100"
    -- Menu description
    self.description = ""
    -- Description varies per save file slot
    self.description_variants = {
        [1] = "A TV-shaped premade meal. The TV's pointy\nnose is used as a cone for the ice cream.",
        [2] = "A TV-shaped premade meal. Unfortunately,\nthe vegan steak seems to be a normal shape.",
        [3] = "A TV-shaped premade meal. It even has\na giant crumb of your favorite pie.",
        [4] = "A TV-shaped premade meal. You can see\na mix of various foods in it."
    }

    -- Amount healed (HealItem variable)
    self.heal_amount = 100

    -- Default shop price (sell price is halved)
    self.price = 200
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none/nil)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Character reactions (key = party member id)
    self.reactions = {}
    -- Reaction table varies per save file slot
    self.reaction_variants = {
        [1] = {
            kris = {
                noelle = "What are you, a unicorn? Faha."
            },
            hero = "I'm a unicorn now.",
            susie = "Ack, it's leaking!",
            ralsei = "Look at my long nose!",
            noelle = "\"Brain freeze is for the weak!\"",
            dess = "Wow, it is pretty ice-shocking",
            ceroba = "(I wonder if they have my favorite...)",
            jamm = "What flavor is this? I like it.",
            ["jamm+marcy"] = "Yeah, you deserve it, Marcy."
        },
        [2] = {
            hero = "Meaty.",
            susie = "... obviously isn't real blood.",
            ralsei = "Rare? I ate a rare item?",
            noelle = "I can hardly tell it's not, um, real blood.",
            dess = {
                susie = "STOP WASHING YOUR FACE WITH IT!!",
                dess = "    dess.exe",
            },
            ceroba = {
                ceroba = "What does \"vegan\" mean anyway?",
                jamm = "No meat or dairy. No fun."
            },
            jamm = "It... TASTES like meat, at least."
        },
        [3] = {
            hero = "That's... not my favourite.",
            susie = "Butterscotch, nice!",
            ralsei = "Wow, what a nice flavor!",
            noelle = "Mmm, butterscotch!",
            dess = "UNDERTALE 2",
            ceroba = "Would be great with some tea.",
            jamm = "Wow! Pie is delicious!"     -- Never had pie before
        },
        [4] = {
            hero = "At least that's edible.",
            susie = "Heh, meat! Nice.",
            ralsei = "Such a rich flavor!",
            noelle = "It's crunchy like a salad!",
            dess = "slop",
            ceroba = "A bold decision to mix so much stuff.",
            jamm = "I always liked trail mix."
        }
    }
end

function item:getDescription()
    return self.description_variants[Game.save_id] or self.reactions
end

function item:getReactions()
    return self.reaction_variants[Game.save_id] or self.reactions
end

return item
