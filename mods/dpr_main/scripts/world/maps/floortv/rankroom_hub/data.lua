return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.12.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 36,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 8,
  nextobjectid = 34,
  properties = {
    ["border"] = "green_room",
    ["music"] = "deltarune/greenroom_detune"
  },
  tilesets = {
    {
      name = "ch3_dw_tvland_stage",
      firstgid = 1,
      filename = "../../../tilesets/ch3_dw_tvland_stage.tsx"
    },
    {
      name = "tvland_objects",
      firstgid = 370,
      filename = "../../../tilesets/floortv_objects.tsx",
      exportfilename = "../../../tilesets/floortv_objects.lua"
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "objects_floor",
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
          name = "greenroom_floor",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 36,
      height = 12,
      id = 1,
      name = "floor",
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
        36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
        36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
        36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
        36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
        36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
        36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 259, 259, 36, 36, 259, 259, 259, 259, 36, 36, 36, 36,
        259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 236, 236, 259, 259, 236, 236, 236, 236, 36, 36, 36, 36,
        236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 36, 36, 36, 36,
        236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 36, 36, 36, 36,
        36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 236, 236, 36, 36, 36, 36,
        36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 236, 236, 36, 36, 36, 36,
        36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 236, 236, 36, 36, 36, 36
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "collisions",
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
          y = 360,
          width = 1200,
          height = 120,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1280,
          y = 240,
          width = 160,
          height = 240,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1040,
          y = 240,
          width = 240,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 200,
          width = 80,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 240,
          width = 960,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "objects_below",
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
          name = "greenroom_wall",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 120,
          width = 960,
          height = 160,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["fromamt"] = 0,
            ["shines"] = true,
            ["vines"] = true
          }
        },
        {
          id = 8,
          name = "greenroom_wall",
          type = "",
          shape = "rectangle",
          x = 1120,
          y = 40,
          width = 160,
          height = 200,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["fromamt"] = 0,
            ["shines"] = true,
            ["vines"] = true
          }
        },
        {
          id = 9,
          name = "greenroom_wall",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 80,
          width = 80,
          height = 160,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["fromamt"] = 0,
            ["shines"] = true,
            ["vines"] = true
          }
        },
        {
          id = 10,
          name = "greenroom_wall",
          type = "",
          shape = "rectangle",
          x = 1040,
          y = 120,
          width = 80,
          height = 160,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["fromamt"] = 0,
            ["shines"] = true,
            ["vines"] = true
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
      name = "objects_objects",
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
          name = "door_A",
          type = "",
          shape = "rectangle",
          x = 140,
          y = 280,
          width = 92,
          height = 146,
          rotation = 0,
          opacity = 1,
          gid = 415,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "door_B",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 280,
          width = 88,
          height = 128,
          rotation = 0,
          opacity = 1,
          gid = 417,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "door_C",
          type = "",
          shape = "rectangle",
          x = 420,
          y = 280,
          width = 80,
          height = 110,
          rotation = 0,
          opacity = 1,
          gid = 419,
          visible = true,
          properties = {}
        },
        {
          id = 32,
          name = "teevie_interstitial_doors",
          type = "",
          shape = "rectangle",
          x = 630,
          y = 80,
          width = 184,
          height = 200,
          rotation = 0,
          opacity = 1,
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
          id = 20,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -40,
          y = 280,
          width = 40,
          height = 80,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "floortv/rankroom_T",
            ["marker"] = "entry"
          }
        },
        {
          id = 22,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 1200,
          y = 480,
          width = 80,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "floortv/green_room",
            ["marker"] = "entry_rank"
          }
        },
        {
          id = 29,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1120,
          y = 280,
          width = 160,
          height = 40,
          rotation = 0,
          opacity = 1,
          gid = 421,
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
          id = 11,
          name = "spawn",
          type = "",
          shape = "point",
          x = 1240,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "entry_d",
          type = "",
          shape = "point",
          x = 1240,
          y = 440,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "entry_l",
          type = "",
          shape = "point",
          x = 40,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
