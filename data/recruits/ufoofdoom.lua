local UFOOfDoom, super = Class(Recruit)

function UFOOfDoom:init()
    super.init(self)

    -- Display Name
    self.name = "UFO Of Doom"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 7

    -- Organize the order that recruits show up in the recruit menu
    self.index = 38

    -- Selection Display
    self.description = "A UFO just like from those\nmovies about aliens."
    self.chapter = 99
    self.level = 2
    self.attack = 3
    self.defense = 0
    self.element = "SPACE"
    self.like = "Flying"
    self.dislike = "Crashing"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {1,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/ufoofdoom/idle", 0, 0, (75/120)/4}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return UFOOfDoom