local test_map, super = Class(Map)

-- Define your grid size (how wide/tall each camera section is)
local GRID_WIDTH = 192
local GRID_HEIGHT = 176

function test_map:onEnter()
    super.onEnter(self)


    Game.world:openMenu(room_board())
    Game.world:closeMenu()

    Game.world.camera.keep_in_bounds = false
    Game.world.camera.state = "STATIC"
    Game.world.camera.x = 0
    Game.world.camera.y = 0

    self.speedy = 8
    self.speedx = 8
end

function test_map:update()
    super.update(self)
    if Game.world.player then
        local px = Game.world.player.x
        local py = Game.world.player.y
        local grid_w = 192 * 2
        local grid_h = 256
        --Game.world.camera.x = math.floor(px / grid_w) * grid_w + 192
        --Game.world.camera.y = math.floor(py / grid_h) * grid_h + 176

        local misc_x = math.floor(px / grid_w) * grid_w + 192
        local misc_y = math.floor(py / grid_h) * grid_h + 176


        if misc_x > Game.world.camera.x then
            Game.world.camera.x = Game.world.camera.x + DTMULT*self.speedx
        elseif misc_x < Game.world.camera.x then
            Game.world.camera.x = Game.world.camera.x - DTMULT*self.speedx
        end

        if misc_y > Game.world.camera.y then
            Game.world.camera.y = Game.world.camera.y + DTMULT*self.speedy
        elseif misc_y < Game.world.camera.y then
            Game.world.camera.y = Game.world.camera.y - DTMULT*self.speedy
        end

    end
end

return test_map
