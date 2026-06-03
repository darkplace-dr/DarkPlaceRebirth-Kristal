local RotatingTowerReticleDrawer, super = Class(Object)

function RotatingTowerReticleDrawer:init(cyltower)
    super.init(self)
	self.x, self.y = 0, 0
	self.cyltower = cyltower
end

function RotatingTowerReticleDrawer:draw()
    local player = Game.world.player
	local cyltower = self.cyltower
    if not player.draw_reticle or player.state ~= "CLIMB" then
        return
    end
	love.graphics.push()
    --love.graphics.translate(player.width/2, player.height - 10)

    local found = 0;
    local _alph;

    if (player.jumpchargecon ~= 0) then
        local count = 1;

        for i = 1, #player.charge_times do
            if player.jumpchargetimer > player.charge_times[i] then
                count = i + 1
            end
        end

        local px = 0;
        local py = 0;

        for i = 1, count do
            if (player.facing == "down") then
                py = 0+i;
            end

            if (player.facing == "right") then
                px = 0+i;
            end

            if (player.facing == "up") then
                py = 0-i;
            end

            if (player.facing == "left") then
                px = 0-i;
            end
            local s,o = player:canClimb(px, py)
            if s or o then
                found = i
            end
        end
		local px, py = player:getRelativePos(0, 20)
		if cyltower.appearance == 1 then
			px = px + 40
		end
		local tilex = px / cyltower.tile_width_fine
		local tiley = py / cyltower.tile_height_fine
		if tilex >= cyltower.horizontaltilecount then
			tilex = tilex - cyltower.horizontaltilecount
		end
		if tilex < 0 then
			tilex = tilex + cyltower.horizontaltilecount
		end
        _alph = MathUtils.clamp(player.jumpchargetimer / 14, 0.1, 0.8);
        local angle = 0;
        local xoff = 0;
        local yoff = 0;
		local shiftx = 0
		local shifty = 0

        if (player.facing == "down") then
            angle = 0;
            xoff = -22;
            yoff = 18;
			shifty = 1
        end

        if (player.facing == "right") then
            angle = 90;
            xoff = 18;
            yoff = 22;
			shiftx = 1
        end

        if (player.facing == "up") then
            angle = 180;
            xoff = 22;
            yoff = -18;
			shifty = -1
        end

        if (player.facing == "left") then
            angle = 270;
            xoff = -18;
            yoff = -22;
			shiftx = -1
        end

        -- TODO: Put these colors in the PALETTE
        local col = {200/255, 200/255, 200/255};

        if (found ~= 0) then
            col = {255/255, 200/255, 132/255};
        end
        Draw.setColor(col)
        local frame = MathUtils.wrap(math.floor(Kristal.getTime() * 15), 1,4)
        local w = (player.jumpchargetimer / (player.charge_times[#player.charge_times] or 10)) * (#player.charge_times+1)
		local tile = cyltower.tile_data[cyltower.tm_tileset[1]][math.floor(tilex) + 1]
		local startx = (cyltower.tower_x + tile.x + xoff) - 20
		local starty = py + yoff + 20
		local divisor = 120
		local count = #player.charge_times
        for subsection = 0, count do
            local id, h = "ui/climb/hint_mid", 20
            if subsection == 0 then
                id = "ui/climb/hint_start"
                h = 21
            elseif subsection == #player.charge_times then
                id = "ui/climb/hint_end"
                h = 21
            end
			local tx = tilex + ((subsection + 1) * shiftx)
			local ty = tiley + ((subsection + 1) * shifty)
			if tx >= cyltower.horizontaltilecount then
				tx = tx - cyltower.horizontaltilecount
			end
			if tx < 0 then
				tx = tx + cyltower.horizontaltilecount
			end
			local tile2 = cyltower.tile_data[cyltower.tm_tileset[1]][math.floor(tx) + 1]
			if tile2.vis == 1 then
				local jankfix = 0
				if subsection == (#player.charge_times - 1) and cyltower.tile_width_fine ~= cyltower.tile_width and shiftx == -1 then
					jankfix = (6 * (shiftx - 1)) / 2
				end
				local scalemult = tile2.xscale / cyltower.tile_width_fine
				local quad = Assets.getQuad(0, 0, 22, math.floor(MathUtils.clamp(w - subsection, 0, 1) * h), 22, h)
				Draw.draw(Assets.getFrames(id)[frame], quad, startx - jankfix, starty, -math.rad(angle), 2, scalemult * -2)
				startx = startx + (scalemult * shiftx * h * -2)
				starty = starty + (shifty * h * 2)
			end
		end
    end
	
    if (player.jumpchargecon > 0 and found ~= 0) then
		local px, py = player:getRelativePos(0, 20)
		
		if cyltower.appearance == 1 then
			px = px + 40
		end

        if (player.facing == "down") then
            py = py + (cyltower.tile_height * found);
        end

        if (player.facing == "right") then
            px = px + (cyltower.tile_width * found);
        end

        if (player.facing == "up") then
            py = py - (cyltower.tile_height * found);
        end

        if (player.facing == "left") then
            px = px - (cyltower.tile_width * found);
        end
		
		local tilex = px / cyltower.tile_width_fine
		if tilex >= cyltower.horizontaltilecount then
			tilex = tilex - cyltower.horizontaltilecount
		end
		if tilex < 0 then
			tilex = tilex + cyltower.horizontaltilecount
		end

        Draw.setColor(TableUtils.lerp({1,1,0,_alph}, {1,1,1,_alph}, 0.4 + (math.sin(player.jumpchargetimer / 3) * 0.4)));
		local tile = cyltower.tile_data[cyltower.tm_tileset[1]][math.floor(tilex) + 1]
		if tile.vis == 1 then
			Draw.draw(Assets.getTexture("ui/climb/reticle"), cyltower.tower_x + tile.x, py, 0, (tile.xscale / cyltower.tile_width_fine) * 2, 2, 2, 2)
		end
	end
    love.graphics.pop()
	Draw.setColor(1,1,1,1)
end

return RotatingTowerReticleDrawer
