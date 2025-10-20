return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.11.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 11,
  properties = {
    ["music"] = "slider"
  },
  tilesets = {
    {
      name = "bg_darktiles1",
      firstgid = 1,
      filename = "../tilesets/bg_darktiles1.tsx",
      exportfilename = "../tilesets/bg_darktiles1.lua"
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 2, 3, 3, 3, 3, 4, 0, 0, 0, 0, 0,
        3, 3, 3, 3, 3, 13, 13, 13, 13, 13, 9, 0, 0, 0, 0, 0,
        13, 13, 13, 13, 13, 13, 13, 13, 6, 13, 9, 0, 0, 0, 0, 0,
        13, 13, 11, 13, 13, 13, 13, 13, 13, 13, 9, 0, 0, 0, 0, 0,
        18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 19, 0, 0, 0, 0, 0,
        23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 24, 0, 0, 0, 0, 0,
        23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 24, 0, 0, 0, 0, 0,
        23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 24, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
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
          type = "",
          shape = "rectangle",
          x = 0,
          y = 160,
          width = 200,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 640,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 160,
          width = 200,
          height = 320,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 320,
          width = 440,
          height = 160,
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
          id = 6,
          name = "slider",
          type = "",
          shape = "point",
          x = 40,
          y = 260,
          width = 0,
          height = 0,
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
          id = 7,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -40,
          y = 200,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "slider",
            ["marker"] = "exit"
          }
        },
        {
          id = 8,
          name = "npc",
          type = "",
          shape = "point",
          x = 240,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "mario",
            ["cond"] = "slide_hs <= 18",
            ["cutscene"] = "slider.mario"
          }
        },
        {
          id = 10,
          name = "warpbin",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 160,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["skin"] = "cyber_city"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
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
          id = 9,
          name = "toggle",
          type = "",
          shape = "point",
          x = 280,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["flag"] = "!mario_obtained",
            ["target"] = { id = 8 }
          }
        }
      }
    }
  }
}
