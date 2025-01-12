Utils.hook(Character, "getSoulPosition", function(orig, self)
    return self.width / 2, self.height / 2
end)