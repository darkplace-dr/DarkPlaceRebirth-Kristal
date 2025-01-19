local ImageViewerBroken, super = Class(Sprite, "ImageViewerBroken")

function ImageViewerBroken:init(sprite, x, y)
    super.init(self, sprite, x, y)
    self.x = x or 0
    self.y = y or 0

    self:setParallax(0)
    self.draw_children_below = 0
    self:setScale(2)
    Game.world:spawnObject(self, WORLD_LAYERS["top"])
    
    MagicalGlassLib.viewing_image = true
    Game.lock_movement = true
end

function ImageViewerBroken:update()
    super.update(self)
    if not (DebugSystem:isMenuOpen() or OVERLAY_OPEN) and (Input.pressed("confirm", false) or Input.pressed("cancel", false)) then
        self:remove()
        
        if not MagicalGlassLib.map_transitioning then
            MagicalGlassLib.viewing_image = false
        end
            
        Game.lock_movement = false
        if not MagicalGlassLib.exploit then
            local function has_cutscene() return Game.world:hasCutscene() end
            Game.world.timer:doWhile(has_cutscene, function() MagicalGlassLib.exploit = true end, function() MagicalGlassLib.exploit = false end)
        end
    end
end

return ImageViewerBroken