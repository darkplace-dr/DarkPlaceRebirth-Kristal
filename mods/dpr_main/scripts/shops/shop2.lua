local TestShop, super = Class(Shop,  "shop2")

function TestShop:init()
    super.init(self)

    self.encounter_text = "* Welcome to the shop of the beach!"
    self.shop_text = "* Take your time..."
    self.leaving_text = "* Smell ya later!"
    -- Shown when you're in the BUY menu
    self.buy_menu_text = "What do\nyou like\nto buy?"
    -- Shown when you're about to buy something.
    self.buy_confirmation_text = "Buy it for\n%s ?"
    -- Shown when you refuse to buy something
    self.buy_refuse_text = "What,\nnot good\nenough?"
    -- Shown when you buy something
    self.buy_text = "Thanks for that."
    -- Shown when you buy something and it goes in your storage
    self.buy_storage_text = "Thanks for that."
    -- Shown when you don't have enough money to buy something
    self.buy_too_expensive_text = "You don't\nhave enough\nmoney for\nthis."
    -- Shown when you don't have enough space to buy something.
    self.buy_no_space_text = "I'm\ncarrying\ntoo much."
    -- Shown when something doesn't have a sell price
    self.sell_no_price_text = "Why would\nI sell\nthis?"
    -- Shown when you're in the SELL menu
    self.sell_menu_text = "Guess I\ncan get\nrid of\nstuff."
    -- Shown when you try to sell an empty spot
    self.sell_nothing_text = "Nothing\nto give."
    -- Shown when you're about to sell something.
    self.sell_confirmation_text = "Sell it for\n%s ?"
    -- Shown when you refuse to sell something
    self.sell_refuse_text = "I'd\nrather\nhold on\nto this."
    -- Shown when you sell something
    self.sell_text = "There\nwe go."
    -- Shown when you have nothing in a storage
    self.sell_no_storage_text = "Nothing\nin there."
    -- Shown when you enter the talk menu.
    self.talk_text = "Guess I\nshould\nthink."

    self.sell_options_text["items"]   = "What\nshould\nI sell?"
    self.sell_options_text["weapons"] = "What\nshould\nI sell?"
    self.sell_options_text["armors"]  = "What\nshould\nI sell?"
    self.sell_options_text["storage"] = "What\nshould\nI sell?"

   -- self:registerItem("cd_bagel", {description = "ITEM\nMusic with\neach bite\nheals 80HP"})
	
    self:registerItem("tentaser")
    self:registerItem("picnic")
    self:registerItem("lunacookies")
    self:registerItem("peanut")
    self:registerItem("rentalwear")

	self.shopkeeper:setActor("shopkeepers/anna")
    self.shopkeeper.sprite:setPosition(-24, 12)
    self.shopkeeper.slide = true

    self.background = "ui/shopKeeper/anna"
	self.shop_music = "whereverwearenow"

    self:registerTalk("About You")
    self:registerTalk("About This")
    self:registerTalk("This Music?")
    self:registerTalk("Missing Graphic?")

    -- Bonus card
	self.card_width = 5
	self.card_height = 3
	self.list = {1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	self.images = {Assets.getTexture("scratch_card/fail"), Assets.getTexture("scratch_card/excellent"), Assets.getTexture("scratch_card/great"), Assets.getTexture("scratch_card/good"),}
	self.rewards = {0, 0.9, 0.2, 0.1}
	self.bonus_selected = false
	self.bonus_timer = 0
	self.bonus_money = 0
	self.bonus_game = true
	self.bonus_fail_dialogue = "* Too bad![wait:5]\n* Better luck next time!"
	self.bonus_win_dialogue_1 = "* Good job![wait:5] You got a rank "
	self.bonus_win_dialogue_2 = " win!"
end

function TestShop:startTalk(talk)
    if talk == "Missing Graphic?" then
        self:startDialogue({
            "* That is my pet, an infant Virovirokun!",
            "* He is a lovely fella, just shy around new people.",
            "* So don't poke him or I will poke you with my Killer Lance!"
        })
    elseif talk == "About You" then
        self:startDialogue({
            "* I am Anna.",
            "* I come from a family of many shopkeepers like myself.",
            "* In my free time I am a lapis archetype. (I wear red armor.)",
            "* I am actually surprised I am the shopkeep here.",
            "* Considering the definetely not Monika shopkeep is more iconic.",
            "* But I ain't complaining, why should I?",
            "* About time that stupid Yandere gets a turn to not be in the spotlight.",
            "* And yet I talk about her right now, this girl will never truly vanish."
        })
    elseif talk == "About This" then
        self:startDialogue({
            "* Welcome to Tritra Land.",
            "* This land was made in the image of TritraSerpifeu.",
            "* A land where he recycled some content from his games.",
            "* He actually had this on his bucket list.",
            "* He is a strange autistic man, if you can't tell by this alone.",
            "* He also made Notsuki for this. I have no idea why.",
            "* Maybe he got in a fight with the Twisters who previously organized the race?",
            "* But Notsuki is a good girl, she is good company.",
            "* We beat Casette Beasts and Pikmin 3 Deluxe together."
        })
    elseif talk == "This Music?" then
        self:startDialogue({
            "* It is Wherever we are now from Casette Beasts.",
            "* This game is filled with good music with vocals.",
            "* Although in the actual game you don't often hear the vocals.",
            "* They only play in battle when you fuse, something you can't always do.",
            "* But that does make the lyrics even cooler when they do play.",
            "* Like finally seeing a puzzle in its full form.",
            "* Wow, I sound like I am trying to sell you Casette Beasts.",
            "* I can get very distracted sometimes, wow..."
        })
    end
end

return TestShop