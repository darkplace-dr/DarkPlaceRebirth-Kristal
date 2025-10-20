---@class field : Map
local field, super = Class(Map)

function field:onEnter()
    super.onEnter(self)

	-- "There is always hope." \
	-- This is what I believe in. \
    --      - Charbomber
	-- \
	-- When this was originally made for Dark Place, it was dedicated to Bor, who was going through some terrible stuff when this was created. \
	-- They're doing much better now, but now, the person who this is dedicated to is Nelle. I honestly wish I could do more to help than just being there for them. \
    -- I just hope that whatever happens, they end up being happy. They deserve to be happy. \
    -- Everyone deserves to be happy. \
    --      - BrendaK7200
	---@type string[]
	self.hopes_and_dreams = {
		"I hope Nelle will be okay.", -- This deserves to show up twice as often.
        "I hope Nelle will be okay.",

		"I hope Bor will be okay.",
		"I hope I can get more sleep soon.",
		"I wish I was more consistant.",
		"I wish I had more time, in general.",
		"I hope everything is going to end up okay.",
		"I hope that all of my friends stay safe.",
		"I hope that I can handle whatever brings me down.",
		"I hope this world lives on for many years to come.",
		"I hope you all get to be happy.",
		"I hope I get to do something meaningful one day.",
		"I hope my sister will see I only want the best for her.",
		"I hope my brother stays safe.",
		"I hope all of the fighting can end.",
		"I pray for everyone who has passed on.",
		"I hope VexSaber will be okay.",
		"I hope this world grows until it ends.\nI want too see how far we've gone.",
		"I pray for a good night's rest.",
		"I dream about this magical world.",
		"I daydream about this place for hours.",
		"I hope to animate this world one day.",
		"I daydream about conversations between the characters.",
		"I wish this world was more adaptive.",
		"I hope for and end.\nSo I could write the in between.",
		"I dream about the comfort this place gives me.",
		"I wish everyone collaborated more often.",
		"I wish to create my own world one day.",
		[[I dream about creating "Dear Lunet".]],
		"I wish I could play music.",
		"I wish I was better at writing.",
		"I wish I was better at music.",
		"I wish I could experience this for the first time agian",
		"I dream about creating Noel.\nI hope you all like them as much as I do.",
		"I hope,\nI dream,\nI love this wonderful world.",
		"I wish to see whatever happens next.",
		"I wish I could sing.",
		"I wish I could be a better friend.",
		"I hope this all won't be for nothing.",
		"I dream about creating something meaningful.",
		--"", -- Please, add more.
		--"", -- All I ask for are your Hopes and Dreams.
		--"", --       -Charbomber
		--"", -- P.S. I'm afraid of this seeming a little presumptuous or cheesy...
		--"", -- In the end, I don't really care if it's cheesy.
		--"", -- I just have always wanted something like this in Dark Place and...
		--"", -- I think we need this now more than ever, so here it is.
	}

	self.text_gen = Game.world.timer:every(2.5, function()
		local text = Text(Utils.pick(self.hopes_and_dreams),
			20, SCREEN_HEIGHT/2,
			SCREEN_WIDTH - 40, SCREEN_HEIGHT,
			{
				align = "center"
			}
		)
		text:setParallax(0, 0)
		text.physics.speed_y = -1
		text.physics.friction = 0.0005
		text:addFX(OutlineFX(COLORS.black, {
			thickness = 2,
			amount = 4
		}))
		text:fadeOutAndRemove(5)
		Game.world:spawnObject(text, "top") -- FIXME: below_ui ?
	end)

	self.star_gen = Game.world.timer:everyInstant(0.5, function()
		for _ = 1, 2 do
			local star = Sprite("effects/star", Utils.random(40, SCREEN_WIDTH - 40), SCREEN_HEIGHT)
			star:setParallax(0, 0)
			star:setOrigin(0.5, 0.5)
			star.rotation = Utils.random(0, 12)
			star.graphics.spin = -1/30
			star.physics.speed_y = -Utils.random(1, 2)
			star.physics.friction = 0.005
			star:fadeOutAndRemove(3)
			Game.world:spawnObject(star, "top")
		end
	end)
end

function field:onExit()
    super.onExit(self)

	Game.world.timer:cancel(self.text_gen)
	Game.world.timer:cancel(self.star_gen)
end

return field
