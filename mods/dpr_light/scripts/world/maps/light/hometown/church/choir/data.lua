return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.12.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 11,
  nextobjectid = 18,
  properties = {
    ["border"] = "leaves",
    ["church"] = true,
    ["inside"] = true,
    ["light"] = true,
    ["music"] = "church"
  },
  tilesets = {
    {
      name = "hometownobjects",
      firstgid = 1,
      filename = "../../../../../tilesets/hometownobjects.tsx",
      exportfilename = "../../../../../tilesets/hometownobjects.lua"
    }
  },
  layers = {
    {
      type = "imagelayer",
      image = "../../../../../../../assets/sprites/world/maps/hometown/church/choir.png",
      id = 2,
      name = "bg",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      repeatx = false,
      repeaty = false,
      properties = {}
    },
    {
      type = "imagelayer",
      image = "../../../../../../../assets/sprites/world/maps/hometown/church/choir_items.png",
      id = 6,
      name = "items",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      repeatx = false,
      repeaty = false,
      properties = {}
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "collision",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 120,
          width = 480,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 400,
          width = 160,
          height = 80,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 400,
          width = 240,
          height = 80,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 160,
          width = 40,
          height = 240,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 160,
          width = 40,
          height = 240,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 464,
          y = 160,
          width = 38,
          height = 24,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 10,
      name = "objects_light",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 336,
          y = 296,
          width = 160,
          height = 32,
          rotation = 0,
          opacity = 1,
          gid = 180,
          visible = true,
          properties = {
            ["day"] = 1,
            ["sunrise"] = 1,
            ["sunset"] = 1
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "objects_party",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 6,
          name = "church_choir_door",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 40,
          width = 80,
          height = 120,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 462,
          width = 80,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["exit_sound"] = "doorclose",
            ["facing"] = "down",
            ["map"] = "light/hometown/church/entrance",
            ["marker"] = "entrychoir",
            ["sound"] = "dooropen"
          }
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 356,
          width = 48,
          height = 146,
          rotation = 0,
          opacity = 1,
          gid = 114,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 160,
          width = 106,
          height = 16,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["cutscene"] = "church.wardrobe",
            ["solid"] = true
          }
        },
        {
          id = 12,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 160,
          width = 80,
          height = 22,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["cutscene"] = "church.bells",
            ["solid"] = true
          }
        },
        {
          id = 13,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 154,
          y = 248,
          width = 14,
          height = 112,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["cutscene"] = "church.piano",
            ["solid"] = true
          }
        },
        {
          id = 14,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 220,
          width = 34,
          height = 140,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["cutscene"] = "church.piano",
            ["solid"] = true
          }
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 334,
          y = 296,
          width = 186,
          height = 242,
          rotation = 0,
          opacity = 1,
          gid = 181,
          visible = true,
          properties = {
            ["day"] = 1,
            ["sunrise"] = 1,
            ["sunset"] = 1
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "markers",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 8,
          name = "spawn",
          type = "",
          shape = "point",
          x = 360,
          y = 454,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
      name = "objects_overlay",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 15,
          name = "hometowndaynight",
          type = "",
          shape = "point",
          x = 0,
          y = 0,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["palette"] = "world/church_palette"
          }
        }
      }
    }
  }
}
