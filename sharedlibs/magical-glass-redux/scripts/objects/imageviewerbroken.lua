local ImageViewerBroken, super = Class(Sprite)

function ImageViewerBroken:init(sprite, x, y)
    super.init(self, sprite, x, y)

    self.x = x or 0
    self.y = y or 0

    self:setParallax(0)
    self.draw_children_below = 0
    self:setScale(2)
    Game.world:spawnObject(self, WORLD_LAYERS["top"])
    
    Mod.libs["magical-glass"].viewing_image = 1
    Game.lock_movement = true
end

function ImageViewerBroken:update()
    super.update(self)
    
    if not (DebugSystem:isMenuOpen() or OVERLAY_OPEN) and (Input.pressed("confirm", false) or Input.pressed("cancel", false)) then
        self:remove()
        
        if not Mod.libs["magical-glass"].map_transitioning then
            Mod.libs["magical-glass"].viewing_image = 0
        else
            Mod.libs["magical-glass"].viewing_image = 2
        end
        
        Game.lock_movement = false
        if not Mod.libs["magical-glass"].exploit then
            local function has_cutscene() return Game.world:hasCutscene() end
            Game.world.timer:doWhile(has_cutscene, function() Mod.libs["magical-glass"].exploit = true end, function() Mod.libs["magical-glass"].exploit = false end)
        end
    end
end

return ImageViewerBroken