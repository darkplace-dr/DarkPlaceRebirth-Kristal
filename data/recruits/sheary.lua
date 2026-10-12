local Sheary, super = Class(Recruit)

function Sheary:init()
    super.init(self)

    -- Display Name
    self.name = "Sheary"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 2

    -- Organize the order that recruits show up in the recruit menu
    self.index = 40

    -- Selection Display
    self.description = "A familiar dancer with sharp \nlegs. Only fights when \nprovoked. Idolizes Blue."
    self.chapter = 5
    self.level = 41
    self.attack = 44
    self.defense = 30
    self.element = "SCYTHE"
    self.like = "Making doilies"
    self.dislike = "Language"
    self.wish = "Ballroom dance" -- not implemented yet

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = COLORS.yellow

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = { "recruits/sheary/recruit", -3, 19, 4 / 30 }

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Sheary
