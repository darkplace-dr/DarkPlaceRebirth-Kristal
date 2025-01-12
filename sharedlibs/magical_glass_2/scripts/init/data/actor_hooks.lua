Utils.hook(Actor, "init", function(orig, self)
    orig(self)

    self.light_enemy_sprite = false

    self.light_enemy_parts = {}
    self.light_enemy_width = 0
    self.light_enemy_height = 0
end)

Utils.hook(Actor, "getLightEnemyWidth", function(orig, self)
    return self.light_enemy_width
end)

Utils.hook(Actor, "getLightEnemyHeight", function(orig, self)
    return self.light_enemy_height
end)

Utils.hook(Actor, "onLightEnemySpriteInit", function(orig, self, sprite) end)

Utils.hook(Actor, "preResetLightEnemySprite", function(orig, self, sprite) end)
Utils.hook(Actor, "onResetLightEnemySprite", function(orig, self, sprite) end)

Utils.hook(Actor, "preLightEnemySpriteUpdate", function(orig, self, sprite) end)
Utils.hook(Actor, "onLightEnemySpriteUpdate", function(orig, self, sprite) end)

Utils.hook(Actor, "preLightEnemySpriteDraw", function(orig, self, sprite) end)
Utils.hook(Actor, "onLightEnemySpriteDraw", function(orig, self, sprite) end)

Utils.hook(Actor, "preLightEnemySet", function(orig, self, sprite, overlay, texture, keep_anim) end)
Utils.hook(Actor, "onLightEnemySet", function(orig, self, sprite, overlay, texture, keep_anim) end)
Utils.hook(Actor, "preLightEnemySetAnim", function(orig, self, sprite, overlay, anim, callback) end)
Utils.hook(Actor, "onLightEnemySetAnim", function(orig, self, sprite, overlay, anim, callback) end)
Utils.hook(Actor, "preLightEnemySetSprite", function(orig, self, sprite, overlay, texture, keep_anim) end)
Utils.hook(Actor, "onLightEnemySetSprite", function(orig, self, sprite, overlay, texture, keep_anim) end)
Utils.hook(Actor, "preLightEnemySetAnim", function(orig, self, sprite, overlay, anim, callback) end)
Utils.hook(Actor, "onLightEnemySetAnim", function(orig, self, sprite, overlay, anim, callback) end)

Utils.hook(Actor, "addLightEnemyPart", function(orig, self, id, create, functions, extra_func, parent_id)
    if type(extra_func) == "string" then
        parent_id = extra_func
        extra_func = {}
    end
    functions = functions or {}
    self.light_enemy_parts[id] = {}
    self.light_enemy_parts[id]._create     = create
    self.light_enemy_parts[id]._init       = functions["init"]   or function() end
    self.light_enemy_parts[id]._update     = functions["update"] or function() end
    self.light_enemy_parts[id]._draw       = functions["draw"]   or function() end
    self.light_enemy_parts[id]._extra_func = extra_func or {}
    self.light_enemy_parts[id].__parent_id = parent_id
end)

Utils.hook(Actor, "createLightEnemySprite", function(orig, self)
    return LightEnemySprite(self)
end)