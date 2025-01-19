Utils.hook(Registry.getItem("snowring"), "init", function(orig, self)
    orig(self)

    self.light_item = "light/ring"
end)