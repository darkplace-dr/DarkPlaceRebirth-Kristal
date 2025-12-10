return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 16,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 21,
  properties = {
    ["border"] = "teevie",
    ["music"] = "deltarune/tv_world"
  },
  tilesets = {
    {
      name = "bg_ch3_dw_teevie_land_tileset",
      firstgid = 1,
      filename = "../../tilesets/teevie_land.tsx"
    },
    {
      name = "ch3_dw_tvland_backstage",
      firstgid = 157,
      filename = "../../tilesets/ch3_dw_tvland_backstage.tsx"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      id = 1,
      name = "below",
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 4, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 8, 9, 10, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 8, 9, 10, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 14, 15, 16, 0, 0, 0, 0, 0,
        3, 3, 3, 177, 178, 3, 3, 4, 20, 21, 20, 0, 0, 0, 0, 0,
        9, 9, 9, 188, 189, 9, 9, 10, 26, 27, 26, 0, 0, 0, 0, 0,
        9, 9, 9, 199, 200, 9, 9, 10, 20, 21, 20, 0, 0, 0, 0, 0,
        15, 15, 15, 15, 15, 15, 15, 16, 26, 27, 26, 0, 0, 0, 0, 0,
        20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 0, 0, 0, 0, 0,
        26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 0, 0, 0, 0, 0,
        20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 0, 0, 0, 0, 0,
        41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 0, 0, 0, 0, 0,
        33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 0, 0, 0, 0, 0,
        0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      id = 2,
      name = "carpet",
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 0, 0, 0, 0, 0, 0,
        40, 40, 40, 40, 40, 40, 40, 40, 40, 46, 0, 0, 0, 0, 0, 0,
        46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 0, 0, 0, 0, 0, 0,
        52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
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
          class = "",
          shape = "rectangle",
          x = 0,
          y = 200,
          width = 320,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          class = "",
          shape = "rectangle",
          x = 320,
          y = 160,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          class = "",
          shape = "rectangle",
          x = 440,
          y = 200,
          width = 40,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          class = "",
          shape = "rectangle",
          x = 0,
          y = 480,
          width = 440,
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
      id = 5,
      name = "objects_below",
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
          name = "teevie_light",
          class = "",
          shape = "rectangle",
          x = 40,
          y = 360,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = false
          }
        },
        {
          id = 13,
          name = "teevie_light",
          class = "",
          shape = "rectangle",
          x = 140,
          y = 360,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = true
          }
        },
        {
          id = 14,
          name = "teevie_light",
          class = "",
          shape = "rectangle",
          x = 240,
          y = 360,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = false
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
          id = 11,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 120,
          y = 320,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (It's a poster. It doesn't have any words on it.)"
          }
        },
        {
          id = 15,
          name = "npc",
          class = "",
          shape = "point",
          x = 380,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "ralseiimpostor",
            ["cond"] = "not Game:getFlag(\"encounter#dpr_main/pippins_shuttah:done\")",
            ["facing"] = "up"
          }
        },
        {
          id = 16,
          name = "script",
          class = "",
          shape = "rectangle",
          x = 320,
          y = 250,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "tvfloor.ralsei_impostor"
          }
        },
        {
          id = 17,
          name = "transition",
          class = "",
          shape = "rectangle",
          x = -40,
          y = 360,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/zapper_maze",
            ["marker"] = "entry_bottomright"
          }
        },
        {
          id = 20,
          name = "npc",
          class = "",
          shape = "point",
          x = 380,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "pippins",
            ["cond"] = "Game:getFlag(\"encounter#dpr_main/pippins_shuttah:done\") == true and Game:getFlag(\"pippins_shuttah_violence\") == false",
            ["cutscene"] = "tvfloor.post_ralsei_impostor",
            ["sprite"] = "talk"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
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
          id = 18,
          name = "entry",
          class = "",
          shape = "point",
          x = 40,
          y = 420,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "spawn",
          class = "",
          shape = "point",
          x = 201.333,
          y = 420,
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
