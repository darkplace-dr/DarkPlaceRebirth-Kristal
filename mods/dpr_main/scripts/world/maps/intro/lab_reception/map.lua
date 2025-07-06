local kristal_map, super = Class(Map)

function kristal_map:onEnter()
    super.onEnter(self)

    self.gray = love.graphics.newShader([[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
            vec4 texcolor = Texel(texture, texture_coords) * color;
            float gray = dot(texcolor.rgb, vec3(0.299, 0.587, 0.114));
            texcolor.rgb = vec3(gray);
            return texcolor;
        }
    ]])

    self.sprite_name = "kristal/icons/icon_13"

   -- self.sprite_name = "kristal/title/big_star"

    

    local job = Sprite(self.sprite_name)
    job:setScale(2)
    job.x = 321
    job.y = SCREEN_HEIGHT/2 + 6
    job:setOrigin(0.5, 0.5)
    job.layer = -1
    Game.world:addChild(job)

    self.kristals = {}

    for i = 1, 10 do
        local ic = self:addIcon()
        Game.world:addChild(ic)
        ic.alpha = i/10

        table.insert(self.kristals, ic)
    end

    self.k_timer = 30
    self.k_timer2 = 0


    self.bg_gradient_siner = 0

    if Game.save_name == "DESS" then
        Game.world.player:setActor("dess")
        Game.party[1] = Game:getPartyMember("dess")
    end

    if Game:getGlobalFlag("hero_trapped_forever", false) then
        self.hero = Game.world:spawnNPC("hero_lw", 320, 400)
        self.hero:addFX(ShaderFX(self.gray), 66)

        if not Game:getFlag("second_sword") then
            Game:setFlag("second_sword", true) --Kind of a weird route?
            Game.inventory:addItem("chosen_blade")
        end
    end
end

function kristal_map:addIcon()
    local job = Sprite(self.sprite_name)
    job:setScale(2)
    job.x = 321
    job.y = SCREEN_HEIGHT/2 + 6
    job:setOrigin(0.5, 0.5)
    job.layer = -2

    return job
end

function kristal_map:update()
    super.update(self)

    --[[if self.k_timer <= 0 then
        self.k_timer = 30
        self.k_timer2 = 0

        local ic = self:addIcon()
        Game.world:addChild(ic)

        table.insert(self.kristals, 1, ic)

        if #self.kristals == 11 then
            self.kristals[11]:remove()
            table.remove(self.kristals, 11)
        end
    else]]
        --self.k_timer = self.k_timer - DTMULT
        --self.k_timer2 = self.k_timer2 + DTMULT
   -- end

        for i,_ in ipairs(self.kristals) do
            if _.alpha <= 0 then
                self.kristals[i]:remove()
                table.remove(self.kristals, i)


                local ic = self:addIcon()
                Game.world:addChild(ic)
                

                table.insert(self.kristals, 1, ic)
            else
                local a, b = (_.alpha - DTMULT/60), (_.scale_x + DTMULT/30)
                _.alpha = a
                _:setScale(b + i/50, 2)
            end
        end



    --self.bg_gradient_siner = self.bg_gradient_siner + 0.2 * DTMULT

    if self.hero then self.hero:facePlayer() end
end

--[[function kristal_map:draw()
    if self.april_fools then
        love.graphics.setColor(1, 1, 1, self.fade)
    else
        love.graphics.setColor(0, 0, 0, self.fade)
    end

    love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    -- gradient background ported over from Asgore's fight in UT
    local gradient_weave = 1.5 + math.sin(self.bg_gradient_siner / 20)
    for i = 0, 10 do
        local gradient_alpha = 0.8 - i / 16
        if self.april_fools then
            love.graphics.setColor(186/255, 186/255, 97/255, gradient_alpha)
        else
            love.graphics.setColor(69/255, 69/255, 158/255, gradient_alpha)
        end
        love.graphics.rectangle("fill",
            0, SCREEN_HEIGHT - math.pow(i, 2) * gradient_weave,
            SCREEN_WIDTH, SCREEN_HEIGHT - math.pow(i + 1, 2) * gradient_weave
        )
    end

    love.graphics.setColor(1, 1, 1, 1)


    super.draw(self)
end]]

return kristal_map