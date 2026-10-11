local Holywatercooler, super = Class(EnemyBattler)

function Holywatercooler:init()
    super.init(self)

    self.name = "HolywaterCooler"
    self:setActor("holywatercooler")

    self.max_health = 1740
    self.health = 1740
    self.attack = 14
    self.defense = 0
    self.money = 500
    self.experience = 0
    self.spare_points = 4

    self.dialogue = { "Glory, glory." }

    self.text = {
        "* You feel a strong presence from the watercooler.",
        "* The watercooler babbles to itself sesquipedalianarily.",
        "* The watercooler considers the precise gemstone to compare its own hue to.",
        "* The watercooler stays its breath, too precious to waste... and keeps talking.",
        "* The watercooler emits an aura of magnanimous condescension."
    }
    self.text_missmizzle = {
        "* You hear the sound of raindrops.",
        "* You hear a distant thunder.",
        "* Waves crash far, far, far below."
    }

    self.tired_percentage = 0

    self:registerAct("Flirt", "???")
    self:registerAct("BegForMercy", "???")
    self:registerAct("Chat", "???", "all")

    self.begformercyskip = false
    self.begformercycount = 0
    self.chatcount = 0
    self.flirtcount = 0
    self.havestolenbefore = false
    self.previouslyflirted = false
    self.gothurtlastturn = false
    self.violenceturn = 0
    self.tiredcount = 0
    self.transformationcon = 0
    self.transformationtimer = 0

    self.disgustingstr = "Disgusting."

    self.siner = 0

    self.transformation_sprite_cooler = nil
    self.transformation_sprite_mizzle = nil
    self.transformation_sound = Assets.getSound("sneo_overpower")
    self.transformation_sound:setVolume(0.7)
    self.transformation_sound:setPitch(1.3)
end

function Holywatercooler:onTired()
    self:setAnimation("idle")
end

function Holywatercooler:onAwake()
    self:setAnimation("alarm")
end

function Holywatercooler:onSpareable()
    if self.amimissmizzle then
        self.actor.pink = true
        if self:isTired() then
            self:setAnimation("idle")
        else
            self:setAnimation("alarm")
        end
    else
        super.onSpareable(self)
    end
end

function Holywatercooler:onAct(battler, name)
    if name == "Check" then
        if not self.amimissmizzle then
            return "* HOLYWATERCOOLER - Just seems like a Watercooler with an ego."
        else
            return "* MISS MIZZLE - A Mizzle transformed with affection."
        end
    elseif name == "Flirt" then
        Game.battle:startActCutscene(function(cutscene)
            self.flirtcount = self.flirtcount + 1
            self.acttalked = true
            cutscene:text("* You FLIRTED with HolyWatercooler!") -- inconsistent name capitalization much?
            if self.previouslyflirted and self.flirtcount == 1 then
            elseif not self.previouslyflirted and self.flirtcount == 1 then
                local choice = cutscene:choicer({ "First time", "I flirt\nwith everyone" })
            elseif self.flirtcount == 2 then
            elseif self.flirtcount == 3 or (self.previouslyflirted and self.flirtcount == 2) then
                self.failedflirting = true
                self:addMercy(5)
                cutscene:battlerText(self, self.disgustingstr)
            elseif self.flirtcount > 3 or (self.previouslyflirted and self.flirtcount > 2) then
                self.failedflirting = true
                cutscene:battlerText(self, self.disgustingstr)
            end
        end)
        return
    elseif name == "BegForMercy" then
        Game.battle:startActCutscene(function(cutscene)
            self.begformercycount = self.begformercycount + 1
            self.acttalked = true
            cutscene:text("* You begged for mercy...")
            if self.begformercycount == 1 then
                cutscene:battlerText(self, {
                    "Blessed are those\nwho kneel to me,\nfor my waves shall\ncleanse you.",
                    "Close your eyes,\nfor as long as you\nadore my purity,\nno harm shall\nfollow you."
                })
                self:addMercy(10)
                self.begformercyskip = true
                for _, battler in ipairs(Game.battle.party) do
                    battler:heal(50)
                end
                cutscene:text("* (HolyWatercooler took mercy on you!)")
            elseif self.begformercycount == 2 then
                cutscene:battlerText(self, {
                    "Again you pray!\nWith renewed vigor,",
                    "But now your hands\nshake with\ncarbonated nerves",
                    "And fear\ndrips down your face\nin painted horror.",
                    "You beg not\nfor salvation\nby my purity, but",
                    "For fear of some\nugliness you see\nreflected\nin the glass.",
                    "Once again\nI shall show mercy,\nbut no more."
                })
                self:addMercy(10)
                self.begformercyskip = true
                for _, battler in ipairs(Game.battle.party) do
                    battler:heal(50)
                end
                cutscene:text("* (HolyWatercooler took mercy on you!)")
            elseif self.begformercycount == 3 then
                self:addMercy(5)
                cutscene:battlerText(self, self.disgustingstr)
            elseif self.begformercycount > 3 then
                cutscene:battlerText(self, self.disgustingstr)
            end
        end)
        return
    elseif name == "Chat" then
        Game.battle:startActCutscene(function(cutscene)
            self.chatcount = self.chatcount + 1
            self.acttalked = true
            if self.chatcount == 1 then
                cutscene:text("* Everyone chatted around the Watercooler!")
                cutscene:battlerText(self, {
                    "All around me\ndid you chatter,\nbut your tepid words",
                    "Have not once\nbeen decantered\nin my direction.\nYour ignorance\nbescorns me...",
                    "Speak well of my nature,\nand you shall be spared."
                })
            elseif self.chatcount == 2 then
                cutscene:text("* (Seems like you should choose a topic...)")
                local choice = cutscene:choicer({ "Recruit", "Beauty", "Cactuses are better", "Flowers" })
                if choice == 1 then
                    cutscene:battlerText(self, {
                        "Ah, I see...\nSo you offer yourselves\nto be my recruits.",
                        "Despite my stature,\nI hardly hold a court here,",
                        "For, given respect even\nby Lightners, I have all\nI could desire.",
                        "But, should you behave\nwith quiet dedication,"
                    })
                    self:addMercy(15)
                    cutscene:battlerText(self, "There may be\nsome use for you yet.\nImpress me!")
                elseif choice == 2 then
                    if self.flirtcount > 1 or self.failedflirting then
                        cutscene:battlerText(self, "Again you court me,\nbut your words float thin\non your intentions\npuddle-shallow.")
                        self:addMercy(5)
                        cutscene:battlerText(self, "The estate of a fairy\ncannot be shared\nwith mortals\nwhose tongues\nare cracked and dry!")
                    else
                        cutscene:battlerText(self, {
                            "Remember me not\nas a vainglory,",
                            "Though my face, shining\nback both sun and moon\nis brighter and more\nholy than all stars,",
                            "And as such, my beauty\nis more\nof an objective science,\nthat cannot be denied."
                        })
                        self:addMercy(15)
                        cutscene:battlerText(self, "Well said.")
                    end
                elseif choice == 3 then
                    self:addMercy(5)
                    cutscene:battlerText(self, self.disgustingstr)
                elseif choice == 4 then
                    cutscene:battlerText(self, {
                        "The Bluest Flower,\nA disciple of my speech",
                        "Shy to no camera,\nAnd a specimen of",
                        "Elegance and kindness.",
                    })
                    self:addMercy(15)
                    cutscene:battlerText(self, "Should you meet,\nPlease give my regards.")
                end
            elseif self.chatcount > 2 then
                cutscene:text("* (Everyone talked around the watercooler, explicitly about watercoolers!)")
                if self.chatcount == 3 then
                    self:addMercy(12)
                end
            end
        end)
        return
    elseif name == "Dazzle" then
        Game.battle:startActCutscene(function(cutscene)
            local dazzled = false
            battler.sprite.anim_speed = 2
            battler:setAnimation("battle/act", function() -- absolutely horrid, darling
                battler:setAnimation("battle/act_end", function()
                    battler:setAnimation("battle/act", function()
                        battler:setAnimation("battle/act_end", function()
                            battler:setAnimation("battle/act", function()
                                battler:setAnimation("battle/act_end", function()
                                    battler.sprite.anim_speed = 1
                                    battler:setAnimation("battle/idle")
                                end)
                            end)
                        end)
                    end)
                end)
            end)
            Assets.playSound("bell_bounce_short", 1, 1)
            Game.battle.timer:after(10 / 30, function()
                Assets.playSound("bell_bounce_short", 1, 1.1)
            end)
            Game.battle.timer:after(20 / 30, function()
                Assets.playSound("bell_bounce_short", 1, 1.2)
            end)
            Game.battle.timer:after(22 / 30, function()
                for i = 1, 6 do
                    local x, y = battler:getRelativePos()
                    local particle = DazzleParticle(x + 40, y + 20 + MathUtils.randomInt(41))
                    particle.layer = battler.layer - 1
                    Game.battle:addChild(particle)
                end
            end)
            Game.battle.timer:after(29 / 30, function()
                battler.sprite.anim_speed = 1 -- extra measures
                self:addMercy(8)
                dazzled = true
            end)
            cutscene:text("* You DAZZLEd MIZZLE!")
            cutscene:wait(function() return dazzled end)
        end)
        return
    elseif name == "Embezzle" then
        Game.battle:startActCutscene(function(cutscene)
            local susie = Game.battle:getPartyBattler("susie")
            local embezzled = false
            local embezzle_result = ""
            local su_start_x, su_start_y, su_start_layer = susie.x, susie.y, susie.layer
            susie:setSprite("jump_back")
            susie.physics.speed_y = -40
            Assets.playSound("jump")
            Game.battle.timer:after(19 / 30, function()
                local x, y = self:getRelativePos()
                susie:setPosition(x + 20 + susie.width, -100 + susie.height * 2)
                susie.physics.speed_y = 0
                susie.layer = self.layer + 1
                susie:slideToSpeed(susie.x, y - 10 + susie.height * 2, 30, function()
                    Assets.playSound("bump")
                    susie:setSprite("kneel_heal_alt_right")
                    self:shake()
                    susie:shake()
                    embezzle_result = self:embezzle()
                    Game.battle.timer:after(19 / 30, function()
                        susie:setSprite("jump_back")
                        susie.physics.speed_y = -30
                        Assets.stopAndPlaySound("jump")
                    end)
                    Game.battle.timer:after(29 / 30, function()
                        susie.x = su_start_x
                        susie.layer = su_start_layer
                        susie.physics.speed_y = 0
                        susie:slideToSpeed(su_start_x, su_start_y, 30, function()
                            susie:setAnimation("battle/idle")
                            susie:shake()
                            Assets.playSound("bump")
                            embezzled = true
                        end)
                    end)
                end)
            end)
            cutscene:text("* Susie EMBEZZLED an item!")
            cutscene:wait(function() return embezzled end)
            cutscene:text(embezzle_result)
        end)
        return
    elseif name == "Nuzzle" then
        Game.battle:startActCutscene(function(cutscene)
            local ralsei = Game.battle:getPartyBattler("ralsei")
            local nuzzled = false
            local ra_start_x, ra_start_y, ra_start_layer = ralsei.x, ralsei.y, ralsei.layer
            local x, y = self:getRelativePos()
            ralsei:setPosition(x - 40 + ralsei.width, y + 20 + ralsei.height * 2)
            ralsei.layer = self.layer + 1
            ralsei:setAnimation("nuzzle")
            Assets.playSound("magicmarker", 1, 1)
            ralsei.physics.speed_x = 0.1
            Game.battle.timer:after(1, function()
                ralsei.physics.speed_x = 0
            end)
            Game.battle.timer:after(31 / 30, function()
                ralsei:setAnimation("battle/idle")
                ralsei.x = ra_start_x
                ralsei.y = ra_start_y
                ralsei.layer = ra_start_layer
                nuzzled = true
            end)
            cutscene:text("* Ralsei NUZZLEd MISS MIZZLE!")
            cutscene:wait(function() return nuzzled end)
            self.tiredcount = self.tiredcount + 1
            if self.tiredcount >= 2 then
                self:setTired(true)
            end
            self:addMercy(8)
            if self.tiredcount == 1 then
                cutscene:text("* MISS MIZZLE got a little bit tired...!")
            elseif self.tiredcount > 1 then
                cutscene:text("* MISS MIZZLE became TIRED!")
            end
        end)
        return
    elseif name == "Standard" then
        return self:onShortAct(battler, name)
    end
end

function Holywatercooler:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(4)
            local text = {
                "* Susie face-crushes a cup!!",
                "* Susie puts cups on Ralsei!",
                "* Susie puts cups on Kris's eyes!"
            }
            if self.amimissmizzle then
                text = {
                    "* Susie gargles loudly!",
                    "* Susie breaks a wet floor sign!",
                    "* Susie snores while awake!"
                }
            end
            return TableUtils.pick(text)
        elseif battler.chara.id == "ralsei" then
            self:addMercy(4)
            local text = {
                "* Ralsei absorbs trace calcium!",
                "* Ralsei cleans Susie's spill!!",
                "* Ralsei labels everyone's cups!!"
            }
            if self.amimissmizzle then
                text = {
                    "* Ralsei sips politely!",
                    "* Ralsei puts a wet floor sign!",
                    "* Ralsei makes toothpaste!!!"
                }
            end
            return TableUtils.pick(text)
        else
            return "* " .. battler.chara:getName() .. " straightened the\ndummy's hat."
        end
    end
end

function Holywatercooler:isXActionShort(battler)
    return true
end

function Holywatercooler:embezzle(battler)
    local result = ""
    if self.havestolenbefore then
        Assets.playSound("ui_cant_select")
        result = "* But, there was nothing to steal!"
    elseif Game.inventory:isFull("items", true) then
        Assets.playSound("ui_cant_select")
        result = "* But, your items are full!"
    elseif MathUtils.randomInt(101) < 65 then
        Assets.playSound("ui_cant_select")
        result = "* But, she failed!"
    else
        Assets.playSound("item")
        self.havestolenbefore = true
        result = "* Stole BitterTear!"
        Game.inventory:addItem("bittertear")
    end
    self:addMercy(8)
    return result
end

function Holywatercooler:onTurnEnd()
    self.gothurtlastturn = false
end

function Holywatercooler:onHurt(damage, battler)
    self.gothurtlastturn = true
	super.onHurt(self, damage, battler)
end

function Holywatercooler:getNextWaves()
    if not self.amimissmizzle then
        return --{ "miss_mizzle/rain" }
    else
        return --{ "miss_mizzle/holywaterc" }
    end
end

function Holywatercooler:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.acttalked then
        self.acttalked = false
        if self.amimissmizzle or self.mercy < 60 then -- do not skip if there's right conditions for mercy transformation
            return nil
        end
    end

    if not self.amimissmizzle and self.mercy >= 60 then
        self.turnintomizzle = 1
        return {
            "Ah! What is this?\nThe chamber can\nno longer hold me.",
            "It seems your affection\nhas caused some change\nin my form...",
            "Ah, it's breaking!"
        }
    elseif self.gothurtlastturn and not self.amimissmizzle then
        self.violenceturn = self.violenceturn + 1
        if self.violenceturn == 1 then
            return {
                "Oh, you brutes!\nYou scoundrels!",
                "Those who seek to\nconquer hearts by\nforce shall find no\npure tincture,",
                "But instead a bitter\npoison, of gnashing\nteeth and regret."
            }
        elseif self.violenceturn == 2 then
            return {
                "What? You treat me\nlike an egg, that\nyou should break me,",
                "To reveal some hidden\nbeauty in gold and\nsoftened ivory.",
                "Nay, for love is\nmade of eggshells,",
                "And should your love\nbe true, you would\nalready know what\nlies inside."
            }
        elseif self.violenceturn == 3 then
            return self.disgustingstr
        elseif self.violenceturn == 4 then
            self.turnintomizzle = 1
            return {
                "What have you done?\nYou have broken my\nchamber!",
                "Now I will seem as\nall the others...",
                "Oh, young soldiers,\nhow cruel you are,\nthat in your quest\nto make me yours,",
                "You would reduce\nme to this terrible\nstate...",
                "...\nGoodbye..."
            }
        end
    elseif not self.amimissmizzle then
        if Game.battle.turn_count == 1 or TableUtils.pick({ 0, 1, 2, 3, 4 }) == 0 then
            return "Buble"
        else
            return "B" .. TableUtils.pick({ "a", "e", "i", "o", "u", "u", "oo" }) .. "b" .. TableUtils.pick({ "i", "l" }) .. "e"
        end
    else
        return "Glory, glory."
    end
end

function Holywatercooler:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if MathUtils.random(100) < 4 then
        if not self.amimissmizzle then
            return "* Smells like water with holes in it."
        else
            return "* Smells like a rainstorm."
        end
    end

    if not self.amimissmizzle then
        return super.getEncounterText(self)
    else
        return TableUtils.pick(self.text_missmizzle)
    end
end

function Holywatercooler:defeat(reason, violent)
    self.id = "miss_mizzle"
    super.defeat(self, reason, violent)
end

function Holywatercooler:missMizzleSetup()
    self:setActor("miss_mizzle")
    self:setAnimation("alarm")
    self.name = "Miss Mizzle"
    self:removeAct("Flirt")
    self:removeAct("BegForMercy")
    self:removeAct("Chat")
    self:registerAct("Dazzle", "???")
    self:registerAct("Embezzle", "Chance\nto steal\nitem", { "susie" })
    self:registerAct("Nuzzle", "???", { "ralsei" })
end

function Holywatercooler:update()
    super.update(self)

    if self.transformationcon > 0 then
        self.siner = self.siner + 0.16666666666666666 * DTMULT
    else
        self.siner = self.siner + (1 / 6) * DTMULT
    end

    if self.amimissmizzle then
        self.sprite.y = self.sprite.init_y + math.sin(self.siner * 0.5) * 5 / 2
    end

    if self.transformationcon == 1 then
        if self.transformation_sprite_cooler == nil then
            self.sprite.visible = false
            self.overlay_sprite.visible = false
            local x, y = self:getRelativePos()
            self.transformation_sprite_cooler = Sprite("battle/enemies/holywatercooler/idle", x + 18, y + 44)
            self.transformation_sprite_cooler:setOriginExact(9, 22)
            self.transformation_sprite_cooler:setScale(2)
            self.transformation_sprite_cooler.layer = self.layer + 1
            Game.battle:addChild(self.transformation_sprite_cooler)
            self.transformation_sprite_cooler.highlight = self.transformation_sprite_cooler:addFX(ColorMaskFX())
            self.transformation_sprite_cooler.highlight.amount = 0
        end
        self.transformationtimer = self.transformationtimer + DTMULT
        if self.transformationtimer < 30 then
            if not self.transformation_sound:isPlaying() then
                self.transformation_sound:play()
            end
            --[[d = instance_create(x + 18, y + 45, obj_rouxls_power_up_orb)
            d.direction = irandom(360)
            d.depth = depth + 1
            d.image_blend = image_blend
            d.lifetime = 12
            d.parenttarget = id
            d.distance_multiplier = 1.4]]
        end
        self.transformation_sprite_cooler.highlight.amount = MathUtils.lerp(0, 1, self.transformationtimer / 40)
        if self.transformationtimer >= 40 then
            self.transformationcon = 2
            self.transformationtimer = 0
            Assets.playSound("motor_ghost")
        end
    elseif self.transformationcon == 2 then
        if self.transformation_sprite_mizzle == nil then
            local x, y = self:getRelativePos()
            self.transformation_sprite_mizzle = Sprite("battle/enemies/miss_mizzle/idle", x + 22, y + 40)
            self.transformation_sprite_mizzle:setOriginExact(30, 49)
            self.transformation_sprite_mizzle:setScale(2)
            self.transformation_sprite_mizzle.layer = self.layer + 2
            Game.battle:addChild(self.transformation_sprite_mizzle)
            self.transformation_sprite_mizzle.highlight = self.transformation_sprite_mizzle:addFX(ColorMaskFX())
            self.transformation_sprite_mizzle.highlight.amount = 1
        end
        self.transformationtimer = self.transformationtimer + DTMULT
        local scale
        if self.transformationtimer <= 20 then
            scale = MathUtils.lerp(2, 0, self.transformationtimer / 20)
        else
            scale = 0
        end
        local scale2 = MathUtils.lerp(0, 2, self.transformationtimer / 30)
        if self.transformationtimer >= 30 then
            self.transformationcon = 3
            self.transformationtimer = 0
        end
        self.transformation_sprite_cooler.scale_x = scale
        self.transformation_sprite_cooler.scale_y = scale
        self.transformation_sprite_mizzle.scale_x = scale2
        self.transformation_sprite_mizzle.scale_y = scale2
        self.transformation_sprite_mizzle:setFrame(1 + math.floor(self.siner))
    elseif self.transformationcon == 3 then
        self.transformationtimer = self.transformationtimer + DTMULT
        self.transformation_sprite_mizzle.highlight.amount = MathUtils.lerp(1, 0, self.transformationtimer / 30)
        self.transformation_sprite_mizzle:setFrame(1 + math.floor(self.siner))
        if self.transformationtimer >= 30 then
            self.transformationcon = 0
            self.transformationtimer = 0
            self.turnintomizzle = false
            self.amimissmizzle = true
            self.siner = 0
            self.transformation_sprite_cooler:remove()
            self.transformation_sprite_mizzle:remove()
            self.transformation_sprite_cooler = nil
            self.transformation_sprite_mizzle = nil
            self:missMizzleSetup()
        end
    end
end

return Holywatercooler