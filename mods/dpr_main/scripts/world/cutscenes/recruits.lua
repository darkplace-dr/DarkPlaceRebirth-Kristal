---@type table<string,fun(cutscene:WorldCutscene, event?: Event|NPC)>
local cyber = {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    shuttah = function(cutscene, event)
        cutscene:text("* Ooo la la.[wait:5] I've been taking photos of the studio...")
		cutscene:text("* But it's been so long,[wait:5] I'm getting sick of repeating patterns!")
		cutscene:text("* Oh,[wait:5] if only someone would agree to pose for me...")
		local dowepose = cutscene:choicer({"Photo pose!", "Nothing"})
		if dowepose == 1 then
			cutscene:detachFollowers()
			cutscene:panTo(640, 640, 1)
			if #Game.party == 1 then -- ehh didn't find a better way to do that lol
				Game.world.player:walkTo(640, 680, 1, "down")
			elseif #Game.party == 2 then
				Game.world.player:walkTo(560, 680, 1, "down")
				cutscene:getCharacter(Game.party[2].id):walkTo(720, 680, 1, "down")
			elseif #Game.party == 3 then
				Game.world.player:walkTo(540, 680, 1, "down")
				cutscene:getCharacter(Game.party[2].id):walkTo(640, 680, 1, "down")
				cutscene:getCharacter(Game.party[3].id):walkTo(740, 680, 1, "down")
			elseif #Game.party == 4 then
				Game.world.player:walkTo(520, 680, 1, "down")
				cutscene:getCharacter(Game.party[2].id):walkTo(600, 680, 1, "down")
				cutscene:getCharacter(Game.party[3].id):walkTo(680, 680, 1, "down")
				cutscene:getCharacter(Game.party[4].id):walkTo(760, 680, 1, "down")
			end
			cutscene:wait(1.5)
			if cutscene:getCharacter("kris") then cutscene:getCharacter("kris"):setSprite("pose") end
			if cutscene:getCharacter("susie") then cutscene:getCharacter("susie"):setSprite("pose") end
			if cutscene:getCharacter("ralsei") then cutscene:getCharacter("ralsei"):setSprite("pose") end
            --if cutscene:getCharacter("noelle") then cutscene:getCharacter("noelle"):setSprite() end -- no cool pose :(
            if cutscene:getCharacter("dess") then
				local poses = {"beatbox", "bup", "dab", "sonic_adventure"}
				cutscene:getCharacter("dess"):setSprite(TableUtils.pick(poses))
			end
			if cutscene:getCharacter("jamm") and not Game:getFlag("dungeonkiller") then
				local poses = {"bs_win", "bt"}
				if Game:getFlag("jamm_closure") then
					poses = {"ghost_bs", "bt"}
				end
				cutscene:getCharacter("jamm"):setSprite(TableUtils.pick(poses))
			end
			if cutscene:getCharacter("jammarcy") then cutscene:getCharacter("jammarcy"):setSprite("bs_win") end
			if cutscene:getCharacter("ceroba_dw") then cutscene:getCharacter("ceroba_dw"):setSprite("cool") end

			event:setAnimation("pose")
			cutscene:wait(1.2)
			Assets.playSound("camera_flash")
			cutscene:wait(cutscene:fadeOut(0.15, {color = {1, 1, 1}}))
			cutscene:wait(cutscene:fadeIn(0.15, {color = {1, 1, 1}}))
			cutscene:wait(0.5)
			event:setAnimation("posereturn", function() event:setAnimation("idle") end)
			for _,pm in ipairs(Game.party) do
        		local chara = Game.world:getCharacter(pm.actor.id)
            	if chara then chara:resetSprite() end
    		end
			cutscene:wait(0.5)
			cutscene:attachCamera(1)
			cutscene:interpolateFollowers()
			cutscene:attachFollowers()
			cutscene:wait(1)
		end
    end,
}

return cyber