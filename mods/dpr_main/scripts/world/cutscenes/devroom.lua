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
            if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
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
                        game_name = kristal and Utils.titleCase(gift:sub(start+1):gsub("_", " ")) or gift
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
    starbeans = function(cutscene, event)
        cutscene:showNametag("Alexa")
		cutscene:text("[voice:alexa]* Oh,[wait:5] hello![wait:5]\n* Welcome to the Starbeans Cafe!")
		if not Game:getFlag("starbeans_first") then
			Game:setFlag("starbeans_first", true)
			for k,v in pairs(Game.party) do -- TODO: rewrite this entire thing lol
				if v.id == "YOU" then
					cutscene:hideNametag()
					cutscene:wait(Game.world.music:fade(0, 0.5))
					cutscene:wait(1)
					Assets.playSound("croak")
					cutscene:wait(1)
					cutscene:wait(Game.world.music:fade(1, 0.5))
					cutscene:wait(1)
					cutscene:showNametag("Alexa")
					cutscene:text("[voice:alexa]* Okay...?")
				elseif v.id == "kris" then
				
				elseif v.id == "susie" then
				
				elseif v.id == "noelle" then
				
				elseif v.id == "dess" then
                    cutscene:showNametag("Dess")
                    cutscene:text("* Holy fuck is that Alexa Greene from hit indie game Deoxynn??????", "wtf", "dess")
                    cutscene:showNametag("Alexa")
					cutscene:text("[voice:alexa]* ... What.")
                    cutscene:showNametag("Dess")
                    cutscene:text("* yeah can I get uhhhhhhhhhhhhhhhh", "calm", "dess")
                    cutscene:showNametag("Dess", {top = true, right = false})
                    -- noskip because fuck you >:]
                    cutscene:text("[noskip]* large double double frappechino mocha extra sugar cappichino with frosting and sprinkles with a cherry on top and a boston cream donut with extra frosting and a chocolate chip muffin and a raisin oatmeal cookie", "kind", "dess", {top = true})
                    cutscene:showNametag("Alexa")
					cutscene:text("[voice:alexa]* ... We serve coffee here,[wait:5] ma'am.")
				elseif v.id == "brenda" then
                    cutscene:showNametag("Brenda")
                    cutscene:text("* Well this is kinda awkward.", "shock", "brenda")
                    cutscene:showNametag("Alexa")
					cutscene:text("[voice:alexa]* Hm?[wait:10]\n* What do you mean?")
                    cutscene:showNametag("Brenda")
                    cutscene:text("* Well I mean I made you kill a bunch of people,[wait:5] remember?", "neutral_side", "brenda")
                    cutscene:showNametag("Alexa")
					cutscene:text("[voice:alexa]* Uh,[wait:5] no????")
                    cutscene:showNametag("Brenda")
                    cutscene:text("* Ah so that's not canon in this mod?[wait:10] Cool.", "neutral", "brenda")
                    cutscene:showNametag("Alexa")
                    cutscene:text("[voice:alexa]* What???")
                    cutscene:text("[voice:alexa]* Are you okay ma'am?")
                    cutscene:showNametag("Brenda")
                    cutscene:text("* I have absolutely zero clue myself.", "grin", "brenda")
                    cutscene:showNametag("Alexa")
                    cutscene:text("[voice:alexa]* Oooookay then.")
				elseif v.id == "noel" then
                                    cutscene:showNametag("Noel")
                                    cutscene:text("* ...", "...", "noel")
                                    local text = "* Holy water please..."
                                    local text2 = "* Hi,[wait:10] there.[wait:10]\n[speed:0.5][voice:susie]* Is [voice:noelle]it [voice:dess]okay [voice:berdly]if [voice:ralsei]I [voice:jamm]just [voice:mario]order [voice:alexa]milk?"  
                                    local speaker = "noel" 
                                    local texts = {"I", "FORGOT", "THAT", "THIS", "WAS", "A", "CAFE"}                                     
                                    local faces = {"excusemebutwhatthefuck", "oh", "loud_2", "c_neutral", "madloud_1"}
                                    cutscene:setTextboxTop(true)
									local function undoMyFuckup(text, text2, speaker, texts, faces) -- SDM what the fuck were you doing here
										local len = string.len(text2)
										local len2 = string.len(text)

										local dif = Noel:findDifferenceIndex(text, text2)

										local fin2 = string.sub(text2, dif, len)

										local currentIndex = 1

										local function nextTag()
											local nextText = texts[currentIndex]
											currentIndex = (currentIndex % #texts) + 1
											return nextText
										end

										-- I feel like there should be a better way to do this.
										local isU = true
										local function toggleCase(text)
											if isU then
												isU = false
												return string.lower(text)
											else
												isU = true
												return string.upper(text)
											end
										end

										cutscene:text(text, "neutral", speaker, {auto = true})

										for i = 1, len2 do
											local rface = faces[math.random(1, #faces)]

											local current = string.sub(text, 1, dif - 1)
											local current2 = string.sub(text, dif, len2 - i)
											if i == len2 then
												cutscene:showNametag("Noel", { top = true, right = false})
												cutscene:text("[instant]"..current.."[stopinstant]"..fin2, "neutral", speaker)
											else
												cutscene:showNametag(nextTag(), { top = true, right = false})
												--I use speed instead of instant because of the funny sound it makes.
												cutscene:text("[speed:30]"..toggleCase(current).."[shake:5]"..current2, rface, speaker, {auto = true})
											end
										end
									end
                                    undoMyFuckup(text, text2, speaker, texts, faces)
                                    cutscene:setTextboxTop(false)
                                    cutscene:showNametag("Alexa")
                                    cutscene:text("[voice:alexa]* Sure-[wait:30]\n* Wait, [wait:10]just milk?")
                                    cutscene:showNametag("Noel")
                                    cutscene:text("* [speed:0.5]Yeah...[wait:5]\n* I don't drink coffee much...", "bruh", "noel")
                                    cutscene:showNametag("Alexa")
                                    cutscene:text("[voice:alexa]* Umm, sure?")
                                    cutscene:showNametag("Noel")
                                    cutscene:text("* oh...[wait:5][face:...]\n[voice:marcy]* Good.", "oh", "noel")
			            cutscene:hideNametag()
                                    Game.world.music:fade(0, 0.25)
                                    cutscene:wait(1)
                                    local milk = Sprite("milk")
                                    Game.world:spawnObject(milk, "above_events")
                                    milk.x = 480
                                    milk.y = 135
                                    Assets.playSound("item", 1, 1)

                                    cutscene:wait(2)
                                    local wobblything = Music("wobblything_loop", 1.5, 1)
		                    cutscene:wait(cutscene:slideTo(milk, 480, 225, 10))
                                    
                                    wobblything:stop()
                                    Game.world.music:fade(1, 0.5)
                                    cutscene:wait(2)
                                    Assets.playSound("boowomp", 1, 1)
                                    milk.x = -100
                                    milk.y = -100
                                    cutscene:wait(2)
                                    cutscene:showNametag("Noel")
                                    cutscene:text("* Good milk.", "bruh", "noel")
			            cutscene:hideNametag()
                                    cutscene:wait(2)
                                    cutscene:text("* Noel either drank the milk or forced it to stop existing.")
                                    
				elseif v.id == "dumbie" then
				
				elseif v.id == "ostarwalker" then
				
				elseif v.id == "berdly" then
				
				elseif v.id == "bor" then
				
				elseif v.id == "robo_susie" then
				
				elseif v.id == "nonyo" then
				
				elseif v.id == "iphone" then
				
				elseif v.id == "frisk2" then
				
				elseif v.id == "alseri" then
				
				elseif v.id == "jamm" then
					if not Game:getFlag("dungeonkiller") then
						cutscene:showNametag("Jamm")
						cutscene:text("* Wait,[wait:5] Alexa?[wait:5]\n* You work here?", "neutral", "jamm")
						cutscene:showNametag("Alexa")
						cutscene:text("[voice:alexa]* Actually,[wait:5] Director,[wait:5] I own this cafe!")
						cutscene:text("[voice:alexa]* Remember how I've been telling you I need more money for stuff?")
						cutscene:showNametag("Jamm")
						cutscene:text("* Vaguely,[wait:5] if anything.", "nervous_left", "jamm")
						cutscene:showNametag("Alexa")
						cutscene:text("[voice:alexa]* Well,[wait:5] it turns out D$ can be converted to Coins!")
						cutscene:showNametag("Jamm")
						cutscene:text("* Good for you,[wait:5] Alexa!", "happy", "jamm")
						cutscene:text("* But...[wait:5]\n* What about this room?", "neutral", "jamm")
						cutscene:showNametag("Alexa")
						cutscene:text("[voice:alexa]* The shopkeeper outside is letting me run the place.")
						cutscene:text("[voice:alexa]* I don't really get how the current model is sustaining money...")
						cutscene:text("[voice:alexa]* But I'm happy as long as I make money from it!")
					else
						cutscene:showNametag("Alexa")
						cutscene:text("[voice:alexa]* Wait,[wait:5] Director,[wait:5] is that you?")
						cutscene:text("[voice:alexa]* Gosh,[wait:5] you look terrible...[wait:5]\n* What the fleck happened?")
						cutscene:showNametag("Jamm")
						cutscene:text("* ...Just get me a brew please.", "shaded_pissed", "jamm")
						cutscene:showNametag("Alexa")
						cutscene:text("[voice:alexa]* R-right...")
					end
				elseif v.id == "mario" then
                    cutscene:showNametag("Mario")
					cutscene:text("* Do you have any spaghetti here?", "main", "mario")
                    cutscene:showNametag("Alexa")
					cutscene:text("[voice:alexa]* Um,[wait:5] no.[wait:5]\n* We only serve coffee.")
                    cutscene:showNametag("Mario")
					cutscene:text("* Where's my spaghetti!?", "main", "mario")
                    cutscene:showNametag("Alexa")
					cutscene:text("[voice:alexa]* I told you we don't have that stuff here!")
				end
			end
			cutscene:showNametag("Alexa")
		end
		if #Game.party == 1 then
			cutscene:text("[voice:alexa]* So![wait:5] How may I blend up your day?")
		else
			cutscene:text("[voice:alexa]* So![wait:5] How may I blend up your days?")
		end
		cutscene:hideNametag()
		local choice = cutscene:choicer({"Blend", "Nevermind"})
		if choice == 1 then
			cutscene:showNametag("Alexa")
			cutscene:text("[voice:alexa]* Sounds good![wait:5]\n* I'll get your blend ready soon!")
			cutscene:text("[voice:alexa]* Oh,[wait:5] but first,[wait:5] I'm required to ask something.")
			cutscene:text("[voice:alexa]* Want me to tell you about our StarB System?")
			cutscene:hideNametag()
			if cutscene:choicer({"Yes", "No need"}) == 1 then
				cutscene:showNametag("Alexa")
				cutscene:text("[voice:alexa]* Okay, here goes...")
				cutscene:text("[voice:alexa]* At Starbeans Cafe,[wait:5] you don't have to pay a cent for a blend!")
				cutscene:text("[voice:alexa]* Instead,[wait:5] you provide the ingredients for them.")
				cutscene:text("[voice:alexa]* ...Well,[wait:5] it's mostly beans,[wait:5] but...")
				cutscene:text("[voice:alexa]* Dig for beans and bring them here,[wait:5] and I'll blend them.")
				cutscene:text("[voice:alexa]* Simple enough,[wait:5] right?")
			end
			cutscene:showNametag("Alexa")
			cutscene:text("[voice:alexa]* So,[wait:5] what'll be your blend today?")
			cutscene:hideNametag()
			
			cutscene:after(function()
				Game.world:openMenu(BlendMenu())
			end)
		end
		cutscene:hideNametag()
    end,
    blend_invfull = function(cutscene, event)
		cutscene:text("* You don't have enough space.\n* (TODO: Make Alexa say this)")
	end,
}
return devroom
