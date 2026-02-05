local rabbick, super = Class(Recruit)

function rabbick:init()
    super.init(self)

    -- Display Name
    self.name = "Rabbick"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 0

    -- Organize the order that recruits show up in the recruit menu
    self.index = 4

    -- Selection Display
    self.description = "A real dust bunny.\nKnown to play dirty,\nbut loves to play clean."
    self.chapter = 1
    self.level = 4
    self.attack = 4
    self.defense = 5
    self.element = "RABBIT:DUST"
    self.like = "Dusty Places"
    self.dislike = "Vacuum"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {128/255,0,128/255,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/rabbick/clean", -3, 29}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = true
end

return rabbick