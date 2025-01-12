local LightEnemySprite, super = Class(Object, "LightEnemySprite")

function LightEnemySprite:init(actor)
    if type(actor) == "string" then
        actor = Registry.createActor(actor)
    end

    super.init(self)

    self.actor = actor

    if actor then
        self.sprite_parts = self.actor.light_enemy_parts

        self.width = actor:getWidth()
        self.height = actor:getHeight()
        self.path = actor:getSpritePath()

        self:resetSprite()

        actor:onSpriteInit(self, self.sprite_parts)
    end

    self.debug_rect = {0, 0, 0, 0}
end

function LightEnemySprite:createPart(id, create, functions, extra_func, parent_id)
    if type(extra_func) == "string" then
        parent_id = extra_func
        extra_func = {}
    end
    functions = functions or {}
    self.sprite_parts[id] = {}
    self.sprite_parts[id]._create     = create
    self.sprite_parts[id]._init       = functions["init"]   or function() end
    self.sprite_parts[id]._update     = functions["update"] or function() end
    self.sprite_parts[id]._draw       = functions["draw"]   or function() end
    self.sprite_parts[id]._extra_func = extra_func or {}
    self.sprite_parts[id].__parent_id = parent_id
    return self.sprite_parts[id]
end

function LightEnemySprite:getPart(id)
    return self.sprite_parts[id]
end

function LightEnemySprite:callPartFunction(id, func_id, ...)
    local part = self.sprite_parts[id]
    part._extra_func[func_id](part, ...)
    return part
end

function LightEnemySprite:setActor(actor)
    if type(actor) == "string" then
        actor = Registry.createActor(actor)
    end

    if self.actor and self.actor.id == actor.id then
        return
    end

    for _,child in ipairs(self.children) do
        self:removeChild(child)
    end

    self.actor = actor
    self.sprite_parts = self.actor.light_enemy_parts

    self.width = actor:getLightEnemyWidth()
    self.height = actor:getLightEnemyHeight()
    self.path = actor:getSpritePath()

    actor:onSpriteInit(self)
    self:resetSprite()
end

function LightEnemySprite:setColor(r, g, b, a)
    for _,part in pairs(self.sprite_parts) do
        part.__sprite:setColor(r, g, b, a)
    end
end

function LightEnemySprite:resetSprite(ignore_actor_callback)
    if not ignore_actor_callback and self.actor:preResetLightEnemySprite(self, self.sprite_parts) then
        return
    end

    for _,child in ipairs(self.children) do
        self:removeChild(child)
    end

    for id, part in pairs(self.sprite_parts) do
        part.__sprite = nil
        part.timer = 0

        if part._create then
            if type(part._create) == "string" then
                -- if _create is a string, assume it's a path to a texture, so make
                -- a Sprite with it
                part.__sprite = Sprite(self.path .. "/" .. part._create)
                part.__sprite.debug_rect = {0, 0, 0, 0}
            elseif type(part._create) == "function" then
                if type(part._create()) == "string" then
                    -- if _create is a function that returns a string, assume it's a path to a texture,
                    -- so make a Sprite with it
                    part.__sprite = Sprite(part._create())
                    part.__sprite.debug_rect = {0, 0, 0, 0}
                else
                    -- otherwise, call it and hope for the best
                    part.__sprite = part._create()
                end
            end
            if part.__sprite then
                if part._init then
                    part._init(part)
                end
                self:addChild(part.__sprite)
            else
                print("[MG WARNING] Couldn't create part \"" .. id .. ".\"")
            end
        end
    end

    for id, part in pairs(self.sprite_parts) do
        if part.__parent_id then
            part:setParent(self.sprite_parts[part.__parent_id])
        end
    end

    self.actor:onResetLightEnemySprite(self)
end

function LightEnemySprite:update()
    if self.actor:preLightEnemySpriteUpdate(self) then
        return
    end

    super.update(self)

    for _,part in pairs(self.sprite_parts) do
        if part._update then
            part._update(part)
        end
    end

    self.actor:onLightEnemySpriteUpdate(self)
end

function LightEnemySprite:draw()
    if self.actor:preLightEnemySpriteDraw(self) then
        return
    end

    super.draw(self)

    self.actor:onLightEnemySpriteDraw(self)
end

return LightEnemySprite