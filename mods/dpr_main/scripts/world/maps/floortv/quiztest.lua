return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 70,
  height = 16,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 11,
  nextobjectid = 90,
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
      name = "tvland_objects",
      firstgid = 157,
      filename = "../../tilesets/floortv_objects.tsx",
      exportfilename = "../../tilesets/floortv_objects.lua"
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
      objects = {
        {
          id = 2,
          name = "teevie_bg",
          type = "",
          shape = "point",
          x = 0,
          y = 0,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 70,
      height = 16,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54,
        54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54,
        54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54,
        54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54,
        54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 70,
      height = 16,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        3, 3, 3, 3, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 3, 3, 3, 3,
        9, 9, 9, 9, 9, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 9, 9,
        9, 9, 9, 9, 9, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 9, 9,
        9, 9, 9, 9, 9, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 9, 9,
        15, 15, 15, 15, 15, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 15, 15, 15, 15, 15,
        20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 20, 20, 20, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21,
        26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 26, 26, 26, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27, 26, 27,
        20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 20, 20, 20, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21, 20, 21,
        41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 26, 26, 26, 26, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41,
        33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 20, 20, 20, 20, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 33, 33, 28, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28, 33, 33, 28, 33, 33,
        0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 26, 26, 26, 26, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 34, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 34, 0, 0, 34, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 20, 20, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26, 26, 26, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 20, 20, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 70,
      height = 16,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40,
        46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46,
        52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 117, 46, 46, 119, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 46, 46, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 46, 46, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 46, 46, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 46, 46, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 46, 46, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 46, 46, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
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
          id = 1,
          name = "teevie_tvs",
          type = "",
          shape = "rectangle",
          x = 760,
          y = 40,
          width = 240,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "teevie_tvs",
          type = "",
          shape = "rectangle",
          x = 1640,
          y = 40,
          width = 240,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 29,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 120,
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
          id = 30,
          name = "teevie_screen",
          type = "",
          shape = "rectangle",
          x = 100,
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
          id = 33,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 720,
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
          id = 34,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 440,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = false
          }
        },
        {
          id = 35,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 520,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = true
          }
        },
        {
          id = 39,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 1600,
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
          id = 40,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 1740,
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
          id = 41,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 1880,
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
          id = 53,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 2640,
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
          x = 2620,
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
          id = 72,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 600,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = false
          }
        },
        {
          id = 73,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 920,
          y = 440,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = true
          }
        },
        {
          id = 74,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 920,
          y = 520,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = false
          }
        },
        {
          id = 75,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 920,
          y = 600,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["odd"] = true
          }
        },
        {
          id = 76,
          name = "teevie_light",
          type = "",
          shape = "rectangle",
          x = 1000,
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
          id = 82,
          name = "teevie_spikes",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 400,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default"] = true,
            ["flag"] = "teevie_quiz_1"
          }
        },
        {
          id = 83,
          name = "teevie_spikes",
          type = "",
          shape = "rectangle",
          x = 840,
          y = 400,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default"] = true,
            ["flag"] = "teevie_quiz_1"
          }
        },
        {
          id = 84,
          name = "teevie_spikes",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 400,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default"] = true,
            ["flag"] = "teevie_quiz_1"
          }
        },
        {
          id = 85,
          name = "teevie_spikes",
          type = "",
          shape = "rectangle",
          x = 920,
          y = 400,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default"] = true,
            ["flag"] = "teevie_quiz_1"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 10,
      name = "objects_quiz",
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
          id = 77,
          name = "teevie_quiz",
          type = "",
          shape = "rectangle",
          x = 1080,
          y = 40,
          width = 480,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {
            ["flag"] = "teevie_quiz_1",
            ["quiz_answer_a_1"] = "HERO",
            ["quiz_answer_a_2"] = "LEGACY",
            ["quiz_answer_b_1"] = "KRIS",
            ["quiz_answer_b_2"] = "MAIN HUB",
            ["quiz_correct_1"] = "A",
            ["quiz_correct_2"] = "B",
            ["quiz_text_1"] = "WHAT IS THE NAME OF\nYOUR CHOSEN VESSEL?",
            ["quiz_text_2"] = "WHAT IS THIS DARK WORLD\nCALLED?",
            ["quiz_time_1"] = 10,
            ["quiz_time_2"] = 8
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
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 400,
          width = 800,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 240,
          width = 2800,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 206,
          y = 280,
          width = 60,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = 654,
          y = 260,
          width = 60,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 31,
          name = "",
          type = "",
          shape = "rectangle",
          x = 14,
          y = 280,
          width = 60,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 43,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1926,
          y = 260,
          width = 60,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 56,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2726,
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
          x = 2534,
          y = 280,
          width = 60,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 69,
          name = "",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 400,
          width = 1840,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 70,
          name = "",
          type = "",
          shape = "rectangle",
          x = 760,
          y = 440,
          width = 40,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 71,
          name = "",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 440,
          width = 40,
          height = 200,
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
          id = 19,
          name = "funny_stanchion",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 249,
          width = 360,
          height = 46,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "funny_stanchion",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 354,
          width = 720,
          height = 46,
          rotation = 0,
          visible = true,
          properties = {
            ["dir"] = "back"
          }
        },
        {
          id = 45,
          name = "funny_stanchion",
          type = "",
          shape = "rectangle",
          x = 2000,
          y = 249,
          width = 520,
          height = 46,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 46,
          name = "funny_stanchion",
          type = "",
          shape = "rectangle",
          x = 1920,
          y = 354,
          width = 880,
          height = 46,
          rotation = 0,
          visible = true,
          properties = {
            ["dir"] = "back"
          }
        },
        {
          id = 48,
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 320,
          width = 80,
          height = 160,
          rotation = 0,
          gid = 2147483818,
          visible = true,
          properties = {}
        },
        {
          id = 49,
          name = "",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 300,
          width = 80,
          height = 160,
          rotation = 0,
          gid = 170,
          visible = true,
          properties = {}
        },
        {
          id = 50,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 320,
          width = 80,
          height = 160,
          rotation = 0,
          gid = 170,
          visible = true,
          properties = {}
        },
        {
          id = 51,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1920,
          y = 300,
          width = 80,
          height = 160,
          rotation = 0,
          gid = 2147483818,
          visible = true,
          properties = {}
        },
        {
          id = 52,
          name = "teevie_cameras",
          type = "",
          shape = "rectangle",
          x = 1960,
          y = 200,
          width = 600,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 63,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2720,
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
          x = 2520,
          y = 320,
          width = 80,
          height = 160,
          rotation = 0,
          gid = 170,
          visible = true,
          properties = {}
        },
        {
          id = 67,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -40,
          y = 280,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/pre_elevator",
            ["marker"] = "entry_right"
          }
        },
        {
          id = 68,
          name = "script",
          type = "",
          shape = "rectangle",
          x = 2260,
          y = 280,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "tvfloor.desshasfans"
          }
        },
        {
          id = 87,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 640,
          width = 160,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/pre_elevator",
            ["marker"] = "entry_right"
          }
        },
        {
          id = 88,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 2800,
          y = 280,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/zapper_maze",
            ["marker"] = "entry_topleft"
          }
        }
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
          id = 3,
          name = "spawn",
          type = "",
          shape = "point",
          x = 140,
          y = 350,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 65,
          name = "entry_left",
          type = "",
          shape = "point",
          x = 40,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 66,
          name = "entry_right",
          type = "",
          shape = "point",
          x = 2760,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 86,
          name = "entry_up",
          type = "",
          shape = "point",
          x = 880,
          y = 600,
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
