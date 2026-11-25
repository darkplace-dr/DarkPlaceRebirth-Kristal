local BreakMenu, super = Class(Object)

function BreakMenu:init()
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    self:setParallax(0)

    self.state = "SELECTING" -- "SELECTING", "TEXT", "CHOICE", "FADING"

    self.draw_children_below = 0

    self.font = Assets.getFont("main")

    self.ui_move = Assets.newSound("ui_move")

    self.arrow = Assets.getTexture("ui/break_menu/arrow_left")
    self.heart = Assets.getTexture("player/" .. Game:getSoulPartyMember():getSoulFacing() .. "/heart")

    self.currently_selected = 1

    self.all_breaks = modRequire("scripts.breaks_list")
    self.breaks = TableUtils.filter(
        TableUtils.copy(self.all_breaks),
        function(b)
            if b.unlocked_party_checks then
                for i = 1, #b.unlocked_party_checks do
                    if not Game:hasUnlockedPartyMember(b.unlocked_party_checks[i]) then
                        return false
                    end
                end
                if b.flag_checks then
                    for i = 1, #b.flag_checks do
                        local inverted, flag = StringUtils.startsWith(b.flag_checks[i], "!")
                        local result = Game:getFlag(flag)
                        if (result and inverted) or (not result and not inverted) then
                            return false
                        end
                    end
                end
            elseif b.flag_checks then
                for i = 1, #b.flag_checks do
                    local inverted, flag = StringUtils.startsWith(b.flag_checks[i], "!")
                    local result = Game:getFlag(flag)
                    if (result and inverted) or (not result and not inverted) then
                        return false
                    end
                end
            end
            return true
        end
    )
    self.breaks_watched = TableUtils.filter(TableUtils.copy(self.breaks), function(b) return Game:getFlag("break#" .. b.cutscene .. "#watched", false) end)

    self.pages_total = math.ceil((#self.breaks + 1) / 6)
    self.page = 1

    self.cammove = 0
    self.flyoff = 0
    self.resetcameratimer = 0

    self.actors = {}
    self.actors_fading = {}

    self.textbox = nil
    self.choicebox = nil
    self.selected_break = nil

    self.box = UIBox(330, 127, 265, 205)
    self:addChild(self.box)

    self.box_small = UIBox(344, 124, 237, 160)
    self.box_small.layer = -1
    self:addChild(self.box_small)

    local _, _, data = Game.world.map:getMarker("break_camera_target")
    if data ~= nil then Game.world:setCameraAttached(false) end

    Input.clear("confirm")
end

function BreakMenu:close()
    Game.world.menu = nil
    for _, actor in ipairs(self.actors_fading) do
        actor:remove()
    end
    if self.selected_break == nil then
        for _, actor in ipairs(self.actors) do
            actor:remove()
        end
        self.visible = false
        self.state = "FADING"
    else
        self:remove()
        Game.world:startCutscene(function(cutscene)
            cutscene:wait(cutscene:fadeOut(0.5))
            local x, y = Game.world.map:getMarker("break_camera_target")
            Game.world.camera:setPosition(x - 160, y)
            cutscene:wait(cutscene:fadeIn(0.5))
            cutscene:gotoCutscene(self.selected_break.cutscene, unpack(self.actors))
        end)
    end
end

function BreakMenu:getSmallBoxText()
    local allseen = #self.breaks_watched == #self.breaks
    local haveall = #self.breaks == #self.all_breaks

    if haveall and allseen then
        return "Everyone is\nfully relaxed!"
    elseif allseen then
        return "Make more friends,\nhave more breaks?"
    end

    return "Diner Tea Time!" -- "Flower Tea Time!\nF$: $" .. Game.flowery_dollars
end

function BreakMenu:updateActors(break_prev)
    local break_current = (self.page - 1) * 6 - 1 + self.currently_selected

    -- previously selected break
    for _, actor in ipairs(self.actors_fading) do
        actor:remove()
    end
    self.actors_fading = {}
    if self.breaks[break_prev] and self.breaks[break_prev].actors then
        for i = 1, #self.breaks[break_prev].actors do
            if self.breaks[break_prev].actors[i] ~= "none" then
                local x, y = Game.world.map:getMarker("break_pos_" .. i)
                local actor_id = self.breaks[break_prev].actors[i]
                local actor_options = self.breaks[break_prev].actor_options
                local actor = Game.world:spawnNPC(actor_id, x, y)

                if i == 1 then
                    actor:setFacing("right")
                elseif i == 2 then
                    actor:setFacing("left")
                end

                if actor_options and actor_options[actor_id] then
                    if actor_options[actor_id].sprite then
                        actor:setSprite(actor_options[actor_id].sprite)
                    end

                    if actor_options[actor_id].offset then
                        actor.x = actor.init_x + (actor_options[actor_id].offset[1] or 0)
                        actor.y = actor.init_y + (actor_options[actor_id].offset[2] or 0)
                    end

                    if actor_options[actor_id].flip then
                        actor.scale_x = -2
                    else
                        actor.scale_x = 2
                    end
                end

                table.insert(self.actors_fading, actor)
                Game.world.timer:tween(3 / 30, actor, { alpha = 0 })
            end
        end
    end

    -- currently selected break
    for _, actor in ipairs(self.actors) do
        actor:remove()
    end
    self.actors = {}
    if self.breaks[break_current] and self.breaks[break_current].actors then
        for i = 1, #self.breaks[break_current].actors do
            if self.breaks[break_current].actors[i] ~= "none" then
                local x, y = Game.world.map:getMarker("break_pos_" .. i)
                local actor_id = self.breaks[break_current].actors[i]
                local actor_options = self.breaks[break_current].actor_options
                local actor = Game.world:spawnNPC(actor_id, x, y)

                if i == 1 then
                    actor:setFacing("right")
                elseif i == 2 then
                    actor:setFacing("left")
                end

                if actor_options and actor_options[actor_id] then
                    if actor_options[actor_id].sprite then
                        actor:setSprite(actor_options[actor_id].sprite)
                    end

                    if actor_options[actor_id].offset then
                        actor.x = actor.init_x + (actor_options[actor_id].offset[1] or 0)
                        actor.y = actor.init_y + (actor_options[actor_id].offset[2] or 0)
                    end

                    if actor_options[actor_id].flip then
                        actor.scale_x = -2
                    else
                        actor.scale_x = 2
                    end
                end

                table.insert(self.actors, actor)
                actor.alpha = 0
                Game.world.timer:tween(3 / 30, actor, { alpha = 1 })
            end
        end
    end
end

function BreakMenu:update()
    super.update(self)

    local function easeInoutCirc(arg0, arg1, arg2, arg3)
        arg0 = arg0 / (arg3 * 0.5)
        if arg0 < 1 then
            return (arg2 * 0.5 * (1 - math.sqrt(1 - (arg0 * arg0)))) + arg1
        end
        arg0 = arg0 - 2
        return (arg2 * 0.5 * (math.sqrt(1 - (arg0 * arg0)) + 1)) + arg1
    end

    local function easeOutCubic(arg0, arg1, arg2, arg3)
        return (arg2 * (math.pow((arg0 / arg3) - 1, 3) + 1)) + arg1
    end

    local resetcamtime = 15
    self.cammove = MathUtils.clamp(self.cammove + DTMULT, 0, resetcamtime)
    local x, y, data = Game.world.map:getMarker("break_camera_target")
    if self.state == "FADING" then
        if Game.world.menu ~= nil and Game.world.menu:includes(BreakMenu) then
            self:remove()
            return
        end

        Game.world.player.alpha = MathUtils.lerp(Game.world.player.alpha, 1, 1 - (1 - math.pow(0.7, 4)) ^ DTMULT)
        for _, follower in ipairs(Game.world.followers) do
            follower.alpha = MathUtils.lerp(follower.alpha, 1, 1 - (1 - math.pow(0.7, 4)) ^ DTMULT)
        end

        self.resetcameratimer = MathUtils.clamp(self.resetcameratimer + DTMULT, 0, resetcamtime)
        local tx, ty = Game.world.camera:getTargetPosition()
        if data ~= nil then
            local targ = {
                x = MathUtils.round(MathUtils.lerp(Game.world.camera.x, tx, 1 - (1 - easeOutCubic(self.resetcameratimer / resetcamtime, 0, 1, 1)) ^ DTMULT)),
                y = MathUtils.round(MathUtils.lerp(Game.world.camera.y, ty, 1 - (1 - easeOutCubic(self.resetcameratimer / resetcamtime, 0, 1, 1)) ^ DTMULT))
            }
            Game.world.camera:setPosition(targ.x, targ.y)
        end

        if self.resetcameratimer >= resetcamtime then
            Game.world.player.alpha = 1
            for _, follower in ipairs(Game.world.followers) do
                follower.alpha = 1
            end
            Game.world:setCameraAttached(true)
            Game.world.camera:setPosition(tx, ty)
            self:remove()
            return
        end
    else
        Game.world.player.alpha = MathUtils.lerp(Game.world.player.alpha, 0, 1 - (1 - math.pow(0.7, 4)) ^ DTMULT)
        for _, follower in ipairs(Game.world.followers) do
            follower.alpha = MathUtils.lerp(follower.alpha, 0, 1 - (1 - math.pow(0.7, 4)) ^ DTMULT)
        end

        if data ~= nil then
            local targ = {
                x = MathUtils.round(MathUtils.lerp(Game.world.camera.x, x, 1 - (1 - easeInoutCirc(self.cammove / resetcamtime, 0, 1, 1)) ^ DTMULT)),
                y = MathUtils.round(MathUtils.lerp(Game.world.camera.y, y, 1 - (1 - easeInoutCirc(self.cammove / resetcamtime, 0, 1, 1)) ^ DTMULT)),
            }
            Game.world.camera:setPosition(targ.x, targ.y)
        end
    end

    local function easeInoutCubic(arg0, arg1, arg2, arg3)
        arg0 = arg0 / (arg3 * 0.5)
        if arg0 < 1 then
            return (arg2 * 0.5 * math.pow(arg0, 3)) + arg1
        end
        return (arg2 * 0.5 * (math.pow(arg0 - 2, 3) + 2)) + arg1
    end

    local prog = self.cammove / resetcamtime
    self.flyoff = MathUtils.lerp(0, 80, 1 - (1 - easeInoutCubic(prog, 0, 1, 1)) ^ DTMULT)
    self.box_small.y = self.box_small.init_y - self.flyoff

    local selected_break = (self.page - 1) * 6 - 1 + self.currently_selected
    local options_on_page = #self.breaks - (self.page - 1) * 6 + 1
    options_on_page = MathUtils.clamp(options_on_page, 1, 6)

    if not OVERLAY_OPEN then
        if Input.pressed("down") then
            if self.state == "SELECTING" then
                self.ui_move:play()
                local break_prev = selected_break
                if self.currently_selected == options_on_page then
                    self.currently_selected = 1
                else
                    self.currently_selected = self.currently_selected + 1
                end
                self:updateActors(break_prev)
            end
            return
        end

        if Input.pressed("up") then
            if self.state == "SELECTING" then
                self.ui_move:play()
                local break_prev = selected_break
                if self.currently_selected == 1 then
                    self.currently_selected = options_on_page
                else
                    self.currently_selected = self.currently_selected - 1
                end
                self:updateActors(break_prev)
            end
            return
        end

        if Input.pressed("left") then
            if self.state == "SELECTING" then
                if self.pages_total > 1 then
                    self.ui_move:play()
                    local break_prev = selected_break
                    self.currently_selected = 1
                    if self.page == 1 then
                        self.page = self.pages_total
                    else
                        self.page = self.page - 1
                    end
                    self:updateActors(break_prev)
                end
            end
            return
        end

        if Input.pressed("right") then
            if self.state == "SELECTING" then
                if self.pages_total > 1 then
                    self.ui_move:play()
                    local break_prev = selected_break
                    self.currently_selected = 1
                    if self.page == self.pages_total then
                        self.page = 1
                    else
                        self.page = self.page + 1
                    end
                    self:updateActors(break_prev)
                end
            end
            return
        end

        if Input.pressed("confirm") then
            if self.state == "SELECTING" then
                if self.page == 1 and self.currently_selected == 1 then
                    Game.world:closeMenu()
                else
                    self.state = "TEXT"

                    local text = "* Have this break?"
                    if TableUtils.contains(self.breaks_watched, self.breaks[selected_break]) then
                        text = "* Have this break again?"
                    end
                    local width, height = 529, 103
                    if Game:isLight() then
                        width, height = 530, 104
                    end

                    self.textbox = Textbox(56, 344, width, height)
                    self.textbox.layer = WORLD_LAYERS["textbox"]
                    Game.world:addChild(self.textbox)
                    self.textbox:setParallax(0, 0)
                    self.textbox.active = true
                    self.textbox.visible = true

                    self.textbox:setText(text, function()
                        self.state = "CHOICE"

                        self.textbox:remove()
                        self.textbox = nil

                        self.choicebox = Choicebox(56, 344, width, height, false)
                        self.choicebox.layer = WORLD_LAYERS["textbox"]
                        Game.world:addChild(self.choicebox)
                        self.choicebox:setParallax(0, 0)

                        self.choicebox:addChoice("Break")
                        self.choicebox:addChoice("Do not")

                        self.choicebox.active = true
                        self.choicebox.visible = true
                    end)
                end
            elseif self.state == "CHOICE" then
                if self.choicebox.current_choice == 1 then
                    Game:setFlag("break#" .. self.breaks[selected_break].cutscene .. "#watched", true)
                    self.selected_break = self.breaks[selected_break]
                    Game.world:closeMenu()
                else
                    self.state = "SELECTING"
                end
                self.choicebox = nil
            end
            return
        end

        if Input.pressed("cancel") then
            if self.state == "SELECTING" then
                Game.world:closeMenu()
            end
            return
        end
    end
end

function BreakMenu:draw()
    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])
    love.graphics.print(self:getSmallBoxText(), 350, 111 - self.flyoff)

    super.draw(self)

    local options_on_page = #self.breaks - (self.page - 1) * 6 + 1
    options_on_page = MathUtils.clamp(options_on_page, 1, 6)

    local color_shader = Kristal.Shaders["GradientV"]
    local last_shader = love.graphics.getShader()

    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])

    if self.pages_total > 1 then
        local numspace = 24
        local totalnumberwidth = (self.pages_total * (numspace / 2)) + ((self.pages_total - 1) * (numspace / 2))
        local truex = 312 + (301 / 2) - (totalnumberwidth / 2)
        local thisy = 319
        for i = 1, self.pages_total do
            local thisx = truex + ((i - 1) * numspace)
            Draw.setColor(ColorUtils.hexToRGB("#65687B"))
            if self.page == i then
                Draw.setColor(PALETTE["world_text"])
            end
            love.graphics.print(tostring(i), math.floor(thisx) - 3, thisy - 9)
            local coll, colr = PALETTE["world_text"], PALETTE["world_text"]
            if self.state == "SELECTING" then
                coll = (Input.down("left") and PALETTE["world_text"] or ColorUtils.hexToRGB("#65687B"))
                colr = (Input.down("right") and PALETTE["world_text"] or ColorUtils.hexToRGB("#65687B"))
            end
            if i == 1 then
                Draw.setColor(coll)
                Draw.draw(self.arrow, math.floor(thisx) - 18, thisy + 8, 0, 1, 1, 3, 5)
            end
            if i == self.pages_total then
                Draw.setColor(colr)
                Draw.draw(self.arrow, math.floor(thisx) + 24, thisy + 8, 0, -1, 1, 3, 5)
            end
            if #Game.stage:getObjects(Choicebox) <= 0 then -- It's like this in Deltarune. All of this.
                local camera_x = Game.world.camera.x - SCREEN_WIDTH / 2
                local camera_y = Game.world.camera.y - SCREEN_HEIGHT / 2
                if i == 1 and Input.pressed("left") then
                    local afterimage = Sprite(self.arrow, thisx - 18 + camera_x, thisy + 8 + camera_y)
                    afterimage.physics.speed_x = -3
                    afterimage.physics.friction = 0.4
                    afterimage:setScale(1)
                    afterimage:fadeOutSpeedAndRemove(0.16666666666666666)
                    afterimage:setOrigin(0.5)
                    afterimage.debug_select = false
                    afterimage.layer = WORLD_LAYERS["textbox"] + 10
                    self.parent:addChild(afterimage)
                end
                if i == self.pages_total and Input.pressed("right") then
                    local afterimage = Sprite(self.arrow, thisx + 24 + camera_x, thisy + 8 + camera_y)
                    afterimage.physics.speed_x = 3
                    afterimage.physics.friction = 0.4
                    afterimage:setScale(-1, 1)
                    afterimage:fadeOutSpeedAndRemove(0.16666666666666666)
                    afterimage:setOrigin(0.5)
                    afterimage.debug_select = false
                    afterimage.layer = WORLD_LAYERS["textbox"] + 10
                    self.parent:addChild(afterimage)
                end
            end
        end
    end
    Draw.setColor(PALETTE["world_text"])

    local function drawOption(name, i, selected, drawnew)
        local x, y = 350, 119 + (i - 1) * 32
        if not selected and not drawnew then
            love.graphics.print(name, x, y)
        else
            local w, h = self.font:getWidth(name), self.font:getHeight(name)
            local canvas = Draw.pushCanvas(w, h, { stencil = false })
            Draw.setColor(1, 1, 1)
            love.graphics.print(name, 0, 0)
            Draw.popCanvas()

            local col = COLORS.yellow
            local col2 = COLORS.white
            if drawnew then
                col = COLORS.white
                col2 = COLORS.yellow
                if selected then
                    col2 = ColorUtils.mergeColor(COLORS.white, COLORS.yellow, 0.25)
                end
            end

            love.graphics.setShader(color_shader)
            color_shader:sendColor("from", col)
            color_shader:sendColor("to", col2)
            Draw.draw(canvas, x, y)
            love.graphics.setShader(last_shader)
        end
        if drawnew then
            local str = "NEW"
            local w, h = self.font:getWidth(str), self.font:getHeight(str)
            local canvas = Draw.pushCanvas(w, h, { stencil = false })
            Draw.setColor(1, 1, 1)
            love.graphics.print(str, 0, 0)
            Draw.popCanvas()

            local col = COLORS.white
            local col2 = COLORS.yellow
            if selected then
                col2 = ColorUtils.hexToRGB("#FFFF72")
            end

            love.graphics.setShader(color_shader)
            color_shader:sendColor("from", col)
            color_shader:sendColor("to", col2)
            Draw.draw(canvas, x + 205, y)
            love.graphics.setShader(last_shader)
        end
    end

    for i = 1, options_on_page do
        local break_num = (self.page - 1) * 6 - 1 + i
        local name = self.breaks[break_num] and self.breaks[break_num].name or "Exit"
        local selected = nil
        local drawnew = not TableUtils.contains(self.breaks_watched, self.breaks[break_num]) and break_num ~= 0
        if self.currently_selected == i then
            selected = true
        end
        drawOption(name, i, selected, drawnew)
    end

    if self.state == "SELECTING" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart, 328, 127 + (self.currently_selected - 1) * 32)
    end
end

return BreakMenu
