return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 25,
  height = 20,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 9,
  nextobjectid = 94,
  properties = {
    ["music"] = "caramelldansen"
  },
  tilesets = {
    {
      name = "devroom_objects",
      firstgid = 1,
      filename = "../../../../tilesets/devroom_objects.tsx",
      exportfilename = "../../../../tilesets/devroom_objects.lua"
    },
    {
      name = "devroom_mono",
      firstgid = 8,
      filename = "../../../../tilesets/devroom_mono.tsx",
      exportfilename = "../../../../tilesets/devroom_mono.lua"
    },
    {
      name = "floor2",
      firstgid = 152,
      filename = "../../../../tilesets/floor2.tsx",
      exportfilename = "../../../../tilesets/floor2.lua"
    },
    {
      name = "cat_cafe_objects",
      firstgid = 322,
      filename = "../../../../tilesets/floor2/cat_cafe_objects.tsx",
      exportfilename = "../../../../tilesets/floor2/cat_cafe_objects.lua"
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 8,
      name = "objects_cafe_bg",
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
          name = "",
          class = "",
          shape = "rectangle",
          x = 0,
          y = 800,
          width = 1000,
          height = 800,
          rotation = 0,
          gid = 322,
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
          id = 3,
          name = "transition",
          class = "",
          shape = "rectangle",
          x = 120,
          y = 780,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floor2/jam/main",
            ["marker"] = "room_5"
          }
        },
        {
          id = 7,
          name = "spotlight",
          class = "",
          shape = "rectangle",
          x = -10,
          y = -200,
          width = 100,
          height = 800,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "spotlight",
          class = "",
          shape = "rectangle",
          x = 300,
          y = 240,
          width = 120,
          height = 210,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "spotlight",
          class = "",
          shape = "rectangle",
          x = 900,
          y = 240,
          width = 120,
          height = 210,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "npc",
          class = "",
          shape = "point",
          x = 920,
          y = 700,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "cafe_cat",
            ["cutscene"] = "cat_cafe.cafe_cat"
          }
        },
        {
          id = 15,
          name = "npc",
          class = "",
          shape = "point",
          x = 760,
          y = 700,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "cafe_cat",
            ["cutscene"] = "cat_cafe.cafe_cat"
          }
        },
        {
          id = 16,
          name = "npc",
          class = "",
          shape = "point",
          x = 600,
          y = 700,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "cafe_cat",
            ["cutscene"] = "cat_cafe.cafe_cat"
          }
        },
        {
          id = 17,
          name = "npc",
          class = "",
          shape = "point",
          x = 760,
          y = 580,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "cafe_cat",
            ["cutscene"] = "cat_cafe.cafe_cat"
          }
        },
        {
          id = 18,
          name = "npc",
          class = "",
          shape = "point",
          x = 600,
          y = 580,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "cafe_cat",
            ["cutscene"] = "cat_cafe.cafe_cat"
          }
        },
        {
          id = 19,
          name = "npc",
          class = "",
          shape = "point",
          x = 920,
          y = 580,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "cafe_cat",
            ["cutscene"] = "cat_cafe.cafe_cat"
          }
        },
        {
          id = 22,
          name = "dogconegroup",
          class = "",
          shape = "rectangle",
          x = 240,
          y = 160,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default_state"] = true
          }
        },
        {
          id = 23,
          name = "dogconegroup",
          class = "",
          shape = "rectangle",
          x = 240,
          y = 200,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default_state"] = true
          }
        },
        {
          id = 24,
          name = "dogconegroup",
          class = "",
          shape = "rectangle",
          x = 280,
          y = 440,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default_state"] = true
          }
        },
        {
          id = 25,
          name = "dogconegroup",
          class = "",
          shape = "rectangle",
          x = 320,
          y = 440,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default_state"] = true
          }
        },
        {
          id = 51,
          name = "",
          class = "",
          shape = "rectangle",
          x = 790,
          y = 604,
          width = 100,
          height = 76,
          rotation = 0,
          gid = 323,
          visible = true,
          properties = {}
        },
        {
          id = 52,
          name = "",
          class = "",
          shape = "rectangle",
          x = 790,
          y = 724,
          width = 100,
          height = 76,
          rotation = 0,
          gid = 323,
          visible = true,
          properties = {}
        },
        {
          id = 53,
          name = "",
          class = "",
          shape = "rectangle",
          x = 630,
          y = 604,
          width = 100,
          height = 76,
          rotation = 0,
          gid = 323,
          visible = true,
          properties = {}
        },
        {
          id = 54,
          name = "",
          class = "",
          shape = "rectangle",
          x = 630,
          y = 724,
          width = 100,
          height = 76,
          rotation = 0,
          gid = 323,
          visible = true,
          properties = {}
        },
        {
          id = 55,
          name = "",
          class = "",
          shape = "rectangle",
          x = 470,
          y = 724,
          width = 100,
          height = 76,
          rotation = 0,
          gid = 323,
          visible = true,
          properties = {}
        },
        {
          id = 56,
          name = "",
          class = "",
          shape = "rectangle",
          x = 470,
          y = 604,
          width = 100,
          height = 76,
          rotation = 0,
          gid = 323,
          visible = true,
          properties = {}
        },
        {
          id = 57,
          name = "",
          class = "",
          shape = "rectangle",
          x = 488,
          y = 72,
          width = 44,
          height = 36,
          rotation = 0,
          gid = 325,
          visible = true,
          properties = {}
        },
        {
          id = 58,
          name = "",
          class = "",
          shape = "rectangle",
          x = 428,
          y = 72,
          width = 44,
          height = 36,
          rotation = 0,
          gid = 324,
          visible = true,
          properties = {}
        },
        {
          id = 59,
          name = "",
          class = "",
          shape = "rectangle",
          x = 548,
          y = 72,
          width = 44,
          height = 36,
          rotation = 0,
          gid = 326,
          visible = true,
          properties = {}
        },
        {
          id = 60,
          name = "",
          class = "",
          shape = "rectangle",
          x = 608,
          y = 72,
          width = 44,
          height = 36,
          rotation = 0,
          gid = 327,
          visible = true,
          properties = {}
        },
        {
          id = 61,
          name = "",
          class = "",
          shape = "rectangle",
          x = 668,
          y = 72,
          width = 44,
          height = 36,
          rotation = 0,
          gid = 328,
          visible = true,
          properties = {}
        },
        {
          id = 62,
          name = "",
          class = "",
          shape = "rectangle",
          x = 728,
          y = 72,
          width = 44,
          height = 36,
          rotation = 0,
          gid = 329,
          visible = true,
          properties = {}
        },
        {
          id = 63,
          name = "",
          class = "",
          shape = "rectangle",
          x = 368,
          y = 72,
          width = 44,
          height = 36,
          rotation = 0,
          gid = 331,
          visible = true,
          properties = {}
        },
        {
          id = 64,
          name = "",
          class = "",
          shape = "rectangle",
          x = 788,
          y = 72,
          width = 44,
          height = 36,
          rotation = 0,
          gid = 332,
          visible = true,
          properties = {}
        },
        {
          id = 65,
          name = "",
          class = "",
          shape = "rectangle",
          x = 848,
          y = 72,
          width = 44,
          height = 36,
          rotation = 0,
          gid = 330,
          visible = true,
          properties = {}
        },
        {
          id = 66,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 70,
          y = 494,
          width = 150,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.counter",
            ["once"] = false,
            ["solid"] = false
          }
        },
        {
          id = 73,
          name = "",
          class = "",
          shape = "rectangle",
          x = 40,
          y = 524,
          width = 202,
          height = 206,
          rotation = 0,
          gid = 333,
          visible = true,
          properties = {}
        },
        {
          id = 74,
          name = "npc",
          class = "",
          shape = "point",
          x = 146,
          y = 500,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "cafe_cat"
          }
        },
        {
          id = 75,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 282,
          y = 150,
          width = 40,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.cat_statue",
            ["once"] = false,
            ["solid"] = true
          }
        },
        {
          id = 77,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 370,
          y = 86,
          width = 40,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.pickup_food",
            ["id"] = "pancakes",
            ["once"] = false,
            ["solid"] = true
          }
        },
        {
          id = 78,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 430,
          y = 86,
          width = 40,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.pickup_food",
            ["id"] = "bloody_pancakes",
            ["once"] = false,
            ["solid"] = true
          }
        },
        {
          id = 80,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 490,
          y = 86,
          width = 40,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.pickup_food",
            ["id"] = "blue_raspberry",
            ["once"] = false,
            ["solid"] = true
          }
        },
        {
          id = 81,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 550,
          y = 86,
          width = 40,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.pickup_food",
            ["id"] = "castle_cake",
            ["once"] = false,
            ["solid"] = true
          }
        },
        {
          id = 82,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 610.333,
          y = 86.3333,
          width = 40,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.pickup_food",
            ["id"] = "cat_food_fudge",
            ["once"] = false,
            ["solid"] = true
          }
        },
        {
          id = 83,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 670.333,
          y = 86.3333,
          width = 40,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.pickup_food",
            ["id"] = "green_stacks",
            ["once"] = false,
            ["solid"] = true
          }
        },
        {
          id = 84,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 730.333,
          y = 86.3333,
          width = 40,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.pickup_food",
            ["id"] = "knife_in_my_food",
            ["once"] = false,
            ["solid"] = true
          }
        },
        {
          id = 85,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 790.333,
          y = 86.3333,
          width = 40,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.pickup_food",
            ["id"] = "purple_face_cake",
            ["once"] = false,
            ["solid"] = true
          }
        },
        {
          id = 86,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 850,
          y = 86,
          width = 40,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.pickup_food",
            ["id"] = "nothing",
            ["once"] = false,
            ["solid"] = true
          }
        },
        {
          id = 87,
          name = "script",
          class = "",
          shape = "rectangle",
          x = 280,
          y = 200,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.the_trigger",
            ["once"] = false
          }
        },
        {
          id = 88,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 480,
          y = 560,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.event_redirect",
            ["once"] = false,
            ["redirect"] = "18",
            ["solid"] = true
          }
        },
        {
          id = 89,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 480,
          y = 680,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.event_redirect",
            ["once"] = false,
            ["redirect"] = "16",
            ["solid"] = true
          }
        },
        {
          id = 90,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 640,
          y = 560,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.event_redirect",
            ["once"] = false,
            ["redirect"] = "17",
            ["solid"] = true
          }
        },
        {
          id = 91,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 640,
          y = 680,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.event_redirect",
            ["once"] = false,
            ["redirect"] = "15",
            ["solid"] = true
          }
        },
        {
          id = 92,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 800,
          y = 680,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.event_redirect",
            ["once"] = false,
            ["redirect"] = "14",
            ["solid"] = true
          }
        },
        {
          id = 93,
          name = "interactable",
          class = "",
          shape = "rectangle",
          x = 800,
          y = 560,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "cat_cafe.event_redirect",
            ["once"] = false,
            ["redirect"] = "19",
            ["solid"] = true
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "markers",
      class = "",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 2,
          name = "spawn",
          class = "",
          shape = "point",
          x = 160,
          y = 750,
          width = 0,
          height = 0,
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
      width = 25,
      height = 20,
      id = 1,
      name = "Tile Layer 1",
      class = "",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
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
          id = 27,
          name = "",
          class = "",
          shape = "rectangle",
          x = 0,
          y = 480,
          width = 40,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 28,
          name = "",
          class = "",
          shape = "rectangle",
          x = 40,
          y = 640,
          width = 80,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 29,
          name = "",
          class = "",
          shape = "rectangle",
          x = 200,
          y = 640,
          width = 160,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 30,
          name = "",
          class = "",
          shape = "rectangle",
          x = 360,
          y = 760,
          width = 640,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 32,
          name = "",
          class = "",
          shape = "rectangle",
          x = 360,
          y = 240,
          width = 40,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 34,
          name = "",
          class = "",
          shape = "rectangle",
          x = 240,
          y = 240,
          width = 40,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 35,
          name = "",
          class = "",
          shape = "rectangle",
          x = 240,
          y = 80,
          width = 120,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 36,
          name = "",
          class = "",
          shape = "rectangle",
          x = 360,
          y = 70,
          width = 600,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 37,
          name = "",
          class = "",
          shape = "rectangle",
          x = 960,
          y = 80,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 38,
          name = "",
          class = "",
          shape = "rectangle",
          x = 960,
          y = 480,
          width = 40,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 40,
          name = "",
          class = "",
          shape = "rectangle",
          x = 400,
          y = 240,
          width = 600,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 41,
          name = "",
          class = "",
          shape = "rectangle",
          x = 390,
          y = 452,
          width = 600,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 49,
          name = "",
          class = "",
          shape = "polygon",
          x = 360,
          y = 452,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 26, y = 40 },
            { x = 26, y = 0 }
          },
          properties = {}
        },
        {
          id = 70,
          name = "",
          class = "",
          shape = "polygon",
          x = 261,
          y = 486,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -40, y = 40 },
            { x = -240, y = 40 },
            { x = -280, y = 0 }
          },
          properties = {}
        },
        {
          id = 72,
          name = "",
          class = "",
          shape = "polygon",
          x = 280,
          y = 466,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0.181818, y = 20.1818 },
            { x = -19.8182, y = 40 },
            { x = -40, y = 40 },
            { x = -40, y = 0 }
          },
          properties = {}
        }
      }
    }
  }
}
