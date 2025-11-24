local LenCheck, super = Class(Event,"lencheck")

function LenCheck:init(data)
    super.init(self, data)
    self.active = true
    self.properties = data.properties or {}
end

function LenCheck:update()
    super.update(self)
end

function LenCheck:dirToWalk(dir)
    dir = string.lower(dir)
    local dirs = {
        up = {0,-1},
        down = {0,1},
        left = {-1,0},
        right = {1,0}
    }
    return dirs[dir][1], dirs[dir][2]
end

---@param cutscene WorldCutscene
function LenCheck:handleFleeing(cutscene, tag)
    local lenChar = Game.world:getPartyCharacter(tag)
    Game:removePartyMember(tag)
    local exp = false
    if Game:getFlag("FUN") >= 20 and Game:getFlag("FUN") <= 25 then
        if love.math.random(10) == 1 then
            exp = true
        end
    end
    if exp then
        lenChar:explode()
    else
        lenChar:remove()
    end
    cutscene:attachFollowers()
end

---@param plr Player
function LenCheck:onCollide(plr, dt)
    if not Game:hasPartyMember("len") or not self.active then return end
    self.active = false
    local plrChar = Game.world:getPartyCharacter(plr.actor.id)
    local lenParty = Game:getPartyMember("len")
    local context = self.properties.context or "fountain"
    local walkdir = self.properties.dir or "down"
    local walkX, walkY = plr:getPosition()
    local newX, newY = LenCheck:dirToWalk(walkdir)

    ---@diagnostic disable-next-line: param-type-mismatch
    Game.world:startCutscene(function(cutscene)
        cutscene:after(function() self.active = true end)
        local sus = cutscene:getCharacter("susie")
        local tag = "len"
        if context == "fountain" then
            cutscene:setSpeaker("len")
            if plr.actor == lenParty.actor then
                cutscene:text("* ... [wait:1]We're not going there.","neutral_opened_b",tag)
                walkX = walkX + (newX * 40)
                walkY = walkY + (newY * 40)
                if Game:hasPartyMember("susie") then
                    cutscene:setSpeaker("susie")
                    cutscene:text("* ...", "sus_nervous", sus)
                    cutscene:text("* okay", "smirk", sus)
                end
                cutscene:wait(cutscene:walkTo("len",walkX,walkY,1,walkdir))
                return
            end
            cutscene:text("* Wait...\n[wait:1]* You're going to the light world?","neutral_opened",tag)
            local choice = cutscene:choicer({"Yes","No"})
            if choice == 1 then
                cutscene:text("* Oh okay, im staying then","neutral_opened_b",tag)
                cutscene:text("* See you later...[wait:1] i guess","neutral_opened",tag)
                cutscene:detachFollowers()
                walkX = walkX - (newX * -500)
                walkY = walkY - (newY * -500)
                cutscene:wait(cutscene:walkTo("len",walkX,walkY,2,walkdir))
                cutscene:wait(1)
                LenCheck:handleFleeing(cutscene, tag)
            else
                walkX = walkX + (newX * 4)
                walkY = walkY + (newY * 4)
                cutscene:wait(cutscene:walkTo(plrChar,walkX,walkY,1,walkdir))
            end
        end
    end)
end

return LenCheck