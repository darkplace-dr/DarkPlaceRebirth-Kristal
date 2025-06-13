return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 32,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 8,
  nextobjectid = 91,
  properties = {
    ["border"] = "teevie",
    ["keepmusic"] = true,
    ["punish_map"] = "floortv/stealthtest"
  },
  tilesets = {
    {
      name = "teevie_land_backstage",
      firstgid = 1,
      filename = "../../tilesets/teevie_land_backstage.tsx"
    },
    {
      name = "bg_ch3_dw_teevie_land_tileset",
      firstgid = 280,
      filename = "../../tilesets/teevie_land.tsx"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 32,
      height = 12,
      id = 1,
      name = "Tile Layer 1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19,
        19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19,
        66, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 67, 66, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 67,
        66, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 67, 66, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 67,
        66, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 67, 66, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 67,
        66, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 67, 66, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 46, 47, 67,
        83, 84, 83, 84, 83, 84, 83, 84, 83, 84, 83, 84, 83, 84, 83, 84, 83, 84, 83, 84, 83, 84, 83, 84, 83, 84, 83, 84, 83, 84, 83, 84,
        92, 93, 92, 93, 92, 93, 92, 93, 19, 19, 19, 19, 19, 19, 92, 93, 92, 93, 92, 93, 92, 93, 92, 93, 19, 19, 19, 19, 19, 19, 92, 93,
        19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 83, 84, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 83, 84,
        19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19,
        19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19,
        19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 32,
      height = 12,
      id = 6,
      name = "Tile Layer 2",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
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
          x = -10,
          y = 200,
          width = 1290,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 320,
          width = 320,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1200,
          y = 320,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 280,
          width = 240,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 70,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 320,
          width = 320,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 71,
          name = "",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 280,
          width = 240,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 72,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 320,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "objects_sneaking",
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
          id = 4,
          name = "teevie_sneakzone",
          type = "",
          shape = "rectangle",
          x = 720,
          y = 240,
          width = 480,
          height = 2,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 720,
          y = 420,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "shadowguy"
          }
        },
        {
          id = 17,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 780,
          y = 450,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "shadowguy"
          }
        },
        {
          id = 18,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 810,
          y = 410,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "shadowguy"
          }
        },
        {
          id = 19,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 870,
          y = 460,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "shadowguy"
          }
        },
        {
          id = 20,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 910,
          y = 420,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "shadowguy"
          }
        },
        {
          id = 21,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 960,
          y = 470,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "shadowguy"
          }
        },
        {
          id = 22,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 1000,
          y = 410,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "shadowguy"
          }
        },
        {
          id = 23,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 1040,
          y = 450,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "shadowguy"
          }
        },
        {
          id = 24,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 1110,
          y = 410,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "shadowguy"
          }
        },
        {
          id = 28,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 1160,
          y = 460,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "shadowguy"
          }
        },
        {
          id = 29,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 1230,
          y = 430,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "shadowguy"
          }
        },
        {
          id = 73,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 80,
          y = 430,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 74,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 140,
          y = 460,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 76,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 250,
          y = 470,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 77,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 300,
          y = 450,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 78,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 190,
          y = 440,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 79,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 360,
          y = 440,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 80,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 410,
          y = 460,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 81,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 470,
          y = 440,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 82,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 520,
          y = 460,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 83,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 590,
          y = 440,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 85,
          name = "teevie_sneakzone",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 240,
          width = 480,
          height = 2,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
      name = "objects_sneaklights",
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
          id = 12,
          name = "teevie_sneaklight",
          type = "",
          shape = "point",
          x = 840,
          y = 272,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["catchtype"] = 0,
            ["cutscene"] = "tvfloor.sneakattack_shadowguy",
            ["movetype"] = 0
          }
        },
        {
          id = 13,
          name = "teevie_sneaklight",
          type = "",
          shape = "point",
          x = 1080,
          y = 316,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["catchtype"] = 1,
            ["cutscene"] = "tvfloor.sneakattack_shadowguy",
            ["movetype"] = 1
          }
        },
        {
          id = 88,
          name = "teevie_sneaklight",
          type = "",
          shape = "point",
          x = 200,
          y = 270,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["catchtype"] = 0,
            ["cutscene"] = "tvfloor.sneakattack_zapper",
            ["movetype"] = 0
          }
        },
        {
          id = 89,
          name = "teevie_sneaklight",
          type = "",
          shape = "point",
          x = 440,
          y = 314,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["catchtype"] = 1,
            ["cutscene"] = "tvfloor.sneakattack_zapper",
            ["movetype"] = 1
          }
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
          id = 15,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -40,
          y = 240,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/stealthtest"
          }
        },
        {
          id = 31,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 1280,
          y = 240,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/pre_elevator",
            ["market"] = "entry_left"
          }
        },
        {
          id = 90,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -80,
          y = 250,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/stealthtest"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
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
          id = 5,
          name = "spawn",
          type = "",
          shape = "point",
          x = 40,
          y = 280,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 30,
          name = "entry_cage",
          type = "",
          shape = "point",
          x = 600,
          y = 280,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
