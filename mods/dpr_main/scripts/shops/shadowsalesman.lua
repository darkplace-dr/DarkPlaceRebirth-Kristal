local ShadowShop, super = Class(Shop, "shadowsalesman")

function ShadowShop:init()
    super.init(self)

    if not Game:isDessMode() then
		self.encounter_text = "[emote:idle]* Welcome.[wait:5]\n* Feel free to look around."
		self.shop_text = "[emote:idle]* C'mon kid,[wait:5] I don't have all day, y'know..."
		self.leaving_text = "[emote:idle]* Feel free to come back, if you want..."
		self.buy_menu_text = "[emote:eyebrow_raise]What'll it be?"
		self.buy_confirmation_text = "That'll be\n%s ..."
		self.buy_refuse_text = "[emote:annoyed]Then why'd you ask for it, you schmuck?!"
		self.buy_text = "Much obliged, kid."
		self.buy_storage_text = "I'll put that in storage for ya."
		self.buy_too_expensive_text = "[emote:annoyed]Come back when you can afford this."
		self.buy_no_space_text = "[emote:idle]Clear out some of your stuff, kid."
		self.sell_no_price_text = "[emote:annoyed]The hell is that thing?"
		self.sell_menu_text = "[emote:idle]Sure, I can take some stuff off ya."
		self.sell_nothing_text = "[emote:annoyed]I don't have time for magic acts, bub."
		self.sell_confirmation_text = "I'll take that\nfor \n%s ."
		self.sell_refuse_text = "[emote:annoyed]Uh, okay then???"
		self.sell_text = "[emote:idle]Much obliged, kid."
		self.sell_no_storage_text = "[emote:annoyed]I don't have time for magic acts, kid."
		self.talk_text = "[emote:idle]Got nothin' better to do anyways..."

		self.sell_options_text["items"]   = "Sure, I can take some stuff off ya."
		self.sell_options_text["weapons"] = "Sure, I can take some stuff off ya."
		self.sell_options_text["armors"]  = "Sure, I can take some stuff off ya."
		self.sell_options_text["storage"] = "Sure, I can take some stuff off ya."
    else
		self.encounter_text = "[emote:idle]* Welcome.[wait:5]\n* Feel free to[speed:0.5]...\n[wait:10][speed:1]* (...oh god dammit, it's HER again.)"
		self.shop_text = "[emote:idle]* C'mon kid,[wait:5] I don't have all day, y'know..."
		self.leaving_text = "[emote:idle]* Goodbye...[wait:10]\n* (...and good riddance.)"
		self.buy_menu_text = "[emote:annoyed]You better not take all the soda again."
		self.buy_confirmation_text = "That'll be\n%s ..."
		self.buy_refuse_text = "[emote:annoyed]Then why'd you want it, you schmuck?!"
		self.buy_text = "At least, you have the decency to pay me..."
		self.buy_storage_text = "I'll put that in storage for ya."
		self.buy_too_expensive_text = "[emote:annoyed]Come back when you can afford this."
		self.buy_no_space_text = "[emote:idle]Clear out some of your stuff, kid."
		self.sell_no_price_text = "[emote:annoyed]The hell is that thing?"
		self.sell_menu_text = "[emote:idle]Sure, I can take some stuff off ya."
		self.sell_nothing_text = "[emote:annoyed]I don't have time for magic acts, bub."
		self.sell_confirmation_text = "I'll take that\nfor \n%s ."
		self.sell_refuse_text = "[emote:annoyed]Uh, okay then???"
		self.sell_text = "[emote:idle]Much obliged, kid."
		self.sell_no_storage_text = "[emote:annoyed]I don't have time for magic acts, kid."
		self.talk_text = "[emote:idle](WHY WHY \nWHY WHY \nWHY WHY \nWHY WHY)"

		self.sell_options_text["items"]   = "Sure, I can take some stuff off ya."
		self.sell_options_text["weapons"] = "Sure, I can take some stuff off ya."
		self.sell_options_text["armors"]  = "Sure, I can take some stuff off ya."
		self.sell_options_text["storage"] = "Sure, I can take some stuff off ya."
    end
    
	-- Base Items
    self:registerItem("synthsoda")
    
	-- MistCard Items
	if Game.inventory:hasItem("mistcard") then
		self:registerItem("program_socks")
		self:registerItem("riot_shield")
		self:registerItem("lightaxe")
		self:registerItem("demonscarf")
	end
	
	-- DorsalCard Items
	if Game.inventory:hasItem("dorsalcard") then
		self:registerItem("widecannon")
		self:registerItem("excalibat")
		self:registerItem("caledfwlch")
		self:registerItem("special_snack")
	end
	
    if not Game:isDessMode() then
		self:registerTalk("Who are you?")
		self:registerTalk("Cards")
	
		self:registerTalkAfter("The Diner", 1)
    else
		self:registerTalk("Yoooo whats up")
		self:registerTalk("Order")
    end

    self.shopkeeper:setActor("shadowsalesman_shop")
    self.shopkeeper.sprite:setPosition(0, 15)
    self.shopkeeper.slide = true

    self.voice = "jaru"

    self.background = nil
    self.shop_music = nil
	
    self.shop_bg = self:addChild(JARUShopBG())
    self.shop_bg.layer = self.shopkeeper.layer - 1
	
    self.shop_fg = self:addChild(JARUShopFG())
    self.shop_fg.layer = self.shopkeeper.layer + 1
end

function ShadowShop:startTalk(talk)
    --normal dialogue

    if talk == "Who are you?" then
		self:startDialogue({
			"[emote:eyebrow_raise]* You wanna know about me, eh?",
			"[emote:annoyed]* (Tsk,[wait:5] typical shopkeeper question...)",
			"[emote:idle]* Well, being honest with you,[wait:5] I ain't really anybody too important...",
			"* I'm known as the Shadow Salesman. [wait:10]However, the folks around here call me \"[color:yellow]JARU[color:reset]\".",
			"[emote:annoyed]* And before you ask, no.[wait:5] I ain't THAT Jaru.",
			"* I mean,[wait:5][emote:eyebrow_raise] come on.[wait:10]\n* Do I look like the kinda guy that would yammer on and on about piles of dust or some random guy named \"Oberon Smog\"?",
			"[emote:annoyed]* Yeah,[wait:5] didn't think so, pal.",
		})
    elseif talk == "The Diner" then
		self:startDialogue({
			"* You're in the Dev Diner, kid.[wait:5]\n* It's a place where [color:yellow]DEVS[color:reset] can eat, drink, or just lounge around.",
			"* I set this whole place up here mainly so all my buddies could have a place to chat.",
			"[emote:happy]* Thought I'd do somethin' nice for all the folks that helped bring this world to life,[wait:5] y'know?",
			"[emote:annoyed]* Anyways,[wait:5] are ya gonna buy something or continue staring at me with that deadpan look of yours?",
			"[emote:annoyed]* I ain't an art museum exhibit, y'know.",
		})
    elseif talk == "Cards" then
		if Game.inventory:hasItem("mistcard") and not Game:getFlag("talkedAboutMistCard") then
			self:startDialogue({
				"* [emote:eyebrow_raise]Alright,[wait:10] where the hell did you get that?[wait:10]\n* Did'jya steal it while I wasn't looking?",
				"* ...",
				"[emote:idle]* Oh,[wait:5] you got it from him,[wait:5] didn't you?",
				"* I feel kinda bad about it honestly.",
				"* [emote:annoyed]...",
				"* [emote:eyebrow_raise]Actually,[wait:5] nevermind,[wait:5] I don't feel bad at all.",
				"[emote:idle]* I think I speak for everyone when I say everyone hates [color:red]HER[color:reset].",
			})
			Game:setFlag("talkedAboutMistCard", true)
		else
			self:startDialogue({
				"* Yep,[wait:10] cards are sort of a system put in-place for 'special' customers.",
				"* And by that I mean I give em' out to folks I know or folks I like.",
				"[emote:annoyed]* No,[wait:5] I don't know ya.[wait:10][emote:eyebrow_raise]\n* And I sure as heck don't like ya.",
				"[emote:idle]* Point is,[wait:5] these cards grant you special access to more expensive parts of our inventory.[wait:10]\n* That's about all you need to know.",
			})
		end

    -- Dess Mode dialogue
    elseif talk == "Order" then
		self:startDialogue({
			"[voice:dess]* Okay yeah so can I get a fuckin' uhhhhhhhhhhhhhhhhhhhhhhhhhhhhh\nhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh\nhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh\nhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh\nhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh",
			"* ...",
			"* (Lord,[wait:5] if you're out there, \n[wait:5]PLEASE give me a sign.)",
		})
    end
end

function ShadowShop:onStateChange(old, new)
    super.onStateChange(self, old, new)
    --[[if old == "DIALOGUE" and new == "TALKMENU" then
        if self:getFlag("vhs_obtain") == 1 then
            Game:setFlag("vaporland_sidestory", 1)
            Assets.playSound("item")
            Assets.playSound("creepyjingle")
            Game.inventory:tryGiveItem("retrotape")
            Game.inventory:tryGiveItem("walkie_talkie")
            self.vapor_vhs:remove()
            Kristal.callEvent("createQuest", "Aesthetic Adventure", "vap", "After pestering the Shadow Salesman enough times, he gives you a bizarre-looking artifact from the glorious 80's. Apparently, he says that putting that thing into a VCR somewhere will unlock a gateway to another strange world...but where is the question? Time to go investigate!")
        end
    end]]
end

return ShadowShop
