local Mizzle, super = Class(Recruit)

function Mizzle:init()
    super.init(self)

    -- Display Name
    self.name = "Mizzle"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 2

    -- Organize the order that recruits show up in the recruit menu
    self.index = 30

    -- Selection Display
    self.description = "The aqua fairy which slumbers\nin the \"Water Cooler\".\nArbitrarily does fairy-like or\nprincess-like things (as she\npleases)."
    self.chapter = 4
    self.level = 31
    self.attack = 21
    self.defense = 21
    self.element = "WATER"
    self.like = "Bath bombs"
    self.dislike = "Alarm clock"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,0,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/mizzle/idle", -3, 22, 1/10}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Mizzle