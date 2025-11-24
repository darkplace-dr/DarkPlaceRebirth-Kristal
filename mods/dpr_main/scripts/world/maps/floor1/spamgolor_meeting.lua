return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 23,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 5,
  nextobjectid = 22,
  properties = {
    ["border"] = "mainhub"
  },
  tilesets = {
    {
      name = "main_area",
      firstgid = 1,
      class = "",
      tilewidth = 20,
      tileheight = 20,
      spacing = 0,
      margin = 0,
      columns = 13,
      image = "../../../../assets/sprites/tilesets/main_area.png",
      imagewidth = 260,
      imageheight = 320,
      objectalignment = "unspecified",
      tilerendersize = "grid",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 40,
        height = 40
      },
      properties = {},
      wangsets = {},
      tilecount = 208,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 23,
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
        54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54,
        67, 67, 67, 67, 67, 67, 53, 54, 54, 54, 54, 54, 54, 54, 54, 54, 55, 67, 67, 67, 67, 67, 67,
        80, 80, 80, 80, 80, 80, 53, 54, 54, 54, 54, 54, 54, 54, 54, 54, 55, 80, 80, 80, 80, 80, 80,
        93, 93, 93, 93, 93, 93, 53, 54, 54, 54, 54, 54, 54, 54, 54, 54, 55, 93, 93, 93, 93, 93, 93,
        2, 2, 2, 2, 2, 5, 66, 67, 67, 67, 67, 67, 67, 67, 67, 67, 68, 4, 2, 2, 2, 2, 2,
        28, 28, 28, 28, 15, 16, 79, 80, 80, 80, 80, 80, 80, 80, 80, 80, 81, 14, 15, 28, 28, 28, 28,
        0, 0, 0, 0, 14, 16, 92, 93, 93, 93, 93, 93, 93, 93, 93, 93, 94, 14, 16, 0, 0, 0, 0,
        0, 0, 0, 0, 14, 15, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 15, 16, 0, 0, 0, 0,
        0, 0, 0, 0, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 0, 0, 0, 0,
        0, 0, 0, 0, 27, 28, 28, 28, 28, 28, 15, 15, 28, 28, 28, 28, 28, 28, 29, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "collision",
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
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 240,
          width = 160,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 160,
          width = 440,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 400,
          width = 280,
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
          x = 480,
          y = 440,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 440,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 400,
          width = 240,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 760,
          y = 240,
          width = 160,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 120,
          width = 920,
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
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 6,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -40,
          y = 160,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floor1/main",
            ["marker"] = "east1"
          }
        },
        {
          id = 20,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 520,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floor1/fluffys_palace",
            ["marker"] = "entry"
          }
        },
        {
          id = 15,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 920,
          y = 160,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floor1/traininggrounds",
            ["marker"] = "entry"
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
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 8,
          name = "west",
          type = "",
          shape = "point",
          x = 40,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "spawn",
          type = "",
          shape = "point",
          x = 200,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "east",
          type = "",
          shape = "point",
          x = 880,
          y = 200,
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
