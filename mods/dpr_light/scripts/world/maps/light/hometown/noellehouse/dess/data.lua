return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 9,
  nextobjectid = 38,
  properties = {
    ["border"] = "leaves",
    ["inside"] = true,
    ["light"] = true,
    ["music"] = "deltarune/noelle_distant"
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
      image = "../../../../../../../assets/sprites/world/maps/hometown/noellehouse/dess.png",
      id = 4,
      name = "bg",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = -40,
      offsety = 40,
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
      name = "objects_deco",
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
          x = 46,
          y = 308,
          width = 160,
          height = 182,
          rotation = 0,
          gid = 91,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 92,
          y = 140,
          width = 56,
          height = 32,
          rotation = 0,
          gid = 118,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
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
          type = "",
          shape = "rectangle",
          x = 0,
          y = 200,
          width = 40,
          height = 280,
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
          y = 200,
          width = 40,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 330,
          y = 440,
          width = 190,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 440,
          width = 210,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 200,
          width = 480,
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
          x = 40,
          y = 240,
          width = 166,
          height = 46,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 154,
          y = 286,
          width = 34,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = 466,
          y = 408,
          width = 44,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "",
          type = "",
          shape = "rectangle",
          x = 500,
          y = 268,
          width = 20,
          height = 56,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 25,
          name = "",
          type = "",
          shape = "rectangle",
          x = 482,
          y = 324,
          width = 38,
          height = 46,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 26,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 348,
          width = 50,
          height = 92,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 27,
          name = "",
          type = "",
          shape = "rectangle",
          x = 90,
          y = 402,
          width = 108,
          height = 38,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 28,
          name = "",
          type = "",
          shape = "rectangle",
          x = 338,
          y = 398,
          width = 104,
          height = 42,
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
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 334,
          y = 440,
          width = 116,
          height = 64,
          rotation = 0,
          gid = 92,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 458,
          y = 440,
          width = 58,
          height = 50,
          rotation = 0,
          gid = 93,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 476,
          y = 380,
          width = 48,
          height = 136,
          rotation = 0,
          gid = 95,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 250,
          y = 480,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["exit_sound"] = "doorclose",
            ["facing"] = "down",
            ["map"] = "light/hometown/noellehouse/main",
            ["marker"] = "entrydess",
            ["sound"] = "dooropen"
          }
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 46,
          y = 440,
          width = 156,
          height = 92,
          rotation = 0,
          gid = 94,
          visible = true,
          properties = {}
        },
        {
          id = 29,
          name = "dess_guitar",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 184,
          width = 36,
          height = 68,
          rotation = 0,
          visible = true,
          properties = {
            ["flagcheck"] = "!dess_guitar_stolen"
          }
        },
        {
          id = 30,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 66,
          y = 228,
          width = 124,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text1"] = "* (It's Dess's bed. Underneath are army rations,[wait:5] guitar picks,[wait:5] paintball gear,[wait:5] ice skates...)",
            ["text2"] = "* (...[wait:5] and a badly traced drawing of a dragon.)"
          }
        },
        {
          id = 31,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 344,
          y = 404,
          width = 94,
          height = 28,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (It's a CD player. Underneath are tons of punk rock CDs...[wait:5] and one still-sealed ska CD.)"
          }
        },
        {
          id = 32,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 102,
          y = 402,
          width = 76,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (It's a computer. The monitor is unplugged.)"
          }
        },
        {
          id = 33,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 48,
          y = 358,
          width = 36,
          height = 72,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "noellehouse.dess_shelf"
          }
        },
        {
          id = 34,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 496,
          y = 278,
          width = 26,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* Rollerblades,[wait:5] wiffle bat. Looking at these things make your head hurt."
          }
        },
        {
          id = 35,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 228,
          y = 176,
          width = 156,
          height = 50,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (It's an excessively large walk-in closet.)"
          }
        },
        {
          id = 36,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 466,
          y = 410,
          width = 42,
          height = 28,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "noellehouse.dess_box"
          }
        },
        {
          id = 37,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 486,
          y = 332,
          width = 26,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {
            ["text1"] = "* A violin,[wait:5] a flute,[wait:5] a microphone...",
            ["text2"] = "* They all look very expensive,[wait:5] and very dented."
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
          id = 15,
          name = "spawn",
          type = "",
          shape = "point",
          x = 290,
          y = 450,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "entry",
          type = "",
          shape = "point",
          x = 290,
          y = 458,
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
