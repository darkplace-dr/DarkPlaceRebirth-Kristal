return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 14,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 6,
  nextobjectid = 30,
  properties = {
    ["border"] = "mainhub",
    ["music"] = "mainhub",
    ["name"] = "Floor One - Dess's House"
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
      height = 14,
      id = 1,
      name = "tiles",
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
        0, 53, 55, 66, 67, 67, 67, 67, 67, 67, 67, 53, 54, 54, 54, 54,
        0, 66, 68, 79, 80, 80, 80, 80, 80, 80, 80, 66, 67, 53, 54, 54,
        0, 79, 81, 79, 80, 80, 80, 80, 80, 80, 80, 79, 80, 66, 67, 67,
        0, 79, 81, 92, 93, 93, 93, 93, 93, 93, 93, 79, 80, 79, 80, 80,
        0, 92, 94, 4, 2, 2, 2, 2, 2, 2, 5, 92, 93, 79, 80, 80,
        0, 4, 2, 15, 15, 15, 15, 15, 15, 15, 15, 2, 5, 92, 93, 93,
        0, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 2, 2,
        0, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,
        0, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 28, 28, 28,
        0, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 0, 0, 0,
        0, 27, 28, 15, 15, 15, 15, 15, 15, 15, 15, 28, 29, 0, 0, 0,
        0, 0, 0, 27, 28, 28, 28, 28, 28, 28, 29, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "objects_tiles",
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
          id = 23,
          name = "",
          class = "",
          shape = "rectangle",
          x = 128,
          y = 256,
          width = 240,
          height = 240,
          rotation = 0,
          gid = 211,
          visible = true,
          properties = {}
        }
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
          x = 520,
          y = 200,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          class = "",
          shape = "rectangle",
          x = 440,
          y = 160,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          class = "",
          shape = "rectangle",
          x = 40,
          y = 160,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          class = "",
          shape = "rectangle",
          x = 120,
          y = 120,
          width = 320,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          class = "",
          shape = "rectangle",
          x = 0,
          y = 200,
          width = 40,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          class = "",
          shape = "rectangle",
          x = 40,
          y = 440,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "",
          class = "",
          shape = "rectangle",
          x = 120,
          y = 480,
          width = 320,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "",
          class = "",
          shape = "rectangle",
          x = 440,
          y = 440,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "",
          class = "",
          shape = "rectangle",
          x = 520,
          y = 360,
          width = 120,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "",
          class = "",
          shape = "rectangle",
          x = 130,
          y = 148,
          width = 234,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
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
          x = 640,
          y = 240,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floor1/main_south",
            ["marker"] = "east"
          }
        },
        {
          id = 22,
          name = "npc",
          class = "",
          shape = "point",
          x = 440,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "diamond_trash",
            ["cutscene"] = "hub.garbage"
          }
        },
        {
          id = 27,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 133.333,
          y = 174,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text1"] = "* This is also an air conditioner but I was indeciseive on where to put it so I put two of them."
          }
        },
        {
          id = 28,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 289.333,
          y = 174,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text1"] = "* It's one of those air conditioners from motels that overheat for some reaon.",
            ["text2"] = "* What?[wait:10] Did you think it was a window?"
          }
        },
        {
          id = 29,
          name = "npc",
          class = "",
          shape = "point",
          x = 80,
          y = 430,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "diagonal_mario",
            ["cond"] = "not Game:getFlag(\"diagonalMarioKilled\")",
            ["cutscene"] = "hub.diagonal_mario"
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
          id = 9,
          name = "entry",
          class = "",
          shape = "point",
          x = 600,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "spawn",
          class = "",
          shape = "point",
          x = 280,
          y = 360,
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
