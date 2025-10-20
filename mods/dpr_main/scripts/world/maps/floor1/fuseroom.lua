return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 24,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 12,
  properties = {
    ["border"] = "mainhub",
    ["music"] = "mainhub"
  },
  tilesets = {
    {
      name = "main_area",
      firstgid = 1,
      filename = "../../tilesets/main_area.tsx",
      exportfilename = "../../tilesets/main_area.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 24,
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
        0, 0, 53, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 55, 66, 67, 67, 67, 67, 67, 67, 67,
        0, 0, 53, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 55, 79, 80, 80, 80, 80, 80, 80, 80,
        0, 0, 53, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 55, 92, 93, 93, 93, 93, 93, 93, 93,
        0, 0, 66, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 68, 4, 2, 2, 2, 2, 2, 2, 2,
        0, 0, 79, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 81, 17, 28, 28, 28, 28, 28, 28, 28,
        0, 0, 79, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 81, 43, 44, 45, 0, 0, 0, 0, 0,
        0, 0, 79, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 81, 43, 44, 45, 0, 0, 0, 0, 0,
        0, 0, 92, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 94, 43, 44, 45, 0, 0, 0, 0, 0,
        0, 0, 4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 5, 0, 0, 0, 0, 0,
        0, 0, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 0, 0, 0, 0, 0,
        0, 0, 27, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 29, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 24,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 56, 57, 58, 2147483704, 0, 0, 0, 0, 56, 57, 58, 2147483704, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 70, 71, 0, 0, 0, 0, 0, 0, 70, 71, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 83, 84, 0, 0, 0, 0, 0, 0, 83, 84, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 96, 97, 0, 0, 0, 0, 0, 0, 96, 97, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 109, 110, 0, 0, 0, 0, 0, 0, 109, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
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
          x = 760,
          y = 200,
          width = 200,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          class = "",
          shape = "rectangle",
          x = 640,
          y = 80,
          width = 320,
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
          x = 80,
          y = 120,
          width = 560,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          class = "",
          shape = "rectangle",
          x = 40,
          y = 320,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          class = "",
          shape = "rectangle",
          x = 80,
          y = 440,
          width = 680,
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
          id = 6,
          name = "transition",
          class = "",
          shape = "rectangle",
          x = 960,
          y = 120,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floor1/main",
            ["marker"] = "west1"
          }
        },
        {
          id = 9,
          name = "npc",
          class = "",
          shape = "point",
          x = 360,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "malius",
            ["cutscene"] = "hub.malius"
          }
        },
        {
          id = 11,
          name = "npc",
          class = "",
          shape = "point",
          x = 160,
          y = 338,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "fuselings",
            ["text"] = "* We are the fuselings\nWe await our fusing."
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
          id = 7,
          name = "entry",
          class = "",
          shape = "point",
          x = 920,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "spawn",
          class = "",
          shape = "point",
          x = 700,
          y = 160,
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
