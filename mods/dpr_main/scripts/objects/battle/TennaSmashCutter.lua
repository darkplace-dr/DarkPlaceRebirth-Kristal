local TennaSmashCutter, super = Class(Object)

function TennaSmashCutter:init(x, y)
    super.init(self, x, y)

    self:setSprite("world/npcs/tenna/point_up")
    self:setScale(2)
    self:setOriginExact(30, 118)
    self:setLayer(BATTLE_LAYERS["darkener"] - 10)

    self.tenna = Game.battle:getEnemyBattler("tenna")
    if self.tenna then
        self.x = 525 + self.tenna.sprite.shakex
        self.y = 255

        self.tenna.sprite.x = -9999
    end

    self.timer = 0
    self.con = 0
    self.physics.speed_y = -16
    self.physics.gravity = 1

    self.fronttenna = Sprite(self.sprite.texture, self.x, self.y)
    self.fronttenna.x, self.fronttenna.y = self.x, self.y
    self.fronttenna:setScale(2)
    self.fronttenna:setLayer(BATTLE_LAYERS["above_bullets"])
    self.fronttenna.alpha = 0
    Game.battle:addChild(self.fronttenna)
end

function TennaSmashCutter:setSprite(texture, speed, loop, on_finished)
    if self.sprite then
        self:removeChild(self.sprite)
    end
    if texture then
        self.sprite = Sprite(texture)
        self.sprite.inherit_color = true
        self:addChild(self.sprite)

        if speed then
            self.sprite:play(speed, loop, on_finished)
        end

        self.width = self.sprite.width
        self.height = self.sprite.height

        return self.sprite
    end
end

function TennaSmashCutter:update()
    super.update(self)

    local old_t = self.timer
    self.timer = self.timer + DTMULT

    if old_t < 1 and self.timer >= 1 then
        self:setSprite("world/npcs/tenna/battle/attack")
        self:setOriginExact(58, 114)

        Assets.playSound("jump", 0.7, 1.8)
    end

    if self.timer < 6 then
        self.fronttenna:fadeToSpeed(1, 0.2)
    end

    if old_t < 26 and self.timer >= 26 then
        self.sprite:setFrame(2)

        Assets.playSound("scytheburst")
    end

    if old_t < 27 and self.timer >= 27 then
        self.physics.speed_y = 0
        self.physics.gravity = 0
        local smashcut_manager = self.wave:spawnObject(TennaSmashCutManager(self.x, self.y))
        smashcut_manager:setLayer(BATTLE_LAYERS["top"])
        Game.battle:shakeCamera()

        local smashcut_attack = Game.stage:getObjects(Registry.getBullet("tenna/smashcut_attack"))[1]
        smashcut_attack.rumble_loop:play()
    end

    if old_t < 35 and self.timer >= 35 then
        self.physics.gravity = 1
    end

    if self.timer > 41 then
        self.fronttenna:fadeToSpeed(0, 0.2)
    end

    if old_t < 46 and self.timer >= 46 then
        self:remove()
    end

    self.fronttenna:setSprite(self.sprite.texture)
    self.fronttenna:setFrame(self.sprite.frame)
    self.fronttenna.x, self.fronttenna.y = self.x, self.y
    self.fronttenna:setOriginExact(self.origin_x, self.origin_y)
end

function TennaSmashCutter:onRemove(parent)
    super.onRemove(self, parent)

    if self.tenna then
        self.tenna.sprite.x = self.tenna.sprite.init_x
    end
    
    self.fronttenna:remove()
end

return TennaSmashCutter