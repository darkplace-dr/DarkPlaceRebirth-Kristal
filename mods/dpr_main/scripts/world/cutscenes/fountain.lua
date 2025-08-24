
-- WIP cutscene, polish later
---@param cutscene WorldCutscene
return function(cutscene)
    local fountain = Game.world:getEvent("darkfountain")
    Kristal.hideBorder(1)
    
    local dialog = DialogueText({"bepis"}, 100, 80, (SCREEN_WIDTH - 100 * 2) + 14)
    dialog:setLayer(WORLD_LAYERS["textbox"])
    dialog:addFunction("look", function(self, chara, dir)
        cutscene:look(chara, dir)
    end)
    local function showDialog(text)
        local style = "[noskip][speed:0.3][voice:nil]"
        local _text
        if type(text) == "string" then
            _text = style .. text
        else
            _text = Utils.copy(text)
            for i, v in ipairs(_text) do
                _text[i] = style .. v
            end
        end
        
        dialog.visible = true
        dialog:setText(_text)
        cutscene:wait(function() return dialog:isDone() end)
        dialog.visible = false
    end
    Game.world:addChild(dialog)
    
    cutscene:detachFollowers()
    
    cutscene:walkToSpeed(Game.world.player, "sealready_1", 1, "up", true)
    if Game.party[2] then
        cutscene:walkToSpeed(Game.world.followers[1], "sealready_2", 1.5, "up", false)
    end
    if Game.party[3] then
        cutscene:walkToSpeed(Game.world.followers[2], "sealready_3", 1.5, "up", false)
    end

    if not Game:getFlag("used_hub_fountain") then
        if not Game:getFlag("fountainInteracted") then
            Game:setFlag("fountainInteracted", true)
            if Game:isDessMode() then
                showDialog("[voice:dess][speed:0.5]wow pretty fountain")
                showDialog("[voice:dess][speed:0.5]hey maybe if i seal it i can go to the light world")
                showDialog("[voice:dess][speed:0.5]i'll finally be able to touch grass")
            end
    
            if cutscene:getCharacter("susie") then
                showDialog("[voice:susie][speed:0.5]So this is this world's Dark Fountain?")
                showDialog("[voice:susie][speed:0.5]Something about this feels...")
                showDialog("[voice:susie][speed:0.5]Different from the others.")
                showDialog("[voice:susie][speed:0.5]Is this a fountain of pure darkness?")
                if #Game.party > 1 then
                    showDialog("[voice:susie][speed:0.5]Something tells me we'll not be able to properly seal it.")
                else
                    showDialog("[voice:susie][speed:0.5]Something tells me I'll not be able to properly seal it.")
                end
                if Game.party[1].id ~= "kris" then
                    showDialog("[voice:susie][speed:0.5]Actually...")
                    if Game.party[1].id == "susie" then
                        showDialog("[voice:susie][speed:0.5]Can I even seal a Dark Fountain?")
                    else
                        showDialog("[voice:susie][speed:0.5]Can you even seal a Dark Fountain,[wait:5] "..Game.party[1].name.."?")
                    end
                else
                    showDialog("[voice:susie][speed:0.5]Well, Kris.[wait:10] Should we at least try?")
                end
            end
        end
        showDialog("[speed:0.8](Will you attempt to seal the Dark Fountain?)")

        local seal = cutscene:choicer({"Yes", "No"})

        if seal == 1 then
            if Game:isDessMode() then
                showDialog("[voice:dess][speed:0.5]check this fuckin shit out")
            end
            
            if cutscene:getCharacter("susie") then
                if Game.party[1].id == "susie" then
                    showDialog("[voice:susie][speed:0.5]Well,[wait:5] here goes nothing...")
                elseif Game.party[1].id == "hero" then
                    showDialog("[voice:hero][speed:0.5]I should be able to.")
                    showDialog("[voice:hero][speed:0.5]If not,[wait:5] well...")
                    showDialog("[voice:hero][speed:0.5]Let's not think about it.")
                    showDialog("[voice:susie][speed:0.5]Right...")
                    showDialog("[voice:hero][speed:0.5]Okay,[wait:5] here goes nothing...")
                elseif Game.party[1].id == "dess" then
                    showDialog("[voice:dess][speed:0.5]i mean yeah of course obviously i can")
                    showDialog("[voice:dess][speed:0.5]check this fuckin shit out")
                elseif Game.party[1].id == "kris" then
                    showDialog("[voice:susie][speed:0.5]Alright,[wait:5] you know what to do.")
                    showDialog("[voice:susie][speed:0.5]Let's go home.")
                end
            end
            cutscene:text("[voice:nil][speed:0.5][noskip]* (It was as if your very SOUL was glowing...)", nil, nil, {top = true})

            Game.world.music:stop()
    
            local leader = Game.world.player
            local soul = Game.world:spawnObject(UsefountainSoul(leader.x, leader.y - leader.height + 10), "ui")
            soul.color = Game:getPartyMember(Game.party[1].id).soul_color or {1,0,0}
            cutscene:playSound("great_shine")
            cutscene:wait(1)
    
            Game.world.music:play("deltarune/usefountain", 1)
            Game.world.music.source:setLooping(false)
    
            cutscene:wait(50/30)
            fountain.adjust = 1 -- fade out color
            Game.world.timer:tween(170/30, soul, {y = 160})
            --
                -- fade out the depth texture
                Game.world.timer:during(170/30, function()
                    --fountain.eyebody = fountain.eyebody - (fountain.eyebody * (1 - 0.98) * DTMULT)
                end)
            --]]
            cutscene:wait(170/30)
            --fountain.adjust = 2 -- freeze in place and fade to white
            cutscene:wait(3)
            
            can_skip = false
            if skip_hint then skip_hint:remove() end
            cutscene:playSound("revival")
            soul:shine()
    
    
            local flash_parts = {}
            local flash_part_total = 12
            local flash_part_grow_factor = 0.5
            for i = 1, flash_part_total - 1 do
                -- width is 1px for better scaling
                local part = Rectangle(SCREEN_WIDTH / 2, 0, 1, SCREEN_HEIGHT)
                part:setOrigin(0.5, 0)
                part.layer = soul.layer - i
                part:setColor(1, 1, 1, -(i / flash_part_total))
                part.graphics.fade = flash_part_grow_factor / 16
                part.graphics.fade_to = math.huge
                part.scale_x = i*i * 2
                part.graphics.grow_x = flash_part_grow_factor*i * 2
                table.insert(flash_parts, part)
                Game.world:addChild(part)
            end
    
            local function fade(step, color)
                local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                rect:setParallax(0, 0)
                rect:setColor(color)
                rect.layer = soul.layer + 1
                rect.alpha = 0
                rect.graphics.fade = step
                rect.graphics.fade_to = 1
                Game.world:addChild(rect)
                cutscene:wait(1 / step / 30)
            end
    
            cutscene:wait(50/30)
            fade(0.02, {1, 1, 1})
            cutscene:wait(20/30)
            cutscene:playSound("laviver")
            cutscene:wait(cutscene:fadeOut(used_fountain_once and 2 or 100/30, {color = {0, 0, 0}}))
            cutscene:wait(1)
    
            cutscene:fadeIn(1, {color = {1, 1, 1}})
            Game:setFlag("used_hub_fountain", true)
            cutscene:after(Game:swapIntoMod("dpr_light"))
        else
            if Game:isDessMode() then
                showDialog("[voice:dess][speed:0.5]actually maybe i should stay here for just a bit longer")
                showDialog("[voice:dess][speed:0.5]there might be more CONTENT:tm: to discover")
            end

            if cutscene:getCharacter("susie") then
                showDialog("[voice:susie][speed:0.5]Maybe it's better to wait until later...")
                showDialog("[voice:susie][speed:0.5]There's probably so much more to explore in this Dark World.")
            end

            Kristal.showBorder(1)
            cutscene:interpolateFollowers()
            cutscene:attachFollowers()
        end
    else
        showDialog("[speed:0.8](Do you want to return to the Light World?)")
    
        local seal = cutscene:choicer({"Yes", "No"})
    
        if seal == 1 then 
    
            -- If we've done the fountain sealing cutscene before, we can skip it by pressing C+D.
            local skip_hint = nil
            local can_skip = false
            if Game:getFlag("used_hub_fountain") == true then
                skip_hint = Text("Hold C+D to skip",
                    0, SCREEN_HEIGHT/2+50, SCREEN_WIDTH, SCREEN_HEIGHT,
                    {
                        align = "center",
                        font = "plain"
                    }
                )
                skip_hint.alpha = 0.05
                skip_hint:setParallax(0, 0)
                skip_hint:setLayer(WORLD_LAYERS["ui"])
                Game.world:addChild(skip_hint)
                can_skip = true
    
                cutscene:during(function()
                    if not can_skip then return false end
                    if Input.down("c") and Input.down("d") then
                        Input.clear("c")
                        Input.clear("d")
    
                        Assets.playSound("item", 0.1, 1.2)
                        Game.world.music:stop()
                        cutscene:fadeOut(1/30, {color = {0,0,0}})
                        cutscene:wait(1/30)
                        
                        cutscene:after(function()
                            Game.world.timer:after(1, function() Game:swapIntoMod("dpr_light") end) end)
                        Game.world:stopCutscene()
                    end
                end)
    
    
            end
    
    
            Game.world.music:stop()
    
            local leader = Game.world.player
            local soul = Game.world:spawnObject(UsefountainSoul(leader.x, leader.y - leader.height + 10), "ui")
            soul.color = Game:getPartyMember(Game.party[1].id).soul_color or {1,0,0}
            cutscene:playSound("great_shine")
            cutscene:wait(1)
    
            Game.world.music:play("deltarune/usefountain", 1)
            Game.world.music.source:setLooping(false)
    
            cutscene:wait(50/30)
            fountain.adjust = 1 -- fade out color
            Game.world.timer:tween(170/30, soul, {y = 160})
            --
                -- fade out the depth texture
                Game.world.timer:during(170/30, function()
                    --fountain.eyebody = fountain.eyebody - (fountain.eyebody * (1 - 0.98) * DTMULT)
                end)
            --]]
            cutscene:wait(170/30)
            --fountain.adjust = 2 -- freeze in place and fade to white
            cutscene:wait(3)
            
            can_skip = false
            if skip_hint then skip_hint:remove() end
            cutscene:playSound("revival")
            soul:shine()
    
    
            local flash_parts = {}
            local flash_part_total = 12
            local flash_part_grow_factor = 0.5
            for i = 1, flash_part_total - 1 do
                -- width is 1px for better scaling
                local part = Rectangle(SCREEN_WIDTH / 2, 0, 1, SCREEN_HEIGHT)
                part:setOrigin(0.5, 0)
                part.layer = soul.layer - i
                part:setColor(1, 1, 1, -(i / flash_part_total))
                part.graphics.fade = flash_part_grow_factor / 16
                part.graphics.fade_to = math.huge
                part.scale_x = i*i * 2
                part.graphics.grow_x = flash_part_grow_factor*i * 2
                table.insert(flash_parts, part)
                Game.world:addChild(part)
            end
    
            local function fade(step, color)
                local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                rect:setParallax(0, 0)
                rect:setColor(color)
                rect.layer = soul.layer + 1
                rect.alpha = 0
                rect.graphics.fade = step
                rect.graphics.fade_to = 1
                Game.world:addChild(rect)
                cutscene:wait(1 / step / 30)
            end
    
            cutscene:wait(50/30)
            fade(0.02, {1, 1, 1})
            cutscene:wait(20/30)
            cutscene:playSound("laviver")
            cutscene:wait(cutscene:fadeOut(used_fountain_once and 2 or 100/30, {color = {0, 0, 0}}))
            cutscene:wait(1)
    
            cutscene:fadeIn(1, {color = {1, 1, 1}})
            Game:setFlag("used_hub_fountain", true)
            cutscene:after(Game:swapIntoMod("dpr_light"))
        else
            Kristal.showBorder(1)
            cutscene:interpolateFollowers()
            cutscene:attachFollowers()
        end
    end

end