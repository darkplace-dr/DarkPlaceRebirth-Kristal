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
  nextobjectid = 19,
  properties = {
    ["music"] = "demonic_little_grey_cliffs"
  },
  tilesets = {
    {
      name = "cliffs",
      firstgid = 1,
      filename = "../../tilesets/cliffs.tsx",
      exportfilename = "../../tilesets/cliffs.lua"
    },
    {
      name = "cliffs_objs",
      firstgid = 85,
      filename = "../../tilesets/cliffs_objs.tsx",
      exportfilename = "../../tilesets/cliffs_objs.lua"
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
      width = 16,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 0, 45, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 45, 45, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 45, 45, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 45, 45, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 45, 45, 0,
        45, 45, 45, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 45, 45, 0,
        45, 45, 45, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 45, 45, 0,
        45, 45, 45, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 45, 45, 0,
        45, 45, 45, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 45, 45, 0,
        45, 45, 45, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 45, 45, 0
      }
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 41, 42, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52, 53, 54, 0,
        4, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 65, 66, 0,
        16, 17, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        28, 29, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        40, 41, 42, 0, 0, 4, 5, 5, 5, 5, 6, 0, 0, 0, 0, 0,
        52, 53, 54, 0, 0, 16, 7, 17, 19, 20, 18, 0, 0, 0, 0, 0,
        64, 65, 66, 0, 0, 16, 20, 8, 17, 17, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 16, 17, 19, 17, 7, 18, 0, 0, 4, 5, 6,
        0, 0, 0, 0, 0, 16, 7, 17, 8, 20, 18, 0, 0, 16, 17, 18,
        0, 0, 0, 0, 0, 28, 29, 32, 31, 29, 30, 0, 0, 28, 29, 30,
        0, 0, 0, 0, 0, 52, 53, 16, 18, 53, 54, 0, 0, 40, 41, 42
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
          type = "",
          shape = "rectangle",
          x = 200,
          y = 160,
          width = 240,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 200,
          width = 40,
          height = 216,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 416,
          width = 80,
          height = 64,
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
          y = 416,
          width = 80,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 200,
          width = 40,
          height = 216,
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
          id = 7,
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
            ["map"] = "grey_cliffside/cave_2b",
            ["marker"] = "entry"
          }
        },
        {
          id = 9,
          name = "chest",
          type = "",
          shape = "point",
          x = 320,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["item"] = "stellar_lens"
          }
        },
        {
          id = 10,
          name = "npc",
          type = "",
          shape = "point",
          x = 400,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "cat",
            ["cutscene"] = "cliffside.cat_badge",
            ["flagcheck"] = "!badge_tutorial"
          }
        },
        {
          id = 11,
          name = "script",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 470,
          width = 80,
          height = 10,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cliffside.force_badge_tutorial",
            ["flagcheck"] = "!badge_tutorial",
            ["once"] = false
          }
        },
        {
          id = 12,
          name = "script",
          type = "",
          shape = "rectangle",
          x = 300,
          y = 420,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cliffside.badge_tutorial",
            ["once"] = true
          }
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 400,
          width = 180,
          height = 168,
          rotation = 0,
          gid = 86,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 160,
          width = 70,
          height = 136,
          rotation = 0,
          gid = 85,
          visible = true,
          properties = {}
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
          id = 13,
          name = "entry",
          type = "",
          shape = "point",
          x = 320,
          y = 440,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "spawn",
          type = "",
          shape = "point",
          x = 320,
          y = 320,
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
