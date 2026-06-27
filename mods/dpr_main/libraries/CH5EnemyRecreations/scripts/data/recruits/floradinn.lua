local Floradinn, super = Class(Recruit)

function Floradinn:init()
    super.init(self)

    -- Display Name
    self.name = "Floradinn"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 2

    -- Organize the order that recruits show up in the recruit menu
    self.index = 35

    -- Selection Display
    self.description = "Looks like Rudinn, but stronger\nand better. It thinks it's a\nflower and probably so does\neveryone else. Idolizes Flowery\nand Green."
    self.chapter = 5
    self.level = 36
    self.attack = 34
    self.defense = 32
    self.element = "PLANT"
    self.like = "Flowers"
    self.dislike = "Other... things?"
    self.wish = "Flowery Bromide" -- not implemented yet

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {1,1,0,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"battle/enemies/floradinn/idle", -3, 35, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Floradinn