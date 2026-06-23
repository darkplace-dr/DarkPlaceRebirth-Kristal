local item, super = Class(Item, "light/lord_of_the_hammer")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Lord Of The Hammer"

    -- Item type (item, key, weapon, armor)
    self.type = "key"
    -- Whether this item is for the light world
    self.light = true

    self.target = "none"

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A renowned book written by the late Gerson Boom."

    -- Light world check text
    self.check = "A renowned book written by the late Gerson Boom."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
end

function item:onWorldUse(target)
    target = target[1]

    local heroes = {"kris", "susie", "ralsei", "noelle", "berdly"}

    local reactions = {
        hero = {
            "* You open the book and start reading it.",
            "* But then you remember you can't read anything that isn't Wingdings."
        },
        dess = {
            "* You open the book and start reading it.",
            "[voice:dess][face:dess,teehee]* the villain is so cool i wonder who could it be"
        }
    }

    if TableUtils.contains(heroes, target.id) then
        Game.world:showText({
            "* You open the book and start reading it.",
            "* ...There's many things about the story that feels familiar.[wait:5] It creeps you out."
        })
    elseif reactions[target.id] then
        Game.world:showText(reactions[target.id])
    else
        Game.world:showText({
            "* You open the book and start reading it.",
            "* It seems as good as everyone says."
        })
    end
    return false
end

function item:convertToDark()
    return "glass_panel"
end

return item