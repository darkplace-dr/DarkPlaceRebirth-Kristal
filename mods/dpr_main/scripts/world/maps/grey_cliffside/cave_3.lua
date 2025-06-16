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
  nextobjectid = 20,
  properties = {},
  tilesets = {
    {
      name = "cliffs",
      firstgid = 1,
      filename = "../../tilesets/cliffs.tsx",
      exportfilename = "../../tilesets/cliffs.lua"
    },
    {
      name = "cliffs_objs",
      firstgid = 64,
      filename = "../../tilesets/cliffs_objs.tsx",
      exportfilename = "../../tilesets/cliffs_objs.lua"
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
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
          id = 19,
          name = "glitch_bg",
          type = "",
          shape = "rectangle",
          x = 240,
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
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
      id = 5,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36, 36, 36, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36, 36, 36, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36, 36, 36, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36, 36, 36, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36, 36, 36, 0, 0,
        36, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36, 36, 36, 0, 0,
        36, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36, 36, 36, 0, 0,
        36, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36, 36, 36, 0, 0,
        36, 36, 0, 0, 0, 36, 0, 0, 0, 0, 36, 36, 36, 36, 0, 0
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 23, 24, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31, 32, 33, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 41, 42, 0, 0,
        5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49, 50, 51, 0, 0,
        14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        23, 24, 0, 0, 0, 4, 5, 5, 5, 5, 6, 0, 0, 0, 0, 0,
        32, 33, 0, 0, 0, 13, 16, 14, 14, 17, 15, 0, 0, 0, 0, 0,
        41, 42, 0, 0, 0, 13, 16, 14, 14, 8, 15, 0, 0, 4, 5, 6,
        50, 51, 0, 0, 0, 13, 14, 16, 14, 17, 15, 0, 0, 13, 14, 15,
        0, 0, 0, 0, 0, 13, 8, 14, 14, 16, 15, 0, 0, 22, 23, 24,
        0, 0, 0, 0, 0, 22, 23, 26, 25, 23, 24, 0, 0, 31, 32, 33,
        0, 0, 0, 0, 0, 49, 50, 13, 15, 50, 51, 0, 0, 40, 41, 42
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
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 200,
          width = 40,
          height = 240,
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
          y = 440,
          width = 120,
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
          x = 360,
          y = 440,
          width = 120,
          height = 40,
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
          y = 200,
          width = 40,
          height = 240,
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
          y = 160,
          width = 320,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = -80,
          y = 200,
          width = 180,
          height = 168,
          rotation = 0,
          gid = 65,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 360,
          width = 180,
          height = 168,
          rotation = 0,
          gid = 65,
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
          id = 7,
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
            ["item"] = "claimbclaws"
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
            ["cutscene"] = "cliffside.cat_claimb_done",
            ["flagcheck"] = "!claimb_cat"
          }
        },
        {
          id = 11,
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
            ["map"] = "grey_cliffside/cave_3b",
            ["marker"] = "entry"
          }
        },
        {
          id = 15,
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
            ["cutscene"] = "cliffside.claimb_cat",
            ["once"] = true
          }
        },
        {
          id = 16,
          name = "script",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 460,
          width = 80,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cliffside.force_claimb"
          }
        },
        {
          id = 18,
          name = "footstep",
          type = "",
          shape = "rectangle",
          x = 360,
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
