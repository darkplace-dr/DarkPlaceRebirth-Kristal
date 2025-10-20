local GoogleDino, super = Class(Recruit)

function GoogleDino:init()
    super.init(self)

    -- Display Name
    self.name = "Google Dino"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 37

    -- Selection Display
    self.description = "A dinosaur that appears when your\nWi-Fi is down."
    self.chapter = 99
    self.level = 4
    self.attack = 5
    self.defense = 2
    self.element = "FIGHT"
    self.like = "Running"
    self.dislike = "Cactuses and birds"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "dark"

    -- Dyes the box gradient
    self.box_gradient_color = {1,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/googledino/idle", 0, 0, 1/2}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return GoogleDino