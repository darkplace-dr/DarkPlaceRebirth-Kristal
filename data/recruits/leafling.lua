local Leafling, super = Class(Recruit)

function Leafling:init()
    super.init(self)

    -- Display Name
    self.name = "Leafling"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 2

    -- Organize the order that recruits show up in the recruit menu
    self.index = 36

    -- Selection Display
    self.description = "It blows carefree on the\nwind... until the wind stops\nblowing. Idolizes Aqua."
    self.chapter = 5
    self.level = 40
    self.attack = 37
    self.defense = 12
    self.element = "PLANT:WIND"
    self.like = "Windboarding"
    self.dislike = "Job application"
    self.wish = "Unemployment check" -- not implemented yet

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = COLORS.yellow

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = { "recruits/leafling/idle_b", -3, 34, 4 / 30 }

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Leafling
