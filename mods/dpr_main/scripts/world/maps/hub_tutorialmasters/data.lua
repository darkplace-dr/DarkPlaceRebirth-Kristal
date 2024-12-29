return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.11.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 8,
  nextobjectid = 21,
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
    },
    {
      name = "hub_objects",
      firstgid = 209,
      filename = "../../tilesets/hub_objects.tsx",
      exportfilename = "../../tilesets/hub_objects.lua"
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
        54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 55, 0,
        54, 54, 55, 66, 67, 67, 67, 67, 67, 67, 67, 67, 68, 53, 55, 0,
        54, 54, 55, 79, 80, 80, 80, 80, 80, 80, 80, 80, 81, 53, 55, 0,
        67, 67, 68, 92, 93, 93, 93, 93, 93, 93, 93, 93, 94, 66, 68, 0,
        80, 80, 81, 4, 2, 2, 2, 2, 2, 2, 2, 2, 5, 79, 81, 0,
        93, 93, 94, 14, 15, 15, 15, 15, 15, 15, 15, 15, 16, 92, 94, 0,
        2, 2, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 3, 0,
        28, 28, 28, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 28, 29, 0,
        0, 0, 0, 14, 15, 15, 15, 15, 15, 15, 15, 15, 16, 0, 0, 0,
        0, 0, 0, 27, 28, 28, 28, 28, 28, 28, 28, 28, 29, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
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
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 182,
          width = 154,
          height = 122,
          rotation = 0,
          gid = 209,
          visible = true,
          properties = {}
        }
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
          x = 0,
          y = 320,
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
          x = 120,
          y = 400,
          width = 400,
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
          x = 520,
          y = 320,
          width = 80,
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
          x = 600,
          y = 240,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 160,
          width = 80,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 120,
          width = 400,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 160,
          width = 120,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 138,
          width = 154,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "hub.fun_fax"
          }
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
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
          id = 10,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -40,
          y = 240,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "main_hub",
            ["marker"] = "east2"
          }
        },
        {
          id = 14,
          name = "npc",
          type = "",
          shape = "point",
          x = 560,
          y = 292,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "dog",
            ["cutscene"] = "hub.nokia_dog"
          }
        },
        {
          id = 16,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 247,
          y = 120,
          width = 140,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "hub.fun_fax"
          }
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 130,
          y = 194,
          width = 60,
          height = 28,
          rotation = 0,
          gid = 210,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 160,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "hub.money_hole",
            ["once"] = false
          }
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
          id = 11,
          name = "entry",
          type = "",
          shape = "point",
          x = 40,
          y = 280,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "spawn",
          type = "",
          shape = "point",
          x = 320,
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
