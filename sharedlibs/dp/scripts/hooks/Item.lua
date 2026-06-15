local Item, super = HookSystem.hookScript(Item)

function Item:init(...)
    super.init(self, ...)

    self.reactions_battle = {}
end

function Item:getBattleReactions() return self.reactions_battle end

function Item:getBattleReaction(user_id, reactor_id, miniparty)
    local reactions = self:getBattleReactions()
    local miniparty_reactor
    if miniparty then
        miniparty_reactor = reactor_id.."+"..miniparty
    end
    if reactions[user_id] then
        if type(reactions[user_id]) == "string" then
            if reactor_id == user_id then
                if miniparty then
                    local reaction = reactions[miniparty_reactor]
                    if reaction then return reaction end
                end
                return reactions[user_id]
            else
                return nil
            end
        else
            local reaction = reactions[user_id]
            if miniparty then
                local minireaction = reaction[miniparty_reactor]
                if minireaction then return minireaction end
            end
            return reaction[reactor_id]
        end
    end
    -- if none of the above returned a battle rection, take it from normal reactions
    return self:getReaction(user_id, reactor_id, miniparty)
end

return Item