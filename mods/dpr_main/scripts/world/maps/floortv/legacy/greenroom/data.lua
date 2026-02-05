return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 36,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 25,
  nextobjectid = 224,
  properties = {
    ["border"] = "greenroomold",
    ["music"] = "lost_room",
    ["name"] = "Abndnd Green Room"
  },
  tilesets = {
    {
      name = "greenroom",
      firstgid = 1,
      filename = "../../../../tilesets/greenroom.tsx",
      exportfilename = "../../../../tilesets/greenroom.lua"
    },
    {
      name = "floor3_objects",
      firstgid = 127,
      filename = "../../../../tilesets/floor3-objects.tsx",
      exportfilename = "../../../../tilesets/floor3-objects.lua"
    },
    {
      name = "bg_ch3_dw_changing_room_tileset",
      firstgid = 177,
      filename = "../../../../tilesets/bg_ch3_dw_changing_room_tileset.tsx",
      exportfilename = "../../../../tilesets/bg_ch3_dw_changing_room_tileset.lua"
    }
  },
  layers = {
    {
      type = "imagelayer",
      image = "../../../../../../assets/sprites/world/maps/floor3/sloppy/changing_room_floor.png",
      id = 19,
      name = "Image Layer 1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      repeatx = true,
      repeaty = false,
      properties = {}
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 36,
      height = 12,
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
        21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
        21, 21, 21, 243, 244, 303, 245, 246, 554, 309, 309, 309, 317, 318, 0, 0, 0, 0, 0, 0, 0, 0, 0, 247, 248, 249, 250, 251, 309, 309, 309, 315, 316, 21, 21, 21,
        21, 21, 0, 274, 275, 303, 276, 277, 554, 309, 309, 309, 348, 349, 0, 0, 0, 0, 0, 0, 0, 0, 0, 278, 279, 280, 281, 282, 309, 309, 309, 346, 347, 0, 21, 21,
        21, 0, 0, 334, 334, 335, 334, 336, 585, 340, 340, 340, 379, 380, 0, 0, 0, 0, 0, 0, 0, 0, 0, 340, 340, 340, 340, 340, 340, 340, 340, 377, 378, 0, 0, 21,
        21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        21, 21, 21, 21, 21, 21, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 21, 21, 21, 21, 21, 21,
        21, 21, 21, 21, 21, 21, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 21, 21, 21, 21, 21, 21,
        21, 21, 21, 21, 21, 21, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 21, 21, 21, 21, 21, 21,
        21, 21, 21, 21, 21, 21, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 21, 21, 21, 21, 21, 21,
        21, 21, 21, 21, 21, 21, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 21, 21, 21, 21, 21, 21,
        21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 20,
      name = "objects_storage",
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
          id = 196,
          name = "",
          type = "",
          shape = "rectangle",
          x = 550,
          y = 160,
          width = 390,
          height = 120,
          rotation = 0,
          gid = 170,
          visible = true,
          properties = {}
        },
        {
          id = 197,
          name = "changing_room_star",
          type = "",
          shape = "point",
          x = 380,
          y = 100,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["sinerindex"] = 0,
            ["starindex"] = 1
          }
        },
        {
          id = 198,
          name = "changing_room_star",
          type = "",
          shape = "point",
          x = 500,
          y = 120,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["sinerindex"] = 1,
            ["starindex"] = 2
          }
        },
        {
          id = 199,
          name = "changing_room_star",
          type = "",
          shape = "point",
          x = 980,
          y = 90,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["sinerindex"] = 2,
            ["starindex"] = 3
          }
        },
        {
          id = 200,
          name = "changing_room_star",
          type = "",
          shape = "point",
          x = 1100,
          y = 110,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["sinerindex"] = 3,
            ["starindex"] = 4
          }
        },
        {
          id = 201,
          name = "changing_room_star",
          type = "",
          shape = "point",
          x = 1160,
          y = 90,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["sinerindex"] = 4,
            ["starindex"] = 5
          }
        },
        {
          id = 202,
          name = "changing_room_star",
          type = "",
          shape = "point",
          x = 1240,
          y = 100,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["sinerindex"] = 5,
            ["starindex"] = 6
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
      opacity = 0.5,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 105,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1080,
          y = 120,
          width = 240,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 108,
          name = "",
          type = "",
          shape = "polygon",
          x = 80,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -40, y = 40 },
            { x = -40, y = 0 }
          },
          properties = {}
        },
        {
          id = 110,
          name = "",
          type = "",
          shape = "polygon",
          x = 120,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -40, y = 40 },
            { x = -40, y = 0 }
          },
          properties = {}
        },
        {
          id = 111,
          name = "",
          type = "",
          shape = "polygon",
          x = 1400,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -40, y = -40 },
            { x = 0, y = -40 }
          },
          properties = {}
        },
        {
          id = 112,
          name = "",
          type = "",
          shape = "polygon",
          x = 1360,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -40, y = -40 },
            { x = 0, y = -40 }
          },
          properties = {}
        },
        {
          id = 114,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 240,
          width = 240,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 115,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 280,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 116,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1160,
          y = 240,
          width = 240,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 118,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 440,
          width = 960,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 119,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1160,
          y = 280,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 120,
          name = "",
          type = "",
          shape = "rectangle",
          x = 940,
          y = 120,
          width = 60,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 121,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 120,
          width = 430,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 123,
          name = "",
          type = "",
          shape = "rectangle",
          x = 550,
          y = 120,
          width = 390,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 14,
      name = "controllers",
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
      type = "objectgroup",
      draworder = "topdown",
      id = 16,
      name = "objects_door",
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
          id = 193,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 240,
          width = 82,
          height = 204,
          rotation = 0,
          gid = 154,
          visible = true,
          properties = {}
        },
        {
          id = 194,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1320,
          y = 240,
          width = 82,
          height = 204,
          rotation = 0,
          gid = 2147483802,
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
          id = 168,
          name = "spawn",
          type = "",
          shape = "point",
          x = 720,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 169,
          name = "fakespawn",
          type = "",
          shape = "point",
          x = 1280,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 170,
          name = "entrydown",
          type = "",
          shape = "point",
          x = 1040,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 189,
          name = "entry_left",
          type = "",
          shape = "point",
          x = 160,
          y = 200,
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
          id = 175,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 584,
          y = 110,
          width = 100,
          height = 40,
          rotation = 0,
          visible = false,
          properties = {
            ["solid"] = false,
            ["text1"] = "* (An empty shelf, devoid of glass bottles.)"
          }
        },
        {
          id = 125,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 272,
          width = 80,
          height = 68,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text1"] = "* (Once green and comfortable,[wait:5] now a husk of its former self.)"
          }
        },
        {
          id = 126,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 272,
          width = 200,
          height = 48,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text1"] = "* (Once green and comfortable,[wait:5] now a husk of its former self.)"
          }
        },
        {
          id = 129,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 272,
          width = 80,
          height = 68,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text1"] = "* (The sofa lies in disuse.)[wait:5]\n* (It almost certainly is a cockroach home.)"
          }
        },
        {
          id = 127,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 760,
          y = 272,
          width = 200,
          height = 48,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text1"] = "* (The sofa lies in disuse.)[wait:5]\n* (It almost certainly is a cockroach home.)"
          }
        },
        {
          id = 130,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 400,
          width = 116,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text1"] = "* (The TV's screen has been smashed in.)[wait:5]\n* (It's completely unusable.)"
          }
        },
        {
          id = 131,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 400,
          width = 116,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text1"] = "* (The TV's screen has been smashed in.)[wait:5]\n* (It's completely unusable.)"
          }
        },
        {
          id = 132,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 660,
          y = 400,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["once"] = false,
            ["solid"] = true,
            ["text1"] = "* (The platter has been permanently emptied.)"
          }
        },
        {
          id = 182,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 1000,
          y = 138,
          width = 80,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/legacy/corridors1",
            ["marker"] = "entry4"
          }
        },
        {
          id = 188,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 160,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/legacy/corridors3",
            ["marker"] = "entry_greenroom"
          }
        },
        {
          id = 204,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1000,
          y = 160,
          width = 76,
          height = 104,
          rotation = 0,
          gid = 153,
          visible = true,
          properties = {}
        },
        {
          id = 205,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 440,
          width = 116,
          height = 102,
          rotation = 0,
          gid = 158,
          visible = true,
          properties = {}
        },
        {
          id = 206,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 440,
          width = 116,
          height = 102,
          rotation = 0,
          gid = 158,
          visible = true,
          properties = {}
        },
        {
          id = 211,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 340,
          width = 280,
          height = 100,
          rotation = 0,
          gid = 171,
          visible = true,
          properties = {}
        },
        {
          id = 212,
          name = "",
          type = "",
          shape = "rectangle",
          x = 760,
          y = 340,
          width = 280,
          height = 100,
          rotation = 0,
          gid = 172,
          visible = true,
          properties = {}
        },
        {
          id = 213,
          name = "",
          type = "",
          shape = "rectangle",
          x = 660,
          y = 440,
          width = 120,
          height = 72,
          rotation = 0,
          gid = 173,
          visible = true,
          properties = {}
        },
        {
          id = 214,
          name = "",
          type = "",
          shape = "rectangle",
          x = 660,
          y = 440,
          width = 120,
          height = 72,
          rotation = 0,
          gid = 174,
          visible = true,
          properties = {}
        },
        {
          id = 219,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 170,
          width = 62,
          height = 88,
          rotation = 0,
          gid = 155,
          visible = true,
          properties = {}
        },
        {
          id = 220,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 130,
          width = 62,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (A vending machine in a rough state.)\n* (Unusable at this point.)"
          }
        },
        {
          id = 222,
          name = "",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 440,
          width = 63,
          height = 80,
          rotation = 0,
          gid = 175,
          visible = true,
          properties = {}
        },
        {
          id = 223,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1100,
          y = 440,
          width = 60,
          height = 80,
          rotation = 0,
          gid = 176,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 17,
      name = "objects_platter",
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
      type = "objectgroup",
      draworder = "topdown",
      id = 18,
      name = "objects_fg",
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
      type = "imagelayer",
      image = "../../../../../../assets/sprites/world/maps/floor3/sloppy/overlay.png",
      id = 24,
      name = "overlay",
      class = "",
      visible = true,
      opacity = 0.4,
      offsetx = 0,
      offsety = 0,
      parallaxx = 0,
      parallaxy = 0,
      tintcolor = { 0, 0, 0 },
      repeatx = false,
      repeaty = false,
      properties = {}
    }
  }
}
