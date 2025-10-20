local annabelle, super = Class(EnemyBattler)

function annabelle:init()
    super.init(self)

    -- Enemy name
    self.name = "Annabelle"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/annabelle.lua)
    self:setActor("annabelle")

    -- Enemy health (Perfect Hit does 75.)
    self.max_health = 3000
    self.health = 3000
    -- Enemy attack (determines bullet damage)
    self.attack = 15
    -- Enemy defense (usually 0)
    self.defense = 15
    -- Enemy reward
    self.money = 900

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    self.disable_mercy = true

    self.tired_percentage = 0.04

    self.killable = false
    

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "anna/annabellechase_easy",
        "anna/annabelledelay_easy",
        "anna/annabellespider_easy",
        "anna/annabelletri_easy",
        
        "anna/annabelletri_quick",
        "anna/annabellechase",
        "anna/annabellespider_quick",
        "anna/annabelledelay",
        "anna/annabellechase_quick",
        "anna/annabellespider",
        "anna/annabelledelay_quick",
        "anna/annabelletri",
        
        "anna/annabellefinal",

        "anna/annabelletri_quick",
        "anna/annabellechase",
        "anna/annabellespider_quick",
        "anna/annabelledelay",
        "anna/annabellechase_quick",
        "anna/annabellespider",
        "anna/annabelledelay_quick",
        "anna/annabelletri",
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        nil
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 16 DF 16\n* Huntress demon who loves observing nature and toying with humanity."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Annabelle is flashing a wicked smile.",
        "* It's as if the forest is laughing at you.",
        "* You got this far, it will be over soon.",
        "* Smells like fertilizer.",
        "* You thought you saw a spider, you can't be distracted now!",
        "* Annabelle's arrows are magical, doesn't make them any less dangerous.",
        "* Your SOUL can move through objects if you time the movements right.",
        "* Annabelle seems [color:yellow]ESTATIC[color:reset].",
        "* You could have prepared better, suddenly you are certain.",
        "* The air crackles with freedom, you feel mocked.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    --self.low_health_text = "* Annabelle is panting, even a weak strike should finish her off."
    
    self.turncounter = 0

    self.trumbash = 0
    self.coconut = 0
    self.papaya = 0
    self.perfume = 0
    self.venom = 0
    self.skin = 0
    self.flame = 0
    self.rust = 0
    self.water = 0

    --self:registerAct("Mend of Sun", "Heal\nSelf", nil, 28)
    --self:registerAct("Ice Shard", "Ice\nDamage", nil, 21)
    --self:registerAct("Flame Snap", "Fire\nDamage", nil, 14)
    --self:registerAct("Venom", "Decrease\nDefense", nil, 7)

    --self:registerAct("Thick Skin", "Increase\nDefense", nil, 0)
    --self:registerAct("Rust me!", "Reduce\nDamage", nil, 0)
    --self:registerAct("Water Talk", "Share\nExperience", nil, 0)
    --self:registerAct("Allegro", "Strong\nAttack", nil, 35)
    
    --self:registerAct("Hum Stone", "Gain\n32 TP", nil, 0)
    --self:registerAct("Wet Sand", "Show\nBottle", nil, 0)
    --self:registerAct("Dry Sand", "Show\nBottle", nil, 0)
    --self:registerAct("Water", "Show\nBottle", nil, 0)

    --self:registerAct("Trumbash", "Deal\nDamage", nil, 0)
    --self:registerAct("Coconut", "Heal\nSelf", nil, 0)
    --self:registerAct("Papaya", "Heal\nSelf", nil, 0)
    --self:registerAct("Perfume", "Reduce\nAttack", nil, 0)
end

function annabelle:onAct(battler, name)
    if name == "Allegro" then
        self:hurt(50 - (self.defense*2), battler)
        self:hurt(50 - (self.defense*2), battler)
        self:hurt(50 - (self.defense*2), battler)
        self:hurt(50 - (self.defense*2), battler)
        self:hurt(50 - (self.defense*2), battler)
        Game.battle.enemy_tension_bar:giveTension(2)
        return {
            "* You slice wildly with your sword."
        }
    elseif name == "Water Talk" then
        if self.water == 0 then
            self.water = 1
            self:addMercy(30)
            return {
                "* You recount your experience drinking the cave water. She is glad you shared it."
            }
        else
            return {
                "* You already recounted your experiences, you can't do that again."
            }
        end  
        
    elseif name == "Venom" then
        self.attack = self.attack + 2
        self.defense = self.defense - 3
        if self.venom == 0 then
            self.venom = 1
            self:addMercy(10)
        end
        return {
            "* Suddenly Annabelle lets her guard down, focusing on inflicting pain."
        }
    elseif name == "Thick Skin" then
        if self.skin == 0 then
            self.attack = self.attack - 1
            self.skin = 1
            return {
                "* Suddenly your skin starts to feel thicker."
            }
        else
            return {
                "* Your skin is already thickened."
            }
        end
    elseif name == "Rust me!" then
        if self.rust == 0 then
            Game.battle.enemy_tension_bar:removeTension(16)
            self.defense = self.defense + 10
            self.rust = 1
            self:addMercy(30)
            return {
                "* You ask Annabelle to make your sword rusty and she does so, surprised you mentioned that."
            }
        else
            Game.battle.enemy_tension_bar:removeTension(2)
            return {
                "* You ask Annabelle to make your sword rusty and she does so, but it doesn't get more rusty."
            }
        end  
    elseif name == "Trumbash" then
        if self.trumbash == 0 then
            self:hurt(150, battler)
            self.trumbash = 1
            Game:giveTension((12))
            Game.battle.enemy_tension_bar:giveTension(2)
            return {
                "* You throw your Trumbash and hit Annabelle, her being just as surprised it worked as you."
            }
        else
            return {
                "* You already threw your Trumbash."
            }
        end
    elseif name == "Hum Stone" then
        Game:giveTension((32))
        return {
            "* Your hairs gets raised as tension fills your body."
        }
    elseif name == "Coconut" then
        if self.coconut == 0 then
            battler:heal(160)
            self.coconut = 1
            return {
                "* You eat your coconut and feel as good as new."
            }
        else
            return {
                "* You already ate your coconut."
            }
        end
    elseif name == "Perfume" then
        if self.perfume == 0 then
            self.attack = self.attack - 1
            self.perfume = 1
            self:addMercy(30)
            return {
                "* You apply some perfume to yourself, Annabelle seems to like that."
            }
        else
            return {
                "* Adding more perfume doesn't seem to do anything."
            }
        end    
    elseif name == "Papaya" then
        if self.papaya == 0 then
            battler:heal(160)
            self.papaya = 1
            return {
                "* You eat your papaya and feel as good as new."
            }
        else
            return {
                "* You already ate your papaya."
            }
        end
    elseif name == "Ice Shard" then
        self:hurt(42, battler)
        Game.battle.enemy_tension_bar:removeTension(6)
        return {
            "* Annabelle flinches causing some tension to leave her mind."
        }
    elseif name == "Flame Snap" then
        self:heal(120)
        if self.flame == 0 then
            self:addMercy(10)
            self.flame = 1
        end
        return {
            "* A small flame appears. which cleans and mends Annabelle's skin."
        }
    elseif name == "Mend of Sun" then
        battler:heal(80)
        return {
            "* From one moment to the next your stress vanishes."
        }
    elseif name == "Wet Sand" then
        self:addMercy(0)
        return {
            "* You present your wet sand.",
            "* Annabelle doesn't seem to know how to react."
        }
    elseif name == "Dry Sand" then
        self:addMercy(0)
        return {
            "* You present your dry sand.",
            "* Annabelle doesn't seem to know how to react."
        }
    elseif name == "Water" then
        self:addMercy(0)
        return {
            "* You present your water.",
            "* Annabelle doesn't seem to know how to react."
        }

    elseif name == "Standard" then --X-Action
            self:hurt(34, battler)
            return "* Annabelle takes damage out of fairness."
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function annabelle:selectWave()
	self.turncounter = self.turncounter + 1
	if self.turncounter == 22 then
		self.turncounter = 14
	end
	self.selected_wave = self.waves[self.turncounter]
    return self.waves[self.turncounter]
end

return annabelle