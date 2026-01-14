local item, super = Class(Item, "friva_blend")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Friva Blend"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Use\nout of\nbattle"
    -- Shop description
    self.shop = nil
    -- Menu description
    self.description = "A blend that raises DEF for the user by 1."

    -- Default shop price (sell price is halved)
    self.price = 0
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "world"
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions (key = party member id)
    self.reactions = {
	    jamm = "Ooh, spicy~!",
        noel = "... Nothing happened...",
        ceroba = "What a curious mix of tastes."
    }
end

function item:onWorldUse(target)
	if target.id ~= "noel" then
		target:increaseStat("defense", 1)
	end
	Assets.playSound("swallow")
	local drinksnd = Assets.newSound("straw_drink_long", 0.8, 1.2)
	drinksnd:play()
	Game.world.timer:after(0.3, function()
		drinksnd:stop()
	end)
    for _, actionbox in ipairs(Game.world.healthbar.action_boxes) do
        if actionbox.chara.id == target.id then
			local xx = 69
			if #Game.party == 4 then
				xx = 49
			end
			local inc_text = "DF +1"
			if target.id == "noel" then
				inc_text = "DF +0"
			end
            local text = HPText(inc_text, Game.world.healthbar.x + actionbox.x + xx, Game.world.healthbar.y + actionbox.y + 15)
            text.layer = WORLD_LAYERS["ui"] + 1
			text.color = COLORS.orange
            Game.world:addChild(text)
            return
        end
    end
end

return item
