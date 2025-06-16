return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 15,
  properties = {
    ["music"] = "demonic_little_grey_cliffs"
  },
  tilesets = {
    {
      name = "cliffs",
      firstgid = 1,
      filename = "../../tilesets/cliffs.tsx",
      exportfilename = "../../tilesets/cliffs.lua"
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
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
        0, 0, 0, 0, 0, 0, 91, 71, 71, 93, 0, 0, 0, 0, 0, 0,
        0, 39, 40, 0, 76, 76, 91, 71, 71, 93, 76, 76, 0, 39, 40, 0,
        0, 44, 45, 91, 71, 71, 71, 71, 71, 71, 71, 71, 93, 44, 45, 0,
        0, 0, 0, 91, 71, 71, 71, 71, 71, 71, 71, 71, 93, 0, 0, 0,
        0, 0, 0, 91, 71, 71, 71, 71, 71, 71, 71, 71, 93, 0, 0, 0,
        0, 39, 40, 91, 71, 71, 71, 71, 71, 71, 71, 71, 93, 39, 40, 0,
        0, 44, 45, 91, 71, 71, 71, 71, 71, 71, 71, 71, 93, 44, 45, 0,
        0, 0, 0, 91, 71, 71, 71, 71, 71, 71, 71, 71, 93, 0, 0, 0,
        0, 0, 0, 91, 71, 71, 71, 71, 71, 71, 71, 71, 93, 0, 0, 0,
        0, 39, 40, 96, 97, 97, 97, 71, 71, 97, 97, 97, 98, 39, 40, 0,
        0, 44, 45, 0, 0, 0, 91, 71, 71, 93, 0, 0, 0, 44, 45, 0,
        0, 0, 0, 0, 0, 0, 91, 71, 71, 93, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
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
        0, 0, 0, 0, 0, 0, 76, 0, 0, 76, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
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
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 400,
          width = 120,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 400,
          width = 120,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 80,
          width = 40,
          height = 320,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 0,
          width = 120,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 0,
          width = 120,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 80,
          width = 40,
          height = 320,
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
          x = 280,
          y = -40,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "grey_cliffside/cave_2",
            ["marker"] = "entry"
          }
        },
        {
          id = 8,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 480,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "grey_cliffside/cliffside_right",
            ["marker"] = "cave_exit"
          }
        },
        {
          id = 9,
          name = "enemy",
          type = "",
          shape = "point",
          x = 240,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "pebblin",
            ["chase"] = true,
            ["encounter"] = "2pebblin",
            ["facing"] = "right",
            ["group"] = "1"
          }
        },
        {
          id = 11,
          name = "enemy",
          type = "",
          shape = "point",
          x = 400,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "pebblin",
            ["chase"] = true,
            ["encounter"] = "2pebblin",
            ["group"] = "1"
          }
        },
        {
          id = 12,
          name = "glitch_bg",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 40,
          width = 40,
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
          id = 14,
          name = "entry",
          type = "",
          shape = "point",
          x = 320,
          y = 80,
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
