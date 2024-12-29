return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.11.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 6,
  nextobjectid = 11,
  properties = {
    ["music"] = "slider"
  },
  tilesets = {
    {
      name = "bg_darktiles1",
      firstgid = 1,
      filename = "../tilesets/bg_darktiles1.tsx",
      exportfilename = "../tilesets/bg_darktiles1.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 0,
        0, 7, 8, 13, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 0,
        0, 7, 8, 8, 8, 11, 8, 8, 13, 8, 8, 11, 8, 8, 9, 0,
        0, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 13, 8, 8, 9, 0,
        0, 7, 6, 8, 8, 8, 8, 11, 8, 8, 8, 8, 8, 11, 8, 3,
        0, 7, 8, 8, 8, 8, 8, 8, 8, 6, 8, 8, 8, 8, 13, 13,
        0, 7, 8, 8, 11, 13, 8, 8, 8, 8, 8, 8, 8, 8, 9, 18,
        0, 12, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 14, 23,
        0, 17, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 19, 23,
        0, 22, 23, 23, 23, 23, 5, 23, 23, 23, 23, 23, 10, 23, 24, 23,
        0, 22, 10, 23, 23, 23, 23, 23, 23, 23, 5, 23, 23, 23, 24, 23
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
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
          x = 0,
          y = 0,
          width = 640,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 40,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 280,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 40,
          width = 40,
          height = 320,
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
          y = 360,
          width = 640,
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
          id = 7,
          name = "spawn",
          type = "",
          shape = "point",
          x = 160,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "slider",
          type = "",
          shape = "point",
          x = 600,
          y = 240,
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
          id = 9,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 200,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "slider",
            ["marker"] = "entry"
          }
        },
        {
          id = 10,
          name = "interactable",
          type = "",
          shape = "point",
          x = 240,
          y = 40,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "slider.fonttest",
            ["once"] = false
          }
        }
      }
    }
  }
}
