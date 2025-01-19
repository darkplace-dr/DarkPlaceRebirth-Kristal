Utils.hook(Registry.getItem("mane_ax"), "init", function(orig, self)
    orig(self)

    self.light_item = "light/toothbrush"
end)