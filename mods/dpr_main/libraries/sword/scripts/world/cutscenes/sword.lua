return {
    play = function(cutscene, event)

        local function openMenulol(menu, layer)
            local self = Game.world
            if self.menu then
                self.menu:remove()
                self.menu = nil
            end

            if not menu then
                menu = self:createMenu()
            end

            self.menu = menu
            if self.menu then
                self.menu.layer = layer and self:parseLayer(layer) or WORLD_LAYERS["ui"]

                if self.menu:includes(AbstractMenuComponent) then
                    self.menu.close_callback = function ()
                        self:afterMenuClosed()
                    end
                elseif self.menu:includes(Component) then
                    -- Sigh... traverse the children to find the menu component
                    for _, child in ipairs(self.menu:getComponents()) do
                        if child:includes(AbstractMenuComponent) then
                            child.close_callback = function ()
                                self:afterMenuClosed()
                            end
                            break
                        end
                    end
                end

                self:addChild(self.menu)
                self:setState("MENU")
            end
            return self.menu
        end

        local br = {}

        br[1] = {}
        br[1].actor = Game.world.player.actor.id
        br[1].x = Game.world.player.x
        br[1].y = Game.world.player.y

        Game:setFlag("board_actors", br)

        Game.world:loadMap("test_map")

        openMenulol(room_board())
        Game.world:closeMenu()

        Game.world.camera.x = 576
        Game.world.camera.y = 688

        Game.world.player:setActor("player_kris")
        Game.world.player.force_walk = true
        Game.world.can_open_menu = false

    end,
}
