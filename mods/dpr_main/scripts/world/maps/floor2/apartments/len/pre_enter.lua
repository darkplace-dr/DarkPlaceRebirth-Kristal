return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.12.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 6,
  nextobjectid = 14,
  properties = {
    ["music"] = "mainhub"
  },
  tilesets = {
    {
      name = "floor2",
      firstgid = 1,
      filename = "../../../../tilesets/floor2.tsx",
      exportfilename = "../../../../tilesets/floor2.lua"
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
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 20, 23, 24, 25, 18, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
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
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 0,
          width = 40,
          height = 480,
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
          x = 240,
          y = 0,
          width = 40,
          height = 480,
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
          name = "characterdoor",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 220,
          width = 120,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["chara"] = "len"
          }
        },
        {
          id = 6,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 480,
          width = 120,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "floor2/left",
            ["marker"] = "entry_pre_enter"
          }
        },
        {
          id = 13,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 280,
          y = -40,
          width = 120,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "floor2/apartments/len/main",
            ["marker"] = "entry_pre_enter"
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
          id = 4,
          name = "entry_left",
          type = "",
          shape = "point",
          x = 340,
          y = 460,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "entry_main",
          type = "",
          shape = "point",
          x = 340,
          y = 30,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "spawn",
          type = "",
          shape = "point",
          x = 340,
          y = 160,
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
