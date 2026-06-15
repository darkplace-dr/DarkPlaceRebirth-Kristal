local Shop, super = HookSystem.hookScript(Shop)

function Shop:init()
    if Mod.libs["magical-glass"].last_shop_world_type == nil then
        Mod.libs["magical-glass"].last_shop_world_type = Game:isLight()
    end
    Game:setLight(false)

    super.init(self)
end

function Shop:leave()
    if Mod.libs["magical-glass"].last_shop_world_type ~= nil then
        Game:setLight(Mod.libs["magical-glass"].last_shop_world_type)
    end
    Mod.libs["magical-glass"].last_shop_world_type = nil

    super.leave(self)
end

return Shop