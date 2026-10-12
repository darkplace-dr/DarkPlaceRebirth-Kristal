local HeadHathy, super = Class(Recruit)

function HeadHathy:init()
    super.init(self)

    -- Display Name
    self.name = "Head Hathy"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 3

    -- Organize the order that recruits show up in the recruit menu
    self.index = 8

    -- Selection Display
    self.description = "Although stronger than Hathy,\nseems to have fewer friends."
    self.chapter = 1
    self.level = 5
    self.attack = 5
    self.defense = 5
    self.element = "HEART:ICE"
    self.like = "Peace and Quiet"
    self.dislike = "Being Alone"
    self.wish = "Find someone"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = COLORS.purple

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = { "recruits/headhathy/overworld", -3, 22, 4 / 30 }

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return HeadHathy
