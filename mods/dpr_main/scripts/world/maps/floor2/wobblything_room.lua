return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 9,
  nextobjectid = 18,
  properties = {
    ["music"] = "mainhub",
    ["name"] = "Floor Two - Wobbly Thing Room"
  },
  tilesets = {
    {
      name = "floor2",
      firstgid = 1,
      filename = "../../tilesets/floor2.tsx",
      exportfilename = "../../tilesets/floor2.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
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
        0, 0, 0, 0, 4, 36, 36, 36, 36, 36, 36, 36, 5, 0, 0, 0,
        36, 36, 36, 36, 37, 53, 55, 53, 2147483704, 53, 53, 53, 18, 0, 0, 0,
        53, 53, 2147483687, 53, 54, 56, 53, 39, 53, 53, 55, 53, 18, 0, 0, 0,
        53, 53, 53, 53, 73, 70, 70, 70, 70, 70, 70, 70, 18, 0, 0, 0,
        39, 53, 53, 56, 54, 6, 7, 7, 7, 7, 7, 8, 18, 0, 0, 0,
        70, 70, 70, 70, 71, 23, 24, 57, 58, 59, 24, 25, 18, 0, 0, 0,
        7, 7, 7, 7, 7, 9, 24, 74, 75, 76, 24, 25, 18, 0, 0, 0,
        41, 41, 41, 41, 41, 26, 24, 91, 92, 93, 24, 25, 18, 0, 0, 0,
        2, 2, 2, 2, 3, 23, 24, 24, 24, 24, 24, 25, 18, 0, 0, 0,
        0, 0, 0, 0, 20, 40, 41, 41, 41, 41, 41, 42, 18, 0, 0, 0,
        0, 0, 0, 0, 21, 2, 2, 2, 2, 2, 2, 2, 22, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
      id = 7,
      name = "props",
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
        0, 80, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
      id = 2,
      name = "railings",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 20,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 12, 13, 14, 14, 14, 14, 16, 17, 0, 0, 0, 0,
        0, 0, 0, 0, 29, 30, 31, 31, 31, 31, 33, 34, 0, 0, 0, 0,
        0, 0, 0, 0, 46, 47, 0, 0, 0, 0, 50, 51, 0, 0, 0, 0,
        0, 0, 0, 0, 46, 47, 0, 0, 0, 0, 50, 51, 0, 0, 0, 0,
        0, 0, 0, 0, 46, 47, 0, 0, 0, 0, 50, 51, 0, 0, 0, 0,
        0, 0, 0, 0, 46, 47, 0, 0, 0, 0, 50, 51, 0, 0, 0, 0,
        0, 0, 0, 0, 63, 64, 65, 66, 65, 66, 67, 68, 0, 0, 0, 0,
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
          id = 2,
          name = "",
          class = "",
          shape = "rectangle",
          x = 0,
          y = 160,
          width = 226,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          class = "",
          shape = "rectangle",
          x = 0,
          y = 320,
          width = 226,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          class = "",
          shape = "rectangle",
          x = 212,
          y = 240,
          width = 28,
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
          id = 8,
          name = "transition",
          class = "",
          shape = "rectangle",
          x = -40,
          y = 240,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floor2/main_1",
            ["marker"] = "entry_wobblything_room"
          }
        },
        {
          id = 13,
          name = "spotlight",
          class = "",
          shape = "rectangle",
          x = 300,
          y = -270,
          width = 80,
          height = 523,
          rotation = 0,
          visible = true,
          properties = {
            ["base_color"] = "#ffb9b9b9",
            ["base_thickness"] = 6,
            ["bottom_color"] = "#33c8c8c8",
            ["top_color"] = "#80e1e1e1"
          }
        },
        {
          id = 14,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 40,
          y = 160,
          width = 80,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["text1"] = "* - WOBBLY THING SHRINE -\n* (Originally built in 202X)"
          }
        },
        {
          id = 16,
          name = "wobblything",
          class = "",
          shape = "rectangle",
          x = 345,
          y = 256,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["accurate"] = false,
            ["scanend"] = 0,
            ["scanstart"] = -140
          }
        },
        {
          id = 17,
          name = "script",
          class = "",
          shape = "rectangle",
          x = 196,
          y = 200,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "floor2.wobblything",
            ["once"] = true
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
          id = 10,
          name = "entry_main_1",
          class = "",
          shape = "point",
          x = 30,
          y = 280,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "spawn",
          class = "",
          shape = "point",
          x = 80,
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
