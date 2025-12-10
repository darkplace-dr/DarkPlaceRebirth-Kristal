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
    ["border"] = "city",
    ["music"] = "cybercity_transition"
  },
  tilesets = {
    {
      name = "street_edges",
      firstgid = 1,
      filename = "../../tilesets/street_edges.tsx",
      exportfilename = "../../tilesets/street_edges.lua"
    },
    {
      name = "dw_city_street",
      firstgid = 209,
      filename = "../../tilesets/dw_city_street.tsx"
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
        132, 132, 27, 28, 29, 30, 132, 37, 38, 39, 44, 40, 37, 38, 39, 132,
        132, 37, 38, 39, 42, 30, 132, 50, 51, 52, 23, 132, 50, 51, 52, 132,
        132, 50, 51, 52, 132, 30, 132, 132, 118, 35, 36, 132, 132, 132, 132, 132,
        132, 132, 132, 132, 132, 43, 132, 132, 132, 132, 44, 132, 132, 132, 132, 132,
        132, 132, 132, 132, 132, 43, 132, 132, 132, 132, 44, 132, 132, 37, 38, 39,
        132, 132, 132, 132, 132, 69, 72, 71, 71, 72, 75, 132, 132, 50, 51, 52,
        116, 117, 132, 132, 132, 82, 268, 268, 268, 268, 88, 132, 105, 106, 106, 106,
        129, 130, 132, 132, 132, 95, 150, 150, 150, 150, 101, 27, 28, 29, 132, 132,
        132, 132, 132, 132, 132, 82, 150, 150, 150, 150, 88, 40, 41, 42, 132, 132,
        132, 132, 132, 132, 132, 95, 150, 150, 150, 150, 101, 54, 118, 119, 119, 119,
        132, 132, 37, 38, 39, 82, 150, 150, 150, 150, 88, 105, 106, 106, 107, 54,
        132, 132, 50, 51, 52, 95, 150, 150, 150, 150, 101, 118, 119, 119, 37, 38,
        132, 132, 132, 132, 132, 82, 150, 150, 150, 150, 88, 132, 132, 132, 50, 51,
        37, 38, 39, 132, 132, 95, 150, 150, 150, 150, 101, 132, 132, 105, 106, 106,
        50, 37, 38, 39, 132, 82, 150, 150, 150, 150, 88, 115, 116, 117, 132, 132,
        132, 50, 51, 52, 132, 95, 150, 150, 150, 150, 101, 128, 129, 130, 119, 119
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
          x = 160,
          y = 200,
          width = 40,
          height = 440,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          class = "",
          shape = "rectangle",
          x = 440,
          y = 200,
          width = 40,
          height = 440,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          class = "",
          shape = "rectangle",
          x = 200,
          y = 160,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          class = "",
          shape = "rectangle",
          x = 360,
          y = 160,
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
      id = 6,
      name = "objects_elevator",
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
          name = "elevatordoor",
          class = "",
          shape = "rectangle",
          x = 260,
          y = 160,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["double_doors"] = "true",
            ["type"] = "cyber"
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
          id = 13,
          name = "transition",
          class = "",
          shape = "rectangle",
          x = 280,
          y = 140,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "hub_elevator",
            ["marker"] = "entry"
          }
        },
        {
          id = 20,
          name = "transition",
          class = "",
          shape = "rectangle",
          x = 200,
          y = 640,
          width = 240,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floorcyber/street_1",
            ["marker"] = "elevator"
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
          id = 18,
          name = "entry_elevator",
          class = "",
          shape = "point",
          x = 320,
          y = 250,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "south",
          class = "",
          shape = "point",
          x = 320,
          y = 590,
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
      width = 16,
      height = 16,
      id = 2,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        106, 106, 107, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 27, 28, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        35, 40, 41, 42, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 205, 206, 207, 201, 202, 203, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 132, 132, 132, 132, 132, 132, 0, 0, 0, 0, 0
      }
    }
  }
}
