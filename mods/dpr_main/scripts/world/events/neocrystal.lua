local NeoCrystal, super = Class(Event)

function NeoCrystal:init(data)
    super.init(self, data)

    local properties = data.properties or {}

    self.width = 56
    self.height = 80

    self:setSprite("world/events/neocrystal/empty")
	self.solid = true
    self:setScale(1)

    self.char = properties["char"] or nil
    self.char_spr = properties["char_spr"] or "walk/down_1"
    self.char_type = properties["char_type"] or "dark"

    self.broken = properties["broken"] or false
    self.flag = properties["flag"] or nil
    self.cutscene = properties["cutscene"] or nil

    if self.char ~= nil and not self.broken then
        self.trapped_party_member = Sprite("party/"..self.char.."/"..self.char_type.."/"..self.char_spr, self.width / 2, self.height / 2)
        self.trapped_party_member:setOrigin(0.5, 0.5)
        self.trapped_party_member:setScale(2)
        self.trapped_party_member:addFX(ColorMaskFX({1, 1, 1}))
        self.trapped_party_member.alpha = 0.2
        self:addChild(self.trapped_party_member)
    end

    self.shard = nil
    self.spawn_shards = false
end

function NeoCrystal:update()
    super.update(self)

    if Game:getFlag(self.flag) then
        self.broken = true
    end

    if self.broken then
        self:setSprite("world/events/neocrystal/broken")
    end

    if self.spawn_shards then
        for i = 0, 24-1 do
            self.shard = Sprite("world/events/neocrystal/shard", self.width/2, self.height/2)
            self.shard.layer = 800
            self.shard:setFrame(TableUtils.pick{1, 2})
			self.shard.physics.direction = math.rad(MathUtils.random(360))
            self.shard:setScale(1)
            self.shard:setOrigin(0.5)

            self.shard.rotation = math.rad(MathUtils.random(360))
            self.shard.graphics.spin = 0.15
            self.shard.physics.speed = love.math.random(2, 4)
            self.shard.physics.gravity = 0.2
            self.shard.alpha = 4
            self.shard.graphics.fade_to = 0
            self.shard.graphics.fade_callback = function() self.shard:remove() end
            self.shard.graphics.fade = 0.1

            self:addChild(self.shard)
        end

        self.spawn_shards = false
    end
end

function NeoCrystal:onInteract()
    if Game:getFlag(self.flag) or self.broken then
        Game.world:startCutscene(function(cutscene)
            cutscene:text("* (It's broken.)")
        end)
    else
        if self.cutscene then
            Game.world:startCutscene(self.cutscene)
        else
            Game.world:startCutscene(function(cutscene)
                cutscene:text("* (A large crystal towers before you...)")
                cutscene:text("* (There's nothing inside it.)")
            end)
        end
    end
end

return NeoCrystal