return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 50,
  height = 18,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 15,
  nextobjectid = 176,
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
      firstgid = 184,
      filename = "../../tilesets/ch3_dw_tvland_backstage.tsx"
    },
    {
      name = "teevie_land_backstage",
      firstgid = 569,
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
        587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587,
        587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587,
        587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587,
        587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 625, 615, 614, 615, 614, 615, 614, 626, 2, 3, 3, 3, 3, 202, 203, 3, 3, 3, 3, 3, 3,
        587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 634, 615, 614, 615, 614, 615, 614, 635, 8, 9, 9, 9, 9, 213, 214, 9, 9, 9, 9, 9, 9,
        587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 634, 615, 614, 615, 614, 615, 614, 635, 8, 9, 9, 9, 9, 224, 225, 9, 9, 9, 9, 9, 9,
        587, 587, 587, 587, 587, 587, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 675, 643, 615, 614, 615, 614, 615, 614, 644, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,
        3, 3, 235, 236, 3, 4, 625, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 626, 651, 652, 651, 652, 651, 652, 651, 652, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21,
        9, 9, 246, 247, 9, 10, 634, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 635, 660, 661, 660, 661, 660, 661, 660, 661, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27,
        9, 9, 257, 258, 9, 10, 634, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 635, 651, 652, 651, 652, 651, 652, 651, 652, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21,
        15, 15, 15, 15, 15, 16, 643, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 615, 614, 644, 660, 661, 660, 661, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41,
        20, 21, 20, 21, 20, 21, 652, 651, 652, 651, 652, 651, 652, 651, 652, 651, 652, 651, 652, 651, 652, 651, 652, 651, 652, 651, 652, 651, 652, 651, 652, 651, 652, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33,
        26, 27, 26, 27, 26, 27, 661, 660, 661, 660, 661, 660, 661, 660, 661, 660, 587, 587, 587, 587, 587, 660, 661, 660, 661, 660, 661, 660, 661, 660, 661, 660, 661, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0,
        20, 21, 20, 21, 20, 21, 652, 651, 652, 651, 652, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 652, 651, 652, 651, 652, 651, 652, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        41, 41, 41, 41, 41, 41, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587,
        33, 33, 28, 33, 33, 28, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587,
        0, 0, 34, 0, 0, 34, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587,
        587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587, 587
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 801, 792, 792, 792, 792, 792, 792, 802, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 645, 645, 645, 645, 645, 645, 645, 645, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 801, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 792, 802, 0, 0, 0, 0, 0, 0, 0, 62, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 86, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
        0, 0, 0, 0, 0, 0, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
          shape = "rectangle",
          x = 1230,
          y = 310,
          width = 250,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 165,
          name = "",
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 677, 669, 670, 671, 672, 668, 669, 587, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
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
          class = "",
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
          class = "",
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
          class = "",
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
          class = "",
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
