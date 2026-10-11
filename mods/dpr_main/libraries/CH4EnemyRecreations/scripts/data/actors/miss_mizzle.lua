local actor, super = Class(Actor, "miss_mizzle")

function actor:init()
    super.init(self)

    self.name = "Miss Mizzle"

    self.width = 65
    self.height = 74

    self.hitbox = { 7, 23, 24, 20 }

    self.color = { 1, 0, 0 }

    self.flip = nil

    self.path = "battle/enemies/miss_mizzle"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["idle"] = { "idle", 1 / 5, true },
        ["alarm"] = { "alarm", 1 / 5, true },
        ["hurt"] = { "idle_1", 1, true }, -- yeah
    }
    self.animations_pink = {
        ["idle"] = { "idle_pink", 1 / 5, true },
        ["alarm"] = { "alarm_pink", 1 / 5, true },
        ["hurt"] = { "hurt_pink", 1, true },
    }

    self.offsets = {
        ["hurt"] = { 0, 12 },
        ["hurt_pink"] = { 0, 12 }
    }

    self.pink = false
end

function actor:getAnimation(anim)
    if self.pink and self.animations_pink[anim] ~= nil then
        return self.animations_pink[anim] or nil
    else
        return super.getAnimation(self, anim)
    end
end

return actor