return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 32,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 14,
  nextobjectid = 33,
  properties = {
    ["border"] = ""
  },
  tilesets = {
    {
      name = "floor3_objects",
      firstgid = 1,
      filename = "../../../../tilesets/floor3-objects.tsx",
      exportfilename = "../../../../tilesets/floor3-objects.lua"
    }
  },
  layers = {
    {
      type = "imagelayer",
      image = "../../../../../../assets/sprites/world/maps/floor3/nondescript_room/nondescript_room.png",
      id = 3,
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
      type = "imagelayer",
      image = "../../../../../../assets/sprites/world/maps/floor3/nondescript_room/nondescript_room_dark.png",
      id = 10,
      name = "bg_dark",
      class = "",
      visible = false,
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
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 126,
          y = 400,
          width = 1154,
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
          x = 86,
          y = 80,
          width = 40,
          height = 320,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 126,
          y = 80,
          width = 386,
          height = 122,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 512,
          y = 80,
          width = 768,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 8,
      name = "objects_nondistort",
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
          name = "",
          type = "",
          shape = "rectangle",
          x = 272,
          y = 294,
          width = 62,
          height = 76,
          rotation = 0,
          gid = 34,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 160,
          width = 78,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (Pale sunlight illuminates the dreary room.)"
          }
        },
        {
          id = 22,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 160,
          width = 74,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (It's an old poster featuring a monster movie.)"
          }
        },
        {
          id = 27,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 428,
          y = 202,
          width = 84,
          height = 110,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text"] = "* (This old bed has seen better days.)"
          }
        },
        {
          id = 28,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 272,
          y = 260,
          width = 62,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "tvfloor.chair_room_chair",
            ["solid"] = true
          }
        },
        {
          id = 30,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 1280,
          y = 320,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/legacy/corridors3",
            ["marker"] = "entry_chair"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 9,
      name = "objects_distort",
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
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 162,
          y = 168,
          width = 70,
          height = 78,
          rotation = 0,
          gid = 40,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 267,
          y = 298,
          width = 80,
          height = 86,
          rotation = 0,
          gid = 36,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 160,
          width = 74,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (You can't really tell,[wait:5] but it appears to be moving...)"
          }
        },
        {
          id = 25,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 160,
          width = 74,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (It's too dark to see anything outside.)"
          }
        },
        {
          id = 26,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 428,
          y = 202,
          width = 84,
          height = 110,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text"] = "* (It's vaguely bed-shaped.)"
          }
        },
        {
          id = 29,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 272,
          y = 260,
          width = 62,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "tvfloor.chair_room_chair",
            ["solid"] = true
          }
        },
        {
          id = 32,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 1280,
          y = 320,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floortv/legacy/corridors3",
            ["marker"] = "entry_chair"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 13,
      name = "objects_party",
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
          id = 6,
          name = "spawn",
          type = "",
          shape = "point",
          x = 300,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "entry_chair",
          type = "",
          shape = "point",
          x = 1240,
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
