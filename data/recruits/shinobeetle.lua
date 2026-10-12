local Shinobeetle, super = Class(Recruit)

function Shinobeetle:init()
    super.init(self)

    -- Display Name
    self.name = "Shinobeetle"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 3

    -- Organize the order that recruits show up in the recruit menu
    self.index = 38

    -- Selection Display
    self.description = "Seth's disciple. Instructed by\nSeth to be a master of\nNinjutsu, but... watching Seth,\njust became a nerd."
    self.chapter = 5
    self.level = 46
    self.attack = 42
    self.defense = 37
    self.element = "BUG:WIND"
    self.like = "Train photos"
    self.dislike = "Being in train"
    self.wish = "60's rock re-release" -- not implemented yet

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = COLORS.yellow

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = { "recruits/shinobeetle/spare", -3, 6, 4 / 30 }

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Shinobeetle
