Utils.hook(Registry.getPartyMember("kris"), "init", function(orig, self)
    orig(self)

    self.you = true
end)