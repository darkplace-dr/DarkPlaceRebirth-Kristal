local Kawkaw, super = Class(Recruit)

function Kawkaw:init()
    super.init(self)

    -- Display Name
    self.name = "Kawkaw"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 2

    -- Organize the order that recruits show up in the recruit menu
    self.index = 39

    -- Selection Display
    self.description = "A conical crow which lives in\nthe ground. Disturbs Shi's\ncrops, only because it wants to\nplay with him."
    self.chapter = 5
    self.level = 43
    self.attack = 36
    self.defense = 38
    self.element = "EARTH"
    self.like = "Nyon!"
    self.dislike = "Nyon..."
    self.wish = "World Nyon" -- not implemented yet

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = COLORS.yellow

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = { "recruits/kawkaw/bobhead", -3, 39, 4 / 30 }

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Kawkaw
