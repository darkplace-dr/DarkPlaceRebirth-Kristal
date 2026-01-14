local id = "shadowguy"
local actor, super = Class(Actor, id)

function actor:init()
    super.init(self)
    self.name = "Shadowguy"

    -- Width and height for this actor, used to determine its center
    self.width = 54
    self.height = 56

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
	local offset = self.height * .75
	local xoffset = self.width * .25

    self.hitbox = {xoffset, offset, self.width - (xoffset * 2), self.height - offset}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = "right"

    -- Path to this actor's sprites (defaults to "")
    self.path = "npcs/" .. id
    self.default = "idle"

    self.animations = {
        ["idle"]        = {"idle_b", 0.15, true},
        ["idle_ow"]     = {"idle_a", 0.15, true},
        ["idle_nothat"] = {"idle_b_nothat", 0.15, true},

        ["hurt"]        = {"hurt", 0.5, true},
        ["spared"]      = {"spare", 0.25, true},

		["sax_a"]       = {"sax_a", 0.075, true},
		["sax_b"]       = {"sax_b", 0.075, true},

		["firing"]      = {"firing", 0, true},
		["reload"]      = {"reload", 0.2, true},

        ["idle_bunny"]  = {"idle_bunny", 0.15, true},

        ["idle_cat"]    = {"idle_cat", 0.15, true},
		["cat"]         = {"cat", 0.15, true},
		["cat_dance"]   = {"cat_dance", 0.15, true},
	}	

    self.offsets = {
        ["idle_bunny"] = {0, -11},
        ["sax_a"] = {0, 0},
        ["sax_b"] = {0, 0},
		["scream"] = {0, 0},
		["hurt"] = {0, 0},
		["firing"] = {-22, 1},
		["reload"] = {0, -11},
		["cat"] = {0, 0},
		["cat_dance"] = {-2, 2},
	}
end

function actor:createSprite()
    return ShadowguyActor(self)
end

function actor:preSetAnimation(sprite, anim, ...)
	if anim == "firing" then
		sprite.gun.visible = true
	elseif anim == "scream" then
		Assets.playSound("shadowguy_scream")
	else
		if sprite.gun then
			sprite.gun.visible = false
		end
	end
end

return actor