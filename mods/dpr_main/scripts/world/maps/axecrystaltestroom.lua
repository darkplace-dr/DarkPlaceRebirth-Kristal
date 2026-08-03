return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 17,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 6,
  nextobjectid = 7,
  properties = {},
  tilesets = {
    {
      name = "topfloor",
      firstgid = 1,
      filename = "../tilesets/topfloor.tsx"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 17,
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
        34, 34, 34, 34, 34, 34, 1, 20, 2, 20, 3, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 7, 8, 8, 8, 9, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 7, 8, 8, 8, 9, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 13, 14, 14, 14, 15, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 19, 20, 20, 20, 21, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 25, 26, 26, 26, 27, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 25, 26, 26, 26, 27, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 25, 26, 26, 26, 27, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 25, 26, 26, 26, 27, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 25, 26, 26, 26, 27, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 25, 26, 26, 26, 27, 34, 34, 34, 34, 34, 34,
        34, 34, 34, 34, 34, 34, 25, 26, 26, 26, 27, 34, 34, 34, 34, 34, 34
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
          x = 200,
          y = 160,
          width = 40,
          height = 320,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 120,
          width = 200,
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
          x = 440,
          y = 160,
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
          x = 240,
          y = 480,
          width = 200,
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
      objects = {}
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "objects_crystal",
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
          name = "neocrystal",
          type = "",
          shape = "rectangle",
          x = 284,
          y = 80,
          width = 112,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {
            ["char"] = "susie",
            ["char_spr"] = "crystal_axe",
            ["flag"] = "susie_power_restored"
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
          id = 6,
          name = "spawn",
          type = "",
          shape = "point",
          x = 340,
          y = 440,
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
