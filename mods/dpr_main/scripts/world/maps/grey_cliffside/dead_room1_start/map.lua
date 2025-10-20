---@class Map.grey_cliffside/dead_room1_start : Map
local map, super = Class(Map)

function map:onEnter()
    super.onEnter(self)

    --[spacing:-10][font:wingdings, 18]

    function createShakyText(text, x, y)
        local textobj = shakytextobject(text, x, y)
        textobj.layer = 2
        Game.world:addChild(textobj)
        return textobj
    end


    self.text_free = createShakyText("[shake:0.6][color:red]FREE", 140, 80)
    self.text_the = createShakyText("[shake:0.6][color:red]THE", 190, 40)
    self.text_roaring = createShakyText("[shake:0.6][color:red]ROARING", 370, 40)
    self.text_dragon = createShakyText("[shake:0.6][color:red]DRAGON", 400, 80)


    self.textobjjj = shakytextobject("[shake:0.6][color:yellow] -- CONTROLS --\n"..Input.getText("quest").. (Input.usingGamepad() and "" or " ").. " - Quest Menu\n"..Input.getText("menu").. (Input.usingGamepad() and "" or " ").. " or [CTRL] - Menu\n"..Input.getText("confirm").. (Input.usingGamepad() and "" or " ").. " or [ENTER] - Confirm\n"..Input.getText("cancel").. (Input.usingGamepad() and "" or " ").. " or [SHIFT] - Cancel", 20, 480)
    self.textobjjj.layer = 2
    Game.world:addChild(self.textobjjj)

    self.textobjjj:addFX(OutlineFX(COLORS.black))

    --[[if Game:getFlag("tutor_free_crystal") then
    else
        if (Game:getFlag("FUN") % 2 == 0) then -- suzy gets all even fun values
    	    local suzy = Game.world:spawnNPC("suzy_lw", 300, 180)
            suzy.alpha = 0.2
	    suzy.sprite:addFX(ColorMaskFX({1, 1, 1}))

        else -- and susie gets all odd fun values (swap them if you want)
            Game:rollShiny("susie")
    	    local susie = Game.world:spawnNPC("susie", 315, 180)
	    susie:setSprite("shock_right")
            susie.alpha = 0.2
	    susie.sprite:addFX(ColorMaskFX({1, 1, 1}))

        end
    end]]

    --local dragon = Game.world:spawnNPC("", 300, 180)
end

function map:onExit()
    super.onExit(self)
    if Game:getFlag("met_stranger") == 1 then
        Game.world:startCutscene("cliffside", "stranger_item")
    end
end

function map:update()
    super.update(self)
    local download = Game.world:getCharacter("download")

    if download then
        if download.x < 0 then
            download:setScale(-2, 2)
            download.x = 1
            download.physics.speed_x = 1
            download.x = 1
        elseif download.x > 145 then
            download:setScale(2, 2)
            download.x = 144
            download.physics.speed_x = -1
            download.x = 144
        end
    elseif Game:getFlag("tutor_free_crystal", false) then
        Game.world:spawnNPC("download", 50, 240)
        local download = Game.world:getCharacter("download")
            download.physics.speed_x = -1
    end

end

return map