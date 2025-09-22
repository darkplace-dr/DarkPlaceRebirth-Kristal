local BallDude, super = Class(Recruit)

function BallDude:init()
    super.init(self)

    -- Display Name
    self.name = "Ball Dude"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 4

    -- Organize the order that recruits show up in the recruit menu
    self.index = 41

    -- Selection Display
    self.description = "A ball that is a dude. Or a dude\nthat is a ball...?"
    self.chapter = 99
    self.level = 7
    self.attack = 12
    self.defense = 3
    self.element = "BALL:BALL"
    self.like = "Balling"
    self.dislike = "Squaring"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {1,177/255,0,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/balldude/idle", 0, 0}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return BallDude