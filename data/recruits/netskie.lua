local Netskie, super = Class(Recruit)

function Netskie:init()
    super.init(self)

    -- Display Name
    self.name = "Netskie"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 41

    -- Selection Display
    self.description = "A tricky fox...? Supposed to\nwatch Orange, but Orange\ndoesn't like Netskies. Gets\nalong with Aqua."
    self.chapter = 5
    self.level = 48
    self.attack = 42
    self.defense = 42
    self.element = "ANIMAL?"
    self.like = "Kinoota"
    self.dislike = "Ill-fitting hat"
    self.wish = "(Animated image of tail swishing)" -- not implemented yet

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = COLORS.yellow

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = { "recruits/netskie/recruit", -3, 23, 4 / 30 }

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Netskie
