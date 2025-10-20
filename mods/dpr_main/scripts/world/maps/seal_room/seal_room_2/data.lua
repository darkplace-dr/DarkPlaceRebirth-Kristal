return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 13,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 8,
  nextobjectid = 51,
  properties = {
    ["name"] = "Test Map - Room 1"
  },
  tilesets = {
    {
      name = "castle",
      firstgid = 1,
      filename = "../../../tilesets/castle.tsx",
      exportfilename = "../../../tilesets/castle.lua"
    },
    {
      name = "main_area",
      firstgid = 41,
      filename = "../../../tilesets/main_area.tsx",
      exportfilename = "../../../tilesets/main_area.lua"
    },
    {
      name = "cliffs",
      firstgid = 249,
      filename = "../../../tilesets/cliffs.tsx",
      exportfilename = "../../../tilesets/cliffs.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 13,
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
        0, 265, 266, 107, 107, 107, 107, 107, 266, 266, 266, 266, 266, 108, 0, 0,
        0, 119, 120, 120, 271, 271, 271, 271, 271, 120, 120, 272, 120, 121, 0, 0,
        0, 119, 120, 120, 120, 271, 271, 271, 271, 120, 120, 272, 120, 121, 0, 0,
        0, 132, 133, 276, 276, 276, 276, 133, 276, 133, 133, 277, 133, 134, 0, 0,
        0, 44, 263, 42, 42, 251, 251, 55, 251, 251, 251, 42, 42, 45, 0, 0,
        0, 10, 11, 11, 259, 256, 256, 55, 256, 256, 11, 11, 269, 56, 0, 0,
        0, 10, 11, 11, 11, 256, 256, 256, 256, 259, 11, 11, 270, 56, 0, 0,
        0, 10, 11, 11, 11, 11, 256, 319, 319, 261, 11, 11, 11, 56, 0, 0,
        0, 10, 11, 11, 254, 11, 256, 319, 319, 11, 11, 256, 11, 56, 0, 0,
        0, 59, 68, 68, 11, 11, 11, 259, 11, 11, 11, 68, 68, 60, 0, 0,
        0, 0, 0, 0, 1073742103, 68, 11, 11, 11, 68, 60, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 83, 331, 332, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 83, 84, 332, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 13,
      id = 6,
      name = "half_decal",
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 264, 0, 0, 0, 0,
        0, 81, 82, 0, 0, 0, 0, 0, 287, 288, 0, 0, 80, 81, 0, 0,
        0, 94, 95, 0, 0, 0, 0, 0, 292, 293, 0, 0, 255, 256, 0, 0,
        0, 173, 174, 0, 0, 0, 0, 0, 0, 0, 0, 0, 171, 172, 0, 0,
        0, 186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 257, 184, 185, 0, 0,
        0, 199, 200, 255, 0, 0, 0, 0, 0, 0, 0, 0, 197, 198, 0, 0,
        0, 0, 213, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 271, 0, 0,
        0, 225, 226, 0, 0, 0, 0, 0, 0, 0, 0, 0, 360, 224, 0, 0,
        0, 238, 239, 0, 0, 0, 0, 0, 0, 0, 0, 0, 236, 360, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1073742075, 1073742075, 0, 0, 0,
        0, 0, 0, 0, 0, 1073742075, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 13,
      id = 2,
      name = "decal",
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
        0, 0, 0, 0, 0, 249, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 264, 0, 294, 295, 0, 0, 0, 0, 253, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 299, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 304, 305, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 268, 0, 0, 0,
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
      id = 7,
      name = "objects_crystal",
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
          id = 50,
          name = "neocrystal",
          class = "",
          shape = "rectangle",
          x = 244,
          y = 91,
          width = 112,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {
            ["char"] = "suzy",
            ["char_spr"] = "walk/down",
            ["char_type"] = "light",
            ["flag"] = "suzy_freed"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "collision",
      class = "",
      visible = false,
      opacity = 0.5,
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
          x = 40,
          y = 120,
          width = 520,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          class = "",
          shape = "rectangle",
          x = 440,
          y = 400,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          class = "",
          shape = "rectangle",
          x = 360,
          y = 440,
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
          x = 160,
          y = 440,
          width = 80,
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
          x = 40,
          y = 400,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 38,
          name = "",
          class = "",
          shape = "polygon",
          x = 560,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -40, y = 40 },
            { x = 0, y = 40 }
          },
          properties = {}
        },
        {
          id = 39,
          name = "",
          class = "",
          shape = "polygon",
          x = 40,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = 40 },
            { x = 40, y = 40 }
          },
          properties = {}
        },
        {
          id = 40,
          name = "",
          class = "",
          shape = "polygon",
          x = 160,
          y = 440,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = -40 },
            { x = 40, y = 0 }
          },
          properties = {}
        },
        {
          id = 41,
          name = "",
          class = "",
          shape = "polygon",
          x = 440,
          y = 400,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -40, y = 40 },
            { x = 0, y = 40 }
          },
          properties = {}
        },
        {
          id = 43,
          name = "",
          class = "",
          shape = "polygon",
          x = 480,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = 120 },
            { x = 80, y = 200 },
            { x = 80, y = 0 }
          },
          properties = {}
        },
        {
          id = 44,
          name = "",
          class = "",
          shape = "polygon",
          x = 120,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = 120 },
            { x = -80, y = 200 },
            { x = -80, y = 0 }
          },
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
          id = 47,
          name = "transition",
          class = "",
          shape = "rectangle",
          x = 240,
          y = 500,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "seal_room/seal_room_1",
            ["marker"] = "entry"
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
          id = 20,
          name = "spawn",
          class = "",
          shape = "point",
          x = 300,
          y = 290,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 48,
          name = "entry",
          class = "",
          shape = "point",
          x = 300,
          y = 480,
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
