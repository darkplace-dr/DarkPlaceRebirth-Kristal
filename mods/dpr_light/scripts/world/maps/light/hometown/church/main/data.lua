return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 43,
  height = 31,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 11,
  nextobjectid = 129,
  properties = {
    ["border"] = "leaves",
    ["church"] = true,
    ["inside"] = true,
    ["light"] = true,
    ["music"] = "church"
  },
  tilesets = {
    {
      name = "hometownobjects",
      firstgid = 1,
      filename = "../../../../../tilesets/hometownobjects.tsx",
      exportfilename = "../../../../../tilesets/hometownobjects.lua"
    }
  },
  layers = {
    {
      type = "imagelayer",
      image = "../../../../../../../assets/sprites/world/maps/hometown/church/main.png",
      id = 2,
      name = "bg",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      repeatx = false,
      repeaty = false,
      properties = {}
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 8,
      name = "objects_room_night",
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
          id = 75,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 1240,
          width = 1758,
          height = 1240,
          rotation = 0,
          gid = 143,
          visible = true,
          properties = {
            ["night"] = 1
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
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 920,
          y = 1160,
          width = 40,
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
          x = 920,
          y = 1120,
          width = 508,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1160,
          y = 840,
          width = 268,
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
          x = 1428,
          y = 840,
          width = 40,
          height = 320,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 702,
          y = 960,
          width = 276,
          height = 86,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 1120,
          width = 200,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 960,
          width = 360,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 214,
          y = 840,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 254,
          y = 840,
          width = 266,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 280,
          width = 40,
          height = 580,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 280,
          width = 560,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1120,
          y = 280,
          width = 40,
          height = 580,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "polygon",
          x = 520,
          y = 860,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = 20 },
            { x = 40, y = 0 }
          },
          properties = {}
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "polygon",
          x = 1160,
          y = 860,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = 20 },
            { x = -40, y = 0 }
          },
          properties = {}
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 320,
          width = 80,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 43,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 806,
          width = 200,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 44,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 726,
          width = 200,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 45,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 646,
          width = 200,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 46,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 566,
          width = 200,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 47,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 486,
          width = 200,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 48,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 806,
          width = 200,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 49,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 726,
          width = 200,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 50,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 648,
          width = 200,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 51,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 566,
          width = 200,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 52,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 486,
          width = 200,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 53,
          name = "",
          type = "",
          shape = "rectangle",
          x = 722,
          y = 1046,
          width = 236,
          height = 10,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 54,
          name = "",
          type = "",
          shape = "polygon",
          x = 722,
          y = 1056,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = -10 },
            { x = -20, y = -10 }
          },
          properties = {}
        },
        {
          id = 55,
          name = "",
          type = "",
          shape = "polygon",
          x = 958,
          y = 1056,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = -10 },
            { x = 20, y = -10 }
          },
          properties = {}
        },
        {
          id = 56,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1092,
          y = 812,
          width = 24,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 61,
          name = "",
          type = "",
          shape = "rectangle",
          x = 568,
          y = 814,
          width = 24,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 62,
          name = "",
          type = "",
          shape = "rectangle",
          x = 566,
          y = 730,
          width = 24,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 63,
          name = "",
          type = "",
          shape = "rectangle",
          x = 568,
          y = 648,
          width = 24,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 64,
          name = "",
          type = "",
          shape = "rectangle",
          x = 568,
          y = 566,
          width = 24,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 65,
          name = "",
          type = "",
          shape = "rectangle",
          x = 570,
          y = 486,
          width = 24,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 57,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 730,
          width = 24,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 58,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1090,
          y = 648,
          width = 24,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 59,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1090,
          y = 568,
          width = 24,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 60,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1090,
          y = 486,
          width = 24,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 67,
          name = "",
          type = "",
          shape = "polygon",
          x = 936,
          y = 336,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = -16 },
            { x = 18, y = -16 }
          },
          properties = {}
        },
        {
          id = 68,
          name = "",
          type = "",
          shape = "polygon",
          x = 700,
          y = 336,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = -16 },
            { x = -18, y = -16 }
          },
          properties = {}
        },
        {
          id = 69,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 336,
          width = 48,
          height = 14,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 70,
          name = "",
          type = "",
          shape = "polygon",
          x = 848,
          y = 336,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = 14 },
            { x = 14, y = 0 }
          },
          properties = {}
        },
        {
          id = 71,
          name = "",
          type = "",
          shape = "polygon",
          x = 800,
          y = 336,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = 14 },
            { x = -14, y = 0 }
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
          id = 2,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 760,
          y = 1240,
          width = 160,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["exit_sound"] = "doorclose",
            ["facing"] = "down",
            ["map"] = "light/hometown/church/entrance",
            ["marker"] = "entrymain",
            ["sound"] = "dooropen"
          }
        },
        {
          id = 72,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 1040,
          y = 280,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "church.door"
          }
        },
        {
          id = 66,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 700,
          y = 320,
          width = 236,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "church.organ",
            ["solid"] = true
          }
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 400,
          width = 80,
          height = 96,
          rotation = 0,
          gid = 115,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 702,
          y = 1058,
          width = 276,
          height = 100,
          rotation = 0,
          gid = 119,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 846,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 28,
          name = "",
          type = "",
          shape = "rectangle",
          x = 566,
          y = 846,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 29,
          name = "",
          type = "",
          shape = "rectangle",
          x = 566,
          y = 764,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 30,
          name = "",
          type = "",
          shape = "rectangle",
          x = 566,
          y = 682,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 31,
          name = "",
          type = "",
          shape = "rectangle",
          x = 566,
          y = 600,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 32,
          name = "",
          type = "",
          shape = "rectangle",
          x = 566,
          y = 518,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 24,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 764,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 25,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 682,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 26,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 600,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 27,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 518,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 33,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 840,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 113,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 34,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 760,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 113,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 35,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 680,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 113,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 36,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 600,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 113,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 37,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 520,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 113,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 38,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 520,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 113,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 39,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 600,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 113,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 40,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 680,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 113,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 41,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 760,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 113,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 42,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 840,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 113,
          visible = true,
          properties = {
            ["day"] = 1
          }
        },
        {
          id = 98,
          name = "",
          type = "",
          shape = "rectangle",
          x = 702,
          y = 1058,
          width = 276,
          height = 100,
          rotation = 0,
          gid = 144,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 103,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 842,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 147,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 104,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 760,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 148,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 105,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 682,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 147,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 107,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 600,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 150,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 108,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 522,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 149,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 109,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 520,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 151,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 112,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 600,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 148,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 113,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 680,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 148,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 114,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 760,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 148,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 115,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 840,
          width = 200,
          height = 68,
          rotation = 0,
          gid = 148,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 118,
          name = "",
          type = "",
          shape = "rectangle",
          x = 566,
          y = 518,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 145,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 119,
          name = "",
          type = "",
          shape = "rectangle",
          x = 566,
          y = 600,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 145,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 120,
          name = "",
          type = "",
          shape = "rectangle",
          x = 566,
          y = 682,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 145,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 121,
          name = "",
          type = "",
          shape = "rectangle",
          x = 566,
          y = 764,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 145,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 122,
          name = "",
          type = "",
          shape = "rectangle",
          x = 566,
          y = 846,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 145,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 123,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 846,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 145,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 124,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 764,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 145,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 125,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 682,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 145,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 126,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 600,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 145,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 127,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 518,
          width = 30,
          height = 78,
          rotation = 0,
          gid = 152,
          visible = true,
          properties = {
            ["night"] = 1
          }
        },
        {
          id = 128,
          name = "",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 400,
          width = 80,
          height = 96,
          rotation = 0,
          gid = 146,
          visible = true,
          properties = {
            ["night"] = 1
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
          id = 3,
          name = "spawn",
          type = "",
          shape = "point",
          x = 840,
          y = 1220,
          width = 0,
          height = 0,
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
      name = "controllers",
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
          id = 74,
          name = "hometowndaynight",
          type = "",
          shape = "point",
          x = 0,
          y = 0,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["palette"] = "world/church_palette"
          }
        }
      }
    },
    {
      type = "imagelayer",
      image = "../../../../../../../assets/sprites/world/maps/hometown/church/main_light.png",
      id = 7,
      name = "light",
      class = "",
      visible = true,
      opacity = 0.1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      repeatx = false,
      repeaty = false,
      properties = {}
    }
  }
}
