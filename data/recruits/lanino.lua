local Lanino, super = Class(Recruit)

function Lanino:init()
    super.init(self)

    -- Display Name
    self.name = "Lanino"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 26

    -- Selection Display
    self.description = "A charming weatherman who can\ncontrol the weather. Which,\nseems like cheating."
    self.chapter = 3
    self.level = 22
    self.attack = 22
    self.defense = 21
    self.element = "FIRE:WIND"
    self.like = "Elnina"
    self.dislike = "Being Alone"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,128/255,0,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/lanino/idle_left", -3, 9}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Lanino