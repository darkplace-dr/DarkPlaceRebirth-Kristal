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


    self.textobjjj = shakytextobject("[shake:0.6][color:yellow] -- CONTROLS --\n[Q] - Quest Menu\n[C or CTRL] - Menu\n[Z or ENTER] - Confirm\n[Z or SHIFT] - Cancel", 20, 480)
    self.textobjjj.layer = 2
    Game.world:addChild(self.textobjjj)

    self.textobjjj:addFX(OutlineFX(COLORS.black))

    if (Game:getFlag("FUN") % 2 == 0) then -- suzy gets all even fun values
    	local suzy = Game.world:spawnNPC("suzy_lw", 300, 180)
        suzy.alpha = 0.2
	suzy.sprite:addFX(ColorMaskFX({1, 1, 1}))

    else -- and susie gets all odd fun values (swap them if you want)
    	local susie = Game.world:spawnNPC("susie", 315, 180)
	susie:setSprite("shock_right")
        susie.alpha = 0.2
	susie.sprite:addFX(ColorMaskFX({1, 1, 1}))

    end

    --local dragon = Game.world:spawnNPC("", 300, 180)
end

function map:onExit()
    super.onExit(self)
    if Game:getFlag("met_stranger") == 1 then
        Game.world:startCutscene("cliffside", "stranger_item")
    end
end

return map