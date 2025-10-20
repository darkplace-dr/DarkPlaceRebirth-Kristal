return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 32,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 11,
  nextobjectid = 29,
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
      image = "../../../../../../../assets/sprites/world/maps/hometown/church/entrance.png",
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
      image = "../../../../../../../assets/sprites/world/maps/hometown/church/entrance_items.png",
      id = 8,
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
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 680,
          y = 160,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 160,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 680,
          y = 360,
          width = 480,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 360,
          width = 480,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1120,
          y = 240,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 920,
          y = 160,
          width = 240,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 240,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 160,
          width = 240,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 720,
          y = 160,
          width = 120,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 160,
          width = 120,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "objects",
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
          id = 3,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 480,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["exit_sound"] = "doorclose",
            ["facing"] = "down",
            ["map"] = "light/hometown/town_church",
            ["marker"] = "entrychurch",
            ["sound"] = "dooropen"
          }
        },
        {
          id = 4,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 840,
          y = 186,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["exit_sound"] = "doorclose",
            ["facing"] = "up",
            ["map"] = "light/hometown/church/office",
            ["marker"] = "spawn",
            ["sound"] = "dooropen"
          }
        },
        {
          id = 5,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 186,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["exit_sound"] = "doorclose",
            ["facing"] = "up",
            ["map"] = "light/hometown/church/choir",
            ["marker"] = "spawn",
            ["sound"] = "dooropen"
          }
        },
        {
          id = 6,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 154,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["exit_sound"] = "doorclose",
            ["facing"] = "up",
            ["map"] = "light/hometown/church/main",
            ["marker"] = "spawn",
            ["sound"] = "dooropen"
          }
        },
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = 728,
          y = 266,
          width = 106,
          height = 74,
          rotation = 0,
          gid = 89,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 728,
          y = 240,
          width = 106,
          height = 28,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "church.candles",
            ["solid"] = true
          }
        },
        {
          id = 25,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 180,
          y = 240,
          width = 120,
          height = 26,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "church.entrance_bookshelf",
            ["solid"] = true
          }
        },
        {
          id = 27,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 498,
          y = 214,
          width = 52,
          height = 26,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "church.holy_water"
          }
        },
        {
          id = 26,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 1002,
          y = 214,
          width = 26,
          height = 26,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "church.fire_extinguisher"
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
          id = 1,
          name = "spawn",
          type = "",
          shape = "point",
          x = 640,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "south",
          type = "",
          shape = "point",
          x = 640,
          y = 440,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "entrymain",
          type = "",
          shape = "point",
          x = 640,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "entryoffice",
          type = "",
          shape = "point",
          x = 880,
          y = 280,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "entrychoir",
          type = "",
          shape = "point",
          x = 400,
          y = 280,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "imagelayer",
      image = "../../../../../../../assets/sprites/world/maps/hometown/church/entrance_planks.png",
      id = 9,
      name = "planks",
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
      id = 10,
      name = "controllers",
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
          id = 28,
          name = "hometowndaynight",
          type = "",
          shape = "point",
          x = 0,
          y = 0,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["palette"] = "world/church_palette"
          }
        }
      }
    }
  }
}
