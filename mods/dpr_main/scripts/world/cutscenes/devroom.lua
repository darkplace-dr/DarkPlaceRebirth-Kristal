---@type table<string,fun(cutscene:WorldCutscene, event?: Event|NPC)>
local devroom = {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    pc = function(cutscene, event, chara)
        ---@diagnostic disable-next-line: assign-type-mismatch
        local devroom_pc = cutscene:getCharacter("devroom_pc")
        local t_c = "[color:#000099]"

        local function nothingText()
            if love.math.random(1, 10) == 1 then
                devroom_pc:setAnimation("wonka")
                local nothing = Assets.playSound("nothing")
        		Game.world.music:pause()
        		cutscene:text(t_c.."[voice:none][noskip]* [[speed:0.7]You get [wait:10]NOTHING!\n[wait:16]You lose![wait:30]\nGood day,[wait:2] sir!]",
        			{advance = false, wait = false})
        		cutscene:wait(function()
        			return not cutscene.textbox:isTyping() and not nothing:isPlaying()
        		end)
        		Game.world.music:resume()
            else
                devroom_pc:setAnimation("happy")
                cutscene:text(t_c.."* [So you get nothing!]")
           	end
        end

        devroom_pc:setAnimation("happy")
        Assets.stopAndPlaySound("pc_on", 0.5)
        cutscene:text(t_c.."* [The PC is on!]")
        Assets.stopSound("pc_on")
        devroom_pc:setAnimation("on")
        Assets.stopAndPlaySound("pc_enter", 0.5)
        cutscene:text(t_c.."* [What do you want to do?]")

        ::choice::
        local c = cutscene:choicer({"Get Gifts", "What's that?", "Turn off"})

        if c == 1 then
            devroom_pc:setAnimation("happy")
            cutscene:text(t_c.."* [Alright,[wait:2] let's see what we have for you today...]")
            devroom_pc:setAnimation("loading")
            cutscene:text(t_c.."* [speed:0.1][...]")
            if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or love.system.getOS() == "Wii" then
                cutscene:text(t_c.."* [Unfortunately,[wait:2] I cannot check for save files on a "..love.system.getOS().." system.]")
                nothingText()
                goto turnoff
            end

            local gifts = Mod.pc_gifts_data
            local gift_status = Game:getFlag("pc_gifts_status")
            local new_gifts = {}
            for game,data in pairs(gifts) do
                if gift_status[game] then goto continue end

                local kristal, start = game:find("KR_")
                if kristal then
                    if game == "KR_wii_bios"
                        and GeneralUtils:hasWiiBIOS()
                        or GeneralUtils:hasSaveFiles(game:sub(start+1), data.file or nil, data.fused_identify) then
                        table.insert(new_gifts, game)
                    end
                else
                    local files = type(data.file) == "string" and {data.file} or data.file
                    for _,file in ipairs(files) do
                        if GeneralUtils:fileExists((data.prefix_os[love.system.getOS():gsub(" ", "_")] or "").."/"..file)
                            or ((love.system.getOS() == "Linux" and data.prefix_os["Windows"])
                            and GeneralUtils:fileExists(data.prefix_os["Windows"].."/"..file, true, data.wine_steam_appid)) then
                            table.insert(new_gifts, game)
                            break
                        end
                    end
                end

                ::continue::
            end

            if #new_gifts <= 0 then
                devroom_pc:setAnimation("on")
                cutscene:text(t_c.."* [Nope![wait:3] There's nothing new for you!]")
                nothingText()
                goto turnoff
            end
            for i,gift in ipairs(new_gifts) do
                local kristal, start = gift:find("KR_")
                local game_name = gifts[gift].name
                if not game_name then
                    if gift == "KR_wilter_boss_fight" then
                        game_name = "Wilter's Wonderland"
                    else
                        game_name = kristal and StringUtils.titleCase(gift:sub(start+1):gsub("_", " ")) or gift
                    end
                end
                local item
                local item_name
                local party
                local party_name
                if gifts[gift].item_id then
                    item = Registry.createItem(gifts[gift].item_id)
                    item_name = item:getName()
                elseif gifts[gift].party_id then
                    party = Registry.createPartyMember(gifts[gift].party_id)
                    party_name = party:getName()
                end
                devroom_pc:setAnimation("happy")
                cutscene:text(t_c.."* [Seems like you have played [color:yellow]"..game_name..t_c.."!]")
                devroom_pc:setAnimation("on")
                if item then
                    cutscene:text(t_c.."* [A gift is registered for playing this game![wait:3]\nHere's your [color:yellow]"..item_name..t_c.."!]")
                    if Game.inventory:addItem(item) then
                        if item.id == "egg" then
                            Assets.stopAndPlaySound("egg")
                        else
                            Assets.stopAndPlaySound("item")
                        end
                        gift_status[gift] = true
                        cutscene:text("* You got the "..item_name..".")
                        if i < #new_gifts then
                            devroom_pc:setAnimation("happy")
                            cutscene:text(t_c.."* [And we're not done yet!]")
                        end
                    else
                        devroom_pc:setAnimation("oh")
                        cutscene:text(t_c.."* [Oh but your inventory is full!]")
                        nothingText()
                        devroom_pc:setAnimation("happy")
                        cutscene:text(t_c.."* [But no worries,[wait:2] I'll keep your gift with me until you can take it!]")
                        cutscene:text(t_c.."* [So come back soon!]")
                        break
                    end
                elseif party then
                    Game:unlockPartyMember(gifts[gift].party_id)
                    cutscene:text(t_c.."* [A gift is registered for playing this game![wait:3]\nYou unlocked [color:yellow]"..party_name..t_c.."!]")
                    Assets.stopAndPlaySound("charjoined")
                    gift_status[gift] = true
                    Game.world.music:pause()
                    cutscene:text("* "..party_name.." is now selectable in the [color:yellow]PARTY ROOM[color:white].")
                    Game.world.music:resume()
                    Assets.stopSound("charjoined")
                    if i < #new_gifts then
                        devroom_pc:setAnimation("happy")
                        cutscene:text(t_c.."* [And we're not done yet!]")
                    end
                end
            end

            devroom_pc:setAnimation("happy")
            cutscene:text(t_c.."* [That's all for now!]")
            cutscene:text(t_c.."* [Thank you,[wait:2] come again soon!]")

        elseif c == 2 then
            cutscene:text(t_c.."* [You wonder what PC stands for?]")
            cutscene:text(t_c.."* [Yeah,[wait:2] me too.]")
            cutscene:text(t_c.."* [I'm not really a computer nor am I portable so what am I?]")
            cutscene:text(t_c.."* [BUT I can do one cool thing!]")
            cutscene:text(t_c.."* [If you have save data from certain games,[wait:2] I can give you gifts based on that!]")
            cutscene:text(t_c.."* [This can be related to Undertale,[wait:2] Deltarune or anything!]")
            cutscene:text(t_c.."* [Well at least as long as it stores data in your "..(love.system.getOS() == "Windows" and "AppData folder" or "Home directory")..".]")
            cutscene:text(t_c.."* [Do not ask me what an Undertale is,[wait:2] I'm just reading my internal manual.]")
            cutscene:text(t_c.."* [With that out of the way,[wait:2] what do you wanna do?]")

            goto choice
	    end

        ::turnoff::
        devroom_pc:setAnimation("off")
        Assets.stopAndPlaySound("pc_off", 0.5)
        cutscene:text(t_c.."* [The PC is off!]")
    end,
    between1 = function(cutscene, event)
        if love.math.random(1, 100) <= 5 then
            Game.world:mapTransition("floor2/dev/rooms/in_between/in_between", "spawn")
        else
            Game.world:mapTransition("floor2/dev/main_1", "pre_elevator")
        end
    end,
    
    arlee = function(cutscene, npc)
        if npc.interact_count == 1 then
        local arlee = cutscene:getCharacter('arlee')
        cutscene:setSpeaker(arlee)
        cutscene:showNametag("arlee")
        cutscene:text("* its me arlee!")
        cutscene:text("* arlee for you! arlee for everyone!")
        cutscene:text("* arlee for the workers! arlee for the bums!")
        cutscene:text("* arlee for the kids and the teens too!")
        cutscene:text("* acquire an arlee on arleebuybuybuy.neocities.org!!!")
        if cutscene:getCharacter('brenda') then
            cutscene:setSpeaker("brenda")
            cutscene:showNametag("Brenda")
			cutscene:textTagged("*...[wait:5] What.", "shocked", "brenda")
            cutscene:setSpeaker("arlee")
            arlee:setAnimation({"tpose"})
            cutscene:showNametag("arlee")
			cutscene:textTagged("* wait the voices in my head are telling me smth")
            Game.world.music:pause()
            local ominous = Music("AUDIO_DRONE")
            ominous:play()
            cutscene:wait(5)
            ominous:remove()
            Game.world.music:resume()
            arlee:setAnimation({"idle", 0.01, true})
            cutscene:textTagged("* oops! guess we are out of stock!")
            cutscene:textTagged("* come back other day!")
            arlee:setAnimation({"idle", 0.045, true})
            cutscene:hideNametag()
		elseif cutscene:getCharacter("ddelta") then
			cutscene:setSpeaker("ddelta")
            cutscene:showNametag("DDelta")
            cutscene:textTagged("* the world has never been the same since Mr. (Ant) Tenna", "helpme", "ddelta")
            arlee:setAnimation({"tpose"})
            cutscene:setSpeaker("arlee")
            cutscene:showNametag("arlee")
            Game.world.music:pause()
            cutscene:textTagged("* tenna....")
            arlee:setAnimation({"kick", 0.045, true})
            Game.world.music:resume()
            cutscene:textTagged("* tenna is a faker ok? you dont compare me to that fucker")
            arlee:setAnimation({"idle", 0.045, true})
            cutscene:hideNametag()
		elseif cutscene:getCharacter("jamm") then
            cutscene:setSpeaker("jamm")
			cutscene:showNametag("jamm")
            cutscene:textTagged("* Sorry,[wait:5] still paying student loans.", "nervous", "jamm")
            cutscene:setSpeaker("arlee")
			cutscene:showNametag("arlee")
            arlee:setAnimation({"tpose", 0.045, true})
            cutscene:textTagged("* Oh.")
            arlee:setAnimation({"kick", 0.01, true})
            cutscene:textTagged("* well youre losing! losing on the best oppurtunity of your life!")
            arlee:setAnimation({"pose", 0.045, true})
            cutscene:textTagged("* im too good to you anyway")
            arlee:setAnimation({"idle", 0.045, true})
            cutscene:hideNametag()
        end
        cutscene:hideNametag()
    end
    if npc.interact_count == 2 then
        local arlee = cutscene:getCharacter('arlee')
        cutscene:setSpeaker(arlee)
        cutscene:showNametag("arlee")
        arlee:setAnimation({"tpose", 0.045, true})
        cutscene:text("* hey uh could do me a favor rq")
        cutscene:text("* i like lost some parts of myself no big deal")
        cutscene:text("* if you find any can you return it to me? it will be worth it i swear")
        local choicer = cutscene:choicer({"Yes", "No"})
        if choicer == 1 then
           cutscene:text("* awesome! i will be at my evil lair come find me there once you have a star bit")
           cutscene:hideNametag()
           cutscene:slideTo(arlee, arlee.x, arlee.y - 600, 1)
           arlee:setAnimation({"idle", 0.01, true})
           cutscene:wait(4)
           Game:getQuest("stargazer"):unlock()
           Game:setFlag("arlee_quest", true)
        else
            cutscene:text("* Wrong choice.")
            arlee:setAnimation({"idle", 0.045, true})
            cutscene:hideNametag()
        end
    else
        local arlee = cutscene:getCharacter('arlee')
        cutscene:setSpeaker(arlee)
        cutscene:showNametag("arlee")
        arlee:setAnimation({"tpose", 0.045, true})
        cutscene:text("* hey uh could do me a favor rq")
        cutscene:text("* i like lost some parts of myself no big deal")
        cutscene:text("* if you find any can you return it to me? it will be worth it i swear")
        local choicer = cutscene:choicer({"Yes", "No"})
        if choicer == 1 then
           cutscene:text("* awesome! i will be at my evil lair come find me there once you have a star bit")
           cutscene:hideNametag()
           cutscene:slideTo(arlee, arlee.x, arlee.y - 600, 4)
           arlee:setAnimation({"idle", 0.001, true})
           cutscene:wait(4)
           Game:getQuest("stargazer"):unlock()
           Game:setFlag("arlee_quest", true)
           Game:setFlag("star_bits", 0)
        else
            cutscene:text("* Wrong choice.")
            arlee:setAnimation({"idle", 0.045, true})
            cutscene:hideNametag()
        end
    end
    end,
}
return devroom
