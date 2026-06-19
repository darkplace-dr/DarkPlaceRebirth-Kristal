local map, super = Class(Map)

function map:onEnter()
    super.onEnter(self)

    self.allowed_places = {}

    local chair1_x, chair1_y = self:getMarker("chair1_hitbox")
    self.chair1_hitbox = Hitbox(Game.world, chair1_x, chair1_y, 2, 20)
    
    local shelf_x, shelf_y = self:getMarker("shelf_hitbox")
    self.shelf_hitbox = Hitbox(Game.world, shelf_x, shelf_y, 140, 28)

    for _, plush in ipairs(self:getEvents("plush")) do ---@param plush PickupPlush
        plush.original_x = plush.x
        plush.original_y = plush.y

        plush.placed_on_shelf = true
        plush.collider.height = plush.collider.height + 10
        plush.collider.x = plush.collider.x + 5
        plush.collider.width = plush.collider.width - 10
        plush.onPickup = function (s)
            if (s.placed_on_shelf) then
                s.placed_on_shelf = nil
                s.collider.height = s.collider.height - 10
                s.collider.x = s.collider.x - 5
                s.collider.width = s.collider.width + 10
            end

            s.sort_mod_y = 0
            s.solid = true
        end
        plush.onTryPlace = function (s)
            if (self.shelf_hitbox:collidesWith(Game.world.player.interact_collider[Game.world.player.facing])) then
                return true
            end
            if (self.chair1_hitbox:collidesWith(Game.world.player.interact_collider[Game.world.player.facing])) then
                return true
            end
            for _, hitbox in ipairs(self.allowed_places) do
                if (hitbox:collidesWith(Game.world.player.interact_collider[Game.world.player.facing])) then
                    return true
                end
            end
            return false
        end
        plush.onPlace = function (s)
            if (self.shelf_hitbox:collidesWith(Game.world.player.interact_collider[Game.world.player.facing])) then
                self:placeOnShelf(s)
                s.y = self.shelf_hitbox.y + 20
            elseif (self.chair1_hitbox:collidesWith(Game.world.player.interact_collider[Game.world.player.facing])) then
                s.placed_on_shelf = false
                s.x = self.chair1_hitbox.x
                s.y = self.chair1_hitbox.y + 12
                s.sort_mod_y = 16
                s.solid = false
            end
        end
        local old = plush.getSortPosition
        plush.getSortPosition = function (s)
            local x, y = old(s)
            return x, y + (s.sort_mod_y or 0)
        end
    end

    do
        local script = self:getEvent("script") ---@type Script
        local old = script.update
        script.update = function(s)
            old(s)
            if s.script and s:collidesWith(Game.world.player.collider) then
                Registry.getEventScript(s.script)(s, chara)
            end
        end
    end

    if (Game:getFlag("hub_silver_npc_progress", 0) <= 2) then
        Game.world:startCutscene("hub.silverroom_intro")
    end
end

---@param s PickupPlush
function map:placeOnShelf(s)
    s.placed_on_shelf = true
    s.collider.height = s.collider.height + 10
    s.collider.x = s.collider.x + 5
    s.collider.width = s.collider.width - 10
end

function map:draw()
    if (DEBUG_RENDER) then
        self.shelf_hitbox:draw(1, 1, 0)
        self.chair1_hitbox:draw(1, 1, 0)
        for _, hitbox in ipairs(self.allowed_places) do
            hitbox:draw(1, 1, 0)
        end
    end
end

return map