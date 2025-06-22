---@class room_board : Object
---@overload fun(...) : room_board
local room_board, super = Class(Object)

function room_board:init()
    super.init(self)

    self.parallax_x = 0
    self.parallax_y = 0

    self.font = Assets.getFont("main")

    local q = "world/maps/tvland/board/gameshow_"

    self.wall = Sprite(q.."wall")
    self:addChild(self.wall)
    self.wall:setScale(2)

    self.console = Sprite(q.."console") --356 --322 --34
    self:addChild(self.console)
    self.console:setScale(2)
    self.console.x = 270
    self.console.y = 322


    local br = Game:getFlag("board_actors")

    self.kris = NPC(br[1].actor, br[1].x, br[1].y)
    self.kris.world = Game.world

    self:addChild(self.kris)
    self.kris:setFacing("up")

    self.couch = Sprite(q.."couch")
    self:addChild(self.couch)
    self.couch:setScale(2)
    self.couch.y = 452
    self.couch.layer = 1

    self.playerpodiums = Sprite(q.."playerpodiums")
    self:addChild(self.playerpodiums)
    self.playerpodiums:setScale(2)
    self.playerpodiums.x = 128
    self.playerpodiums.y = 474 - 36
    self.playerpodiums.layer = 1

end

function room_board:update()
    super.update(self)
    if Input.pressed("cancel") then
        self:quit()
    end
end

function room_board:draw()
    super.draw(self)

    love.graphics.setFont(self.font)
    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Press [cancel] to EXIT", 150, 286)

end

function room_board:quit()

    Game.world:loadMap("floortv/board")

    local br = Game:getFlag("board_actors")
    Game.world.player.y = br[1].y
    Game.world.player.x = br[1].x
    Game.world.can_open_menu = true
end

return room_board