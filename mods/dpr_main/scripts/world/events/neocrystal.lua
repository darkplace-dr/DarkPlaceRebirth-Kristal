local NeoCrystal, super = Class(Event)

function NeoCrystal:init(data)
    super.init(self, data)

    self.width = 56
    self.height = 80

    self:setSprite("world/events/neocrystal/empty")	
	self.solid = true
    self:setScale(1)
	
    self.char = data.properties["char"] or nil
    self.char_spr = data.properties["char_spr"] or "walk/down_1"
    self.char_type = data.properties["char_type"] or "dark"
	
    self.broken = data.properties["broken"] or false
    self.flag = data.properties["flag"] or nil
	
    self.trapped_party_member = Sprite("party/"..self.char.."/"..self.char_type.."/"..self.char_spr, self.width/2, self.height/2)
    self.trapped_party_member:setOrigin(0.5, 0.5)
    self.trapped_party_member:setScale(2)
    self.trapped_party_member:addFX(ColorMaskFX({1, 1, 1}))
    self.trapped_party_member.alpha = 0.2
    if self.char ~= nil or self.broken == false then
        self:addChild(self.trapped_party_member)
    end
	
    self.shard = nil
    self.spawn_shards = false
end

function NeoCrystal:update()
    super.update(self)
    if Game:getFlag(self.flag) == true then
        self.broken = true
    end
	
    if self.broken == true then
        self:setSprite("world/events/neocrystal/broken")
    end
    
    if self.spawn_shards == true then
        for i = 0, 24-1 do
            self.shard = Sprite("world/events/neocrystal/shard", self.width/2, self.height/2)
            self.shard.layer = 800
            self.shard:setFrame(Utils.pick{1, 2})
			self.shard.physics.direction = math.rad(Utils.random(360))
            self.shard:setScale(1)
            self.shard:setOrigin(0.5)
            
            self.shard.rotation = math.rad(Utils.random(360))
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
    if Game:getFlag(self.flag) == true or self.broken == true then
        Game.world:startCutscene(function(cutscene)
            cutscene:text("* (It's broken.)")
            return
        end)
    else
        Game.world:startCutscene("cliffside.break_crystal")
        return
    end
end

return NeoCrystal