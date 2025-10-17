return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 22,
  height = 15,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 6,
  nextobjectid = 16,
  properties = {
    ["border"] = "mainhub",
    ["music"] = "mainhub"
  },
  tilesets = {
    {
      name = "castle",
      firstgid = 1,
      filename = "../../tilesets/castle.tsx",
      exportfilename = "../../tilesets/castle.lua"
    },
    {
      name = "main_area",
      firstgid = 41,
      filename = "../../tilesets/main_area.tsx",
      exportfilename = "../../tilesets/main_area.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 22,
      height = 15,
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
        94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 95, 0, 0,
        94, 94, 94, 95, 107, 107, 107, 107, 107, 107, 107, 107, 107, 107, 107, 107, 107, 107, 107, 108, 0, 0,
        94, 94, 94, 95, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 121, 0, 0,
        94, 94, 94, 95, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 121, 0, 0,
        94, 94, 94, 95, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 121, 0, 0,
        94, 94, 94, 95, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 121, 0, 0,
        107, 107, 107, 108, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 134, 0, 0,
        120, 120, 120, 121, 44, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 45, 0, 0,
        133, 133, 133, 134, 54, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 56, 0, 0,
        42, 42, 42, 42, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 56, 0, 0,
        68, 68, 68, 68, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 56, 0, 0,
        0, 0, 0, 0, 54, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 56, 0, 0,
        0, 0, 0, 0, 54, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 56, 0, 0,
        0, 0, 0, 0, 57, 68, 68, 68, 68, 68, 68, 68, 68, 68, 68, 68, 68, 68, 68, 58, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 22,
      height = 15,
      id = 2,
      name = "Tile Layer 2",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 20,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 96, 97, 98, 2147483744, 0, 96, 97, 98, 2147483744, 0, 96, 97, 98, 2147483744, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 110, 111, 0, 0, 0, 110, 111, 0, 0, 0, 110, 111, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 123, 124, 0, 0, 0, 123, 124, 0, 0, 0, 123, 124, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 136, 137, 0, 0, 0, 136, 137, 0, 0, 0, 136, 137, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 149, 150, 0, 0, 0, 149, 150, 0, 0, 0, 149, 150, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
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
          y = 320,
          width = 160,
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
          x = 0,
          y = 440,
          width = 160,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          class = "",
          shape = "rectangle",
          x = 120,
          y = 480,
          width = 40,
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
          x = 160,
          y = 240,
          width = 640,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          class = "",
          shape = "rectangle",
          x = 120,
          y = 280,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          class = "",
          shape = "rectangle",
          x = 800,
          y = 280,
          width = 40,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          class = "",
          shape = "rectangle",
          x = 160,
          y = 560,
          width = 640,
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
          id = 1,
          name = "transition",
          class = "",
          shape = "rectangle",
          x = -40,
          y = 360,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floor1/main",
            ["marker"] = "east1"
          }
        },
        {
          id = 13,
          name = "enemy",
          class = "",
          shape = "point",
          x = 680,
          y = 400,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "dummy",
            ["encounter"] = "dummy"
          }
        },
        {
          id = 15,
          name = "enemy",
          class = "",
          shape = "point",
          x = 760,
          y = 550,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "poseur",
            ["encounter"] = "poseur"
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
          id = 11,
          name = "entry",
          class = "",
          shape = "point",
          x = 40,
          y = 400,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "spawn",
          class = "",
          shape = "point",
          x = 480,
          y = 400,
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
