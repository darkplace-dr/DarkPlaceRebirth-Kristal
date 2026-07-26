---@class ActorSprite : ActorSprite
local ActorSprite, super = HookSystem.hookScript(ActorSprite)

function ActorSprite:init(actor)
    super.init(self, actor)

    self.run_away_2 = false
    self.run_away_timer_2 = 0

    if Game:getFlag("SHINY", {})[self.actor:getShinyID()] and Game:getFlag("SHINY", {})[self.actor:getShinyID()] == true and not Game.world.map.dont_load_shiny then
        local shiny_image_path = self.actor:getSpritePath().."/shiny_palette"
        self:setPaletteFX(1, shiny_image_path)
    end

    self.last_walk_or_talk_or_run = "walk"
end

function ActorSprite:update()
    if self.actor:preSpriteUpdate(self) then
        return
    end

    local flip_dir
    for _, sprite in ipairs(self.sprite_options) do
        flip_dir = self.actor:getFlipDirection(sprite)
        if flip_dir then break end
    end

    if flip_dir then
        if not self.directional then
            local opposite = flip_dir == "right" and "left" or "right"
            if self:getFacing() == flip_dir then
                self.flip_x = true
            elseif self:getFacing() == opposite then
                self.flip_x = false
            end
        else
            self.flip_x = false
        end
        self.last_flippable = true
    elseif self.last_flippable then
        self.last_flippable = false
        self.flip_x = false
    end

    if not self.playing then
        if self.directional or self.walk_override then
            local should_do_walk_animation = false

            if self.walking then
                -- If we're holding a movement key, or this actor is walking 
                -- for any reason, we want to do the walk animation.
                should_do_walk_animation = true
            elseif self.frames then
                -- If we're NOT walking, BUT we're "stepping", continue the
                -- animation until we're done stepping.
                should_do_walk_animation = self.frame % 2 == 0
            end

            if should_do_walk_animation then
                -- If we should process the walking animation, do so.

                local run_check = (self.actor:usesRunningSprites() and (Game.world.player and Game.world.player.run_timer > 0) and not Game.world.cutscene and Kristal.Config["runAnimations"]) and true or false
                if self.last_walk_or_talk_or_run ~= "run" and run_check then
                    self:setSprite(self.actor:getRunSpritesPath())
                    self.last_walk_or_talk_or_run = "run"
                elseif self.last_walk_or_talk_or_run ~= "walk" and not run_check then
                    self:setSprite(self.actor:getWalkSpritesPath())
                    self.last_walk_or_talk_or_run = "walk"
                end

                -- Old frame for reference
                local old_frame = math.floor(self.walk_frame)

                local anim_speed = self.actor.walk_anim_speed or 1
                -- Increase our walking frame
                self.walk_frame = self.walk_frame + (DT * (self.walk_speed > 0 and self.walk_speed or 1) * anim_speed)

                -- Our current frame we should actually render using
                local floored_frame = math.floor(self.walk_frame)

                -- Set the frame to that
                self:setFrame(floored_frame)

                -- If we've changed frames into a "step" frame, call the footstep callback
                if ((old_frame ~= floored_frame) or (self.walking and not self.was_walking)) and (self.on_footstep ~= nil) and (self.frame % 2 == 0) then
                    self.on_footstep(self, ((math.floor(floored_frame / 2) - 1) % 2) + 1)
                end
            elseif self.frames then
                -- We should NOT do the walking animation right now, despite having a walking sprite, so reset.
                if (self.actor:usesDirectionalTalking() and self.last_walk_or_talk_or_run ~= "talk") or self.last_walk_or_talk_or_run ~= "walk" then
                    if self.actor:usesDirectionalTalking() then
                        self:setSprite(self.actor:getTalkSpritesPath())
                        self.last_walk_or_talk_or_run = "talk"
                    else
                        self:setSprite(self.actor:getWalkSpritesPath())
                        self.last_walk_or_talk_or_run = "walk"
                    end
                else
                    self:setFrame(1)
                end
            end
        end

        self:updateDirection()
    end

    self.was_walking = self.walking

    if self.aura then
        self.aura_siner = self.aura_siner + 0.25 * DTMULT
    end

    if self.run_away then
        self.run_away_timer = self.run_away_timer + DTMULT
    end

    if self.run_away_2 then
        self.run_away_timer_2 = self.run_away_timer_2 + DTMULT
    end

    super.super.update(self)

    self.actor:onSpriteUpdate(self)
end

function ActorSprite:setPaletteFX(line, imagedata)
    if not (imagedata or line) then
        self:removeFX(self.palettefx)
    elseif not self.palettefx then
        ---@type PaletteFX
        self.palettefx = PaletteFX(imagedata or self.actor, line, nil, 1)
        self:addFX(self.palettefx)
    else
        self.palettefx:setPalette(imagedata or self.actor, line)
    end
end

return ActorSprite