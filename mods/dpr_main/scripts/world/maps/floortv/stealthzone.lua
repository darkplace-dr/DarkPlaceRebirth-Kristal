return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 50,
  height = 18,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 15,
  nextobjectid = 177,
  properties = {
    ["border"] = "teevie",
    ["keepmusic"] = true,
    ["punish_map"] = "floortv/stealthzone"
  },
  tilesets = {
    {
      name = "bg_ch3_dw_teevie_land_tileset",
      firstgid = 1,
      filename = "../../tilesets/teevie_land.tsx"
    },
    {
      name = "tvland_objects",
      firstgid = 157,
      filename = "../../tilesets/floortv_objects.tsx",
      exportfilename = "../../tilesets/floortv_objects.lua"
    },
    {
      name = "ch3_dw_tvland_backstage",
      firstgid = 190,
      filename = "../../tilesets/ch3_dw_tvland_backstage.tsx"
    },
    {
      name = "teevie_land_backstage",
      firstgid = 575,
      filename = "../../tilesets/teevie_land_backstage.tsx"
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "objects_bg",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {}
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 50,
      height = 18,
      id = 8,
      name = "Tile Layer 3",
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        54, 54, 54, 54, 54, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        54, 54, 54, 54, 54, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 50,
      height = 18,
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
        593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593,
        593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593,
        593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593,
        593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 631, 621, 620, 621, 620, 621, 620, 632, 2, 3, 3, 3, 3, 208, 209, 3, 3, 3, 3, 3, 3,
        593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 640, 621, 620, 621, 620, 621, 620, 641, 8, 9, 9, 9, 9, 219, 220, 9, 9, 9, 9, 9, 9,
        593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 640, 621, 620, 621, 620, 621, 620, 641, 8, 9, 9, 9, 9, 230, 231, 9, 9, 9, 9, 9, 9,
        593, 593, 593, 593, 593, 593, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 681, 649, 621, 620, 621, 620, 621, 620, 650, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,
        3, 3, 241, 242, 3, 4, 631, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 632, 657, 658, 657, 658, 657, 658, 657, 658, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21,
        9, 9, 252, 253, 9, 10, 640, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 641, 666, 667, 666, 667, 666, 667, 666, 667, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27,
        9, 9, 263, 264, 9, 10, 640, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 641, 657, 658, 657, 658, 657, 658, 657, 658, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21,
        15, 15, 15, 15, 15, 16, 649, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 621, 620, 650, 666, 667, 666, 667, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41,
        20, 21, 20, 21, 20, 21, 658, 657, 658, 657, 658, 657, 658, 657, 658, 657, 658, 657, 658, 657, 658, 657, 658, 657, 658, 657, 658, 657, 658, 657, 658, 657, 658, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33,
        26, 27, 26, 27, 26, 27, 667, 666, 667, 666, 667, 666, 667, 666, 667, 666, 593, 593, 593, 593, 593, 666, 667, 666, 667, 666, 667, 666, 667, 666, 667, 666, 667, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0,
        20, 21, 20, 21, 20, 21, 658, 657, 658, 657, 658, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 658, 657, 658, 657, 658, 657, 658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        41, 41, 41, 41, 41, 41, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593,
        33, 33, 28, 33, 33, 28, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593,
        0, 0, 34, 0, 0, 34, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593,
        593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593, 593
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 50,
      height = 18,
      id = 7,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 807, 798, 798, 798, 798, 798, 798, 808, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 651, 651, 651, 651, 651, 651, 651, 651, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 807, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 798, 808, 0, 0, 0, 0, 0, 0, 0, 62, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 86, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
        0, 0, 0, 0, 0, 0, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 651, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        40, 40, 40, 40, 40, 40, 66, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        46, 46, 46, 46, 46, 46, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        52, 52, 52, 52, 52, 52, 90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
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
          id = 53,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 1860,
          y = 280,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = false
          }
        },
        {
          id = 62,
          name = "teevie_screen",
          type = "",
          shape = "rectangle",
          x = 1840,
          y = 160,
          width = 80,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = false
          }
        },
        {
          id = 89,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 1700,
          y = 280,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = true
          }
        },
        {
          id = 103,
          name = "teevie_screen",
          type = "",
          shape = "rectangle",
          x = 1520,
          y = 160,
          width = 80,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = false
          }
        },
        {
          id = 104,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 1540,
          y = 280,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = false
          }
        },
        {
          id = 167,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 100,
          y = 440,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = true
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
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
          id = 56,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1926,
          y = 280,
          width = 60,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 57,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1774,
          y = 280,
          width = 60,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 101,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1606,
          y = 280,
          width = 60,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 112,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1120,
          y = 240,
          width = 880,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 115,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 280,
          width = 1160,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 116,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 560,
          width = 480,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 117,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 520,
          width = 240,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 119,
          name = "",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 480,
          width = 200,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 120,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 520,
          width = 240,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 121,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1000,
          y = 560,
          width = 320,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 123,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1320,
          y = 400,
          width = 680,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 158,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1230,
          y = 310,
          width = 220,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 165,
          name = "",
          type = "",
          shape = "rectangle",
          x = 174,
          y = 440,
          width = 60,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 166,
          name = "",
          type = "",
          shape = "rectangle",
          x = 6,
          y = 440,
          width = 60,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 11,
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
          id = 107,
          name = "teevie_sneakzone",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 440,
          width = 680,
          height = 2,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 137,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 480,
          y = 620,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 138,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 540,
          y = 650,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 139,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 650,
          y = 660,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 140,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 700,
          y = 640,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 141,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 590,
          y = 630,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 142,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 760,
          y = 630,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 143,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 810,
          y = 650,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 144,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 870,
          y = 630,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 145,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 920,
          y = 650,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        },
        {
          id = 146,
          name = "teevie_sneakhead",
          type = "",
          shape = "point",
          x = 990,
          y = 630,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "zapper"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 12,
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
          id = 109,
          name = "teevie_sneaklight",
          type = "",
          shape = "point",
          x = 940,
          y = 470,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["catchtype"] = 0,
            ["cutscene"] = "tvfloor.sneakattack_zapper",
            ["movetype"] = 0,
            ["wally"] = 440
          }
        },
        {
          id = 110,
          name = "teevie_sneaklight",
          type = "",
          shape = "point",
          x = 540,
          y = 470,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["catchtype"] = 0,
            ["cutscene"] = "tvfloor.sneakattack_zapper",
            ["movetype"] = 0,
            ["wally"] = 440
          }
        },
        {
          id = 111,
          name = "teevie_sneaklight",
          type = "",
          shape = "point",
          x = 740,
          y = 500,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["catchtype"] = 1,
            ["cutscene"] = "tvfloor.sneakattack_zapper",
            ["movetype"] = 1,
            ["wally"] = 440
          }
        },
        {
          id = 154,
          name = "teevie_sneaklight",
          type = "",
          shape = "point",
          x = 1200,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = 0
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
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
          id = 63,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1920,
          y = 320,
          width = 80,
          height = 160,
          rotation = 0,
          gid = 2147483818,
          visible = true,
          properties = {}
        },
        {
          id = 64,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1760,
          y = 320,
          width = 80,
          height = 160,
          rotation = 0,
          gid = 170,
          visible = true,
          properties = {}
        },
        {
          id = 88,
          name = "funny_stanchion",
          type = "",
          shape = "rectangle",
          x = 1480,
          y = 354,
          width = 520,
          height = 46,
          rotation = 0,
          visible = true,
          properties = {
            ["dir"] = "back"
          }
        },
        {
          id = 102,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1600,
          y = 320,
          width = 80,
          height = 160,
          rotation = 0,
          gid = 2147483818,
          visible = true,
          properties = {}
        },
        {
          id = 149,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 2000,
          y = 280,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/pre_elevator",
            ["marker"] = "entry_left"
          }
        },
        {
          id = 151,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 1680,
          y = 240,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (It's a poster. It doesn't have any words on it.)"
          }
        },
        {
          id = 159,
          name = "sprite",
          type = "",
          shape = "rectangle",
          x = 1230,
          y = 188,
          width = 250,
          height = 142,
          rotation = 0,
          visible = true,
          properties = {
            ["texture"] = "world/npcs/gouldensam/idle"
          }
        },
        {
          id = 160,
          name = "funny_stanchion",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 514,
          width = 240,
          height = 46,
          rotation = 0,
          visible = true,
          properties = {
            ["dir"] = "back"
          }
        },
        {
          id = 163,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 480,
          width = 80,
          height = 160,
          rotation = 0,
          gid = 170,
          visible = true,
          properties = {}
        },
        {
          id = 164,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 480,
          width = 80,
          height = 160,
          rotation = 0,
          gid = 2147483818,
          visible = true,
          properties = {}
        },
        {
          id = 168,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 400,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (It's a poster. It has word on it.)"
          }
        },
        {
          id = 174,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1000,
          y = 400,
          width = 132,
          height = 60,
          rotation = 0,
          gid = 183,
          visible = true,
          properties = {}
        },
        {
          id = 175,
          name = "npc",
          type = "",
          shape = "point",
          x = 1200,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "pippins",
            ["cutscene"] = "tvfloor.pippins_first",
            ["sprite"] = "talk"
          }
        },
        {
          id = 176,
          name = "npc",
          type = "",
          shape = "point",
          x = 1256,
          y = 330,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "gouldensam",
            ["cutscene"] = "tvfloor.gouldensam_first",
            ["sprite"] = "talk_face"
          }
        }
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 50,
      height = 18,
      id = 13,
      name = "tiles_above",
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 683, 675, 676, 677, 678, 674, 675, 593, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "markers",
      class = "",
      visible = true,
      opacity = 0.9,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 66,
          name = "entry_right",
          type = "",
          shape = "point",
          x = 1960,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 152,
          name = "spawn",
          type = "",
          shape = "point",
          x = 1720,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 153,
          name = "entry_cage",
          type = "",
          shape = "point",
          x = 1358,
          y = 304,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 169,
          name = "entry_left",
          type = "",
          shape = "point",
          x = 40,
          y = 500,
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
