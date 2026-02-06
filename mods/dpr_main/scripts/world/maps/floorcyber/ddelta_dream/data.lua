return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 32,
  height = 24,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 8,
  nextobjectid = 41,
  properties = {
    ["border"] = "",
    ["music"] = "deltarune/man",
    ["name"] = "Cyber Floor - ???"
  },
  tilesets = {
    {
      name = "sidewalk_animated_ddelta_dream",
      firstgid = 1,
      filename = "../../../tilesets/sidewalk_animated_ddelta_dream.tsx",
      exportfilename = "../../../tilesets/sidewalk_animated_ddelta_dream.lua"
    },
    {
      name = "dw_city_street_ddelta_dream",
      firstgid = 133,
      filename = "../../../tilesets/dw_city_street_ddelta_dream.tsx",
      exportfilename = "../../../tilesets/dw_city_street_ddelta_dream.lua"
    },
    {
      name = "street_edges",
      firstgid = 243,
      filename = "../../../tilesets/street_edges_ddelta_dream.tsx",
      exportfilename = "../../../tilesets/street_edges_ddelta_dream.lua"
    },
    {
      name = "city_alleyway_ddelta_dream",
      firstgid = 451,
      filename = "../../../tilesets/city_alleyway_ddelta_dream.tsx",
      exportfilename = "../../../tilesets/city_alleyway_ddelta_dream.lua"
    },
    {
      name = "dw_alley_animated",
      firstgid = 766,
      filename = "../../../tilesets/dw_alley_animated.tsx"
    },
    {
      name = "dw_city_alley",
      firstgid = 799,
      filename = "../../../tilesets/dw_city_alley.tsx",
      exportfilename = "../../../tilesets/dw_city_alley.lua"
    },
    {
      name = "dw_city_alley_ddelta_dream",
      firstgid = 909,
      filename = "../../../tilesets/dw_city_alley_ddelta_dream.tsx",
      exportfilename = "../../../tilesets/dw_city_alley_ddelta_dream.lua"
    },
    {
      name = "dw_city_doors_ddelta_dream",
      firstgid = 1019,
      filename = "../../../tilesets/dw_city_doors_ddelta_dream.tsx",
      exportfilename = "../../../tilesets/dw_city_doors_ddelta_dream.lua"
    },
    {
      name = "city_objects",
      firstgid = 1107,
      filename = "../../../tilesets/city_objects.tsx"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 32,
      height = 24,
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
        710, 710, 710, 710, 694, 698, 695, 695, 695, 696, 296, 296, 296, 967, 983, 983, 983, 983, 983, 969, 296, 296, 296, 694, 695, 695, 695, 695, 695, 696, 710, 710,
        710, 710, 710, 710, 709, 710, 710, 710, 710, 711, 296, 296, 296, 964, 983, 983, 983, 983, 983, 966, 296, 296, 296, 709, 710, 710, 710, 710, 710, 711, 710, 710,
        695, 695, 695, 696, 709, 710, 710, 710, 710, 711, 296, 296, 296, 967, 983, 983, 983, 983, 983, 969, 296, 296, 296, 709, 710, 710, 710, 710, 710, 711, 694, 695,
        710, 710, 710, 716, 709, 710, 710, 710, 710, 711, 296, 183, 178, 184, 207, 207, 207, 207, 207, 186, 178, 187, 296, 709, 710, 710, 710, 710, 710, 711, 709, 710,
        725, 725, 728, 741, 739, 725, 725, 725, 725, 731, 180, 184, 192, 195, 207, 207, 207, 207, 207, 197, 192, 186, 182, 724, 725, 725, 725, 725, 730, 726, 727, 725,
        740, 740, 740, 741, 739, 743, 740, 740, 728, 741, 191, 195, 207, 207, 207, 207, 207, 207, 207, 207, 207, 197, 193, 739, 729, 740, 740, 740, 740, 741, 739, 740,
        744, 740, 740, 741, 742, 740, 740, 740, 740, 741, 188, 207, 207, 207, 207, 207, 207, 207, 207, 207, 207, 207, 190, 742, 740, 740, 740, 740, 740, 741, 739, 744,
        755, 755, 758, 756, 754, 755, 755, 755, 755, 756, 191, 207, 207, 117, 49, 49, 49, 49, 49, 109, 207, 207, 193, 754, 760, 755, 759, 755, 755, 756, 754, 755,
        954, 957, 954, 957, 954, 957, 954, 957, 954, 957, 184, 207, 207, 57, 213, 213, 213, 213, 213, 41, 207, 207, 186, 954, 957, 954, 957, 954, 957, 954, 957, 954,
        968, 968, 968, 968, 968, 968, 968, 968, 968, 968, 195, 207, 207, 57, 213, 213, 213, 213, 213, 41, 207, 207, 197, 968, 968, 968, 968, 968, 968, 968, 968, 968,
        983, 983, 983, 983, 983, 983, 983, 983, 983, 983, 207, 207, 207, 57, 213, 213, 213, 213, 213, 41, 207, 207, 207, 983, 983, 983, 983, 983, 983, 983, 983, 983,
        976, 979, 976, 979, 976, 979, 976, 979, 976, 979, 216, 207, 207, 125, 65, 65, 65, 65, 65, 101, 207, 207, 230, 976, 979, 976, 979, 976, 979, 976, 979, 976,
        296, 296, 296, 296, 296, 296, 296, 296, 296, 296, 188, 207, 207, 192, 192, 192, 192, 192, 192, 192, 207, 207, 190, 296, 279, 348, 348, 348, 349, 296, 296, 296,
        296, 296, 296, 296, 296, 296, 347, 348, 348, 349, 191, 207, 207, 207, 207, 207, 207, 207, 207, 207, 207, 207, 193, 296, 292, 361, 357, 358, 359, 296, 296, 296,
        296, 296, 296, 296, 296, 269, 270, 271, 361, 362, 188, 207, 207, 207, 207, 207, 207, 207, 207, 207, 207, 207, 190, 279, 280, 281, 370, 371, 372, 296, 296, 296,
        296, 296, 296, 296, 296, 282, 283, 284, 296, 296, 202, 228, 207, 207, 207, 207, 207, 207, 207, 207, 207, 220, 204, 292, 293, 294, 296, 296, 296, 296, 296, 296,
        296, 296, 296, 296, 296, 296, 296, 296, 279, 280, 281, 227, 200, 228, 207, 207, 207, 207, 207, 230, 200, 231, 296, 296, 296, 296, 296, 296, 296, 296, 296, 296,
        296, 296, 296, 296, 296, 296, 296, 296, 292, 293, 294, 270, 271, 967, 983, 983, 983, 983, 983, 969, 357, 358, 359, 296, 296, 296, 296, 296, 296, 296, 296, 296,
        296, 296, 296, 269, 270, 271, 296, 296, 296, 296, 282, 283, 284, 964, 983, 983, 983, 983, 983, 966, 370, 371, 372, 296, 296, 347, 348, 348, 349, 296, 296, 296,
        296, 296, 296, 282, 283, 284, 296, 296, 694, 695, 695, 695, 696, 967, 983, 983, 983, 983, 983, 969, 694, 695, 695, 695, 696, 360, 361, 361, 279, 270, 280, 281,
        296, 296, 296, 296, 296, 296, 296, 296, 709, 710, 710, 710, 711, 964, 983, 983, 983, 983, 983, 966, 709, 710, 710, 710, 711, 296, 296, 296, 292, 283, 293, 294,
        296, 296, 296, 296, 296, 296, 296, 296, 709, 710, 710, 710, 711, 967, 983, 983, 983, 983, 983, 969, 709, 710, 710, 710, 711, 296, 296, 296, 296, 296, 296, 296,
        296, 296, 296, 296, 296, 694, 695, 696, 709, 710, 710, 710, 711, 964, 983, 983, 983, 983, 983, 966, 709, 710, 710, 710, 711, 694, 695, 696, 296, 296, 296, 296,
        296, 296, 296, 296, 296, 709, 710, 711, 709, 710, 710, 710, 711, 967, 983, 983, 983, 983, 983, 969, 709, 710, 710, 710, 711, 709, 710, 711, 296, 296, 296, 296
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 32,
      height = 24,
      id = 3,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1030, 1031, 0, 0, 0, 0, 0, 0, 0, 1074, 1075, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1041, 1042, 0, 0, 0, 0, 0, 0, 0, 1085, 1086, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1052, 1053, 0, 0, 0, 0, 0, 0, 0, 1096, 1097, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 466, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 497, 498, 499, 0, 481, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 660, 0, 497, 498, 499, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 512, 513, 514, 0, 496, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 675, 0, 512, 513, 514, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 511, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 690, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
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
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 400,
          height = 320,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 120,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 0,
          width = 120,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 480,
          width = 400,
          height = 480,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 640,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 680,
          width = 120,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 680,
          width = 120,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 640,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 920,
          y = 480,
          width = 360,
          height = 480,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 920,
          y = 0,
          width = 360,
          height = 320,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 120,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 0,
          width = 120,
          height = 120,
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
          id = 1,
          name = "diamonds_symbol",
          type = "",
          shape = "rectangle",
          x = 574,
          y = 400,
          width = 168,
          height = 168,
          rotation = 0,
          gid = 1107,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "dogconegroup",
          type = "",
          shape = "rectangle",
          x = 1240,
          y = 320,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default_state"] = true
          }
        },
        {
          id = 3,
          name = "dogconegroup",
          type = "",
          shape = "rectangle",
          x = 1240,
          y = 360,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default_state"] = true
          }
        },
        {
          id = 4,
          name = "dogconegroup",
          type = "",
          shape = "rectangle",
          x = 1240,
          y = 400,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default_state"] = true
          }
        },
        {
          id = 5,
          name = "dogconegroup",
          type = "",
          shape = "rectangle",
          x = 1240,
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
          id = 6,
          name = "dogconegroup",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 0,
          width = 280,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default_state"] = true
          }
        },
        {
          id = 26,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 960,
          width = 280,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floorcyber/street_1",
            ["marker"] = "west"
          }
        },
        {
          id = 28,
          name = "dogconegroup",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 320,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default_state"] = true
          }
        },
        {
          id = 29,
          name = "dogconegroup",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 360,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default_state"] = true
          }
        },
        {
          id = 30,
          name = "dogconegroup",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 400,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["default_state"] = true
          }
        },
        {
          id = 31,
          name = "dogconegroup",
          type = "",
          shape = "rectangle",
          x = 0,
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
          id = 40,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 618,
          y = 360,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text"] = "* (An ominous floating symbol.)[wait:5]\n* (Could it have come from a dream?)"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
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
          id = 27,
          name = "entry",
          type = "",
          shape = "point",
          x = 660,
          y = 920,
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
