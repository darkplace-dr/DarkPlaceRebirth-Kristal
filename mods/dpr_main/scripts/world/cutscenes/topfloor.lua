---@type table<string,fun(cutscene:WorldCutscene, event?: Event|NPC)>
return{
    sign1 = function(cutscene)
        local hero = cutscene:getCharacter("hero")

        cutscene:text("* (It's a sign.)")
        if not Game:getFlag("topfloor_canreadsigns", false) then
            if hero then
                cutscene:showNametag("Hero")
                cutscene:text("* Hmm...[wait:10] the letters are a bit smudged,[wait:5] but I think I can read this.", "neutral_closed_b", "hero")
                cutscene:hideNametag()
                Game:setFlag("topfloor_canreadsigns", true)
            end
        end
        if hero then
            cutscene:text("[voice:hero]* Notice:")
            cutscene:text("[voice:hero]* Due to a lack of proper infrastructure...")
            cutscene:text("[voice:hero]* ...we highly urge visitors to tread this floor with caution.")
            cutscene:text("[voice:hero]* [color:yellow]Climbing gear[color:reset] is recommended for anyone who wishes to not take dangerous detours.")
            cutscene:text("[voice:hero]* - Sincerely,[wait:5] Management")
            cutscene:showNametag("Hero")
            cutscene:text("* Well that's not very reassuring.", "really", "hero")
        else
            if Game.party[1].id == "dess" then
                cutscene:showNametag("Dess")
                cutscene:text("* i cant read ts lmao", "condescending", "dess")
                cutscene:hideNametag()
            else
                cutscene:text("* (Unfortunately,[wait:5] it's written in a font you can't read.)")
            end
        end
    end,

    ambush = function(cutscene)
        local hero = cutscene:getCharacter("hero")
        local susie = cutscene:getCharacter("susie")
        local voidspawn = cutscene:getEvent(39)

        cutscene:detachFollowers()
        cutscene:walkTo(Game.world.player, 260, 360, 1, "right")
        if #Game.party == 2 then
            cutscene:walkTo(Game.world.followers[1], 260 - 40, 360, 1, "right")
        elseif #Game.party == 3 then
            cutscene:walkTo(Game.world.followers[1], 260 - 40, 360 - 20, 1, "right")
            cutscene:walkTo(Game.world.followers[2], 260 - 40, 360 + 20, 1, "right")
        end
        cutscene:wait(1.5)

        if susie then
            cutscene:showNametag("Susie")
            cutscene:text("* Y'know,[wait:5] these windows really give me the creeps...", "suspicious", "susie")
            susie:setFacing("up")
            cutscene:text("* I mean,[wait:5] the way they just stare at us is creepy...", "sus_nervous", "susie")
            cutscene:hideNametag()
        end

        Game.world.music:fade(0, 1)
        cutscene:wait(0.5)

		Assets.stopAndPlaySound("spearappear_choppy", 1, 0.66)
		Assets.stopAndPlaySound("giygastalk", 0.7, 1.2)
        voidspawn.sprite:setEyeState("FOLLOWING")
        voidspawn.sprite:setBodyState("DARKTRAIL")
        voidspawn.sprite.trail_speed = 0.5
        voidspawn.sprite.trail_dir = math.rad(270)

        cutscene:wait(0.25)
        Game.world.player:alert()
        cutscene:wait(20/30)

        if hero then
            cutscene:showNametag("Hero")
            cutscene:text("* Uh,[wait:5] guys...", "shocked", "hero")
            cutscene:hideNametag()
        end
        if susie then
            cutscene:showNametag("Susie")
            cutscene:text("[noskip]* Wait, huh-", "sad", "susie", {auto = true})
            cutscene:hideNametag()
            susie:setFacing("right")
            cutscene:wait(0.2)
            susie:setSprite("shock_right")
            susie:shake(5)
            Assets.playSound("sussurprise")
        end

        voidspawn.sprite:setBodyState("CHASETRAIL")
        voidspawn.sprite.trail_speed = 1
        cutscene:wait(0.25)
        cutscene:wait(cutscene:slideTo(voidspawn, Game.world.player.x + 70, Game.world.player.y - 20, 0.75, "in-cubic"))
        Assets.playSound("tensionhorn")
        cutscene:wait(10/30)
        Assets.playSound("tensionhorn", 1, 1.1)
        cutscene:wait(24/40)
        local encounter = cutscene:startEncounter("voidspawn_ambush", true, {{"voidspawn", voidspawn}})

        cutscene:wait(1)

        for _, member in ipairs(Game.party) do
            cutscene:getCharacter(member.id):resetSprite()
            cutscene:getCharacter(member.id):shake(5)
        end
        Assets.playSound("equip")
        cutscene:wait(0.5)

        if susie then
            cutscene:showNametag("Susie")
            cutscene:text("* What...", "angry_down", "susie")
            cutscene:text("* What the hell WAS that?!", "angry_unsure", "susie")
            if hero then
                cutscene:showNametag("Hero")
                cutscene:text("* Your guess is as good as mine.", "neutral_opened", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* It...[wait:5] it was so powerful.", "angry_c_alt", "susie")
                cutscene:text("* Don't tell me there's MORE of these things up here!", "angry_b", "susie")
                cutscene:showNametag("Hero")
                cutscene:text("* That's a very likely possibility...", "pout", "hero")
                cutscene:text("* It may be wise to [color:yellow]fall back for now,[wait:5] and return once we're stronger[color:reset].", "annoyed_b", "hero")
                cutscene:showNametag("Susie")
                cutscene:text("* Yeah,[wait:5] that might be the best course of action...", "annoyed_down", "susie")
            else
                cutscene:text("* It...[wait:5] it was so powerful.", "angry_c_alt", "susie")
                cutscene:text("* Don't tell me there's MORE of these things up here!", "angry_b", "susie")
                cutscene:text("* Maybe we should [color:yellow]head back down and come back when we've gotten stronger[color:reset]...", "annoyed_down", "susie")
            end
        elseif hero then
            cutscene:showNametag("Hero")
            cutscene:text("* Such a powerful foe...", "shade", "hero")
            cutscene:text("* I've got a feeling we'll be seeing more of those guys soon...", "really", "hero")
            cutscene:text("* It may be wise to [color:yellow]fall back for now,[wait:5] and return once we're better prepared[color:reset].", "annoyed_b", "hero")
        end
        cutscene:hideNametag()

        Game.world.music:fade(1, 1)
        cutscene:interpolateFollowers()
        cutscene:attachFollowers()
    end
}
