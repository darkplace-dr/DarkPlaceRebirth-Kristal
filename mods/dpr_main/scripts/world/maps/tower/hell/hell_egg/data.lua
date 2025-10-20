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
  nextlayerid = 5,
  nextobjectid = 15,
  properties = {},
  tilesets = {
    {
      name = "hell",
      firstgid = 1,
      filename = "../../../../tilesets/hell.tsx",
      exportfilename = "../../../../tilesets/hell.lua"
    },
    {
      name = "hell_objs",
      firstgid = 78,
      filename = "../../../../tilesets/hell_objs.tsx",
      exportfilename = "../../../../tilesets/hell_objs.lua"
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
        32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
        32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
        32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
        32, 32, 32, 32, 32, 32, 0, 0, 0, 0, 32, 32, 32, 32, 32, 32,
        32, 32, 32, 32, 32, 0, 0, 0, 0, 0, 0, 32, 32, 32, 32, 32,
        32, 32, 32, 32, 32, 0, 0, 0, 0, 0, 0, 32, 32, 32, 32, 32,
        32, 32, 32, 32, 32, 0, 0, 0, 0, 0, 0, 32, 32, 32, 32, 32,
        32, 32, 32, 32, 32, 32, 0, 0, 0, 0, 32, 32, 32, 32, 32, 32,
        32, 32, 32, 32, 32, 32, 32, 0, 0, 32, 32, 32, 32, 32, 32, 32,
        32, 32, 32, 32, 32, 32, 32, 0, 0, 32, 32, 32, 32, 32, 32, 32,
        32, 32, 32, 32, 32, 32, 32, 0, 0, 32, 32, 32, 32, 32, 32, 32,
        32, 32, 32, 32, 32, 32, 32, 0, 0, 32, 32, 32, 32, 32, 32, 32
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
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 320,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 320,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 280,
          width = 40,
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
          x = 440,
          y = 160,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
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
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 80,
          width = 160,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 120,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 160,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 280,
          width = 40,
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
          x = 244,
          y = 240,
          width = 180,
          height = 168,
          rotation = 0,
          gid = 79,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 220,
          width = 80,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text"] = "* It's a tree,[wait:5] as normal as ever."
          }
        },
        {
          id = 3,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 200,
          width = 80,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "tower_outside.egg",
            ["solid"] = true
          }
        },
        {
          id = 4,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 480,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "tower/hell/hell_3",
            ["marker"] = "entry_4"
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
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 14,
          name = "spawn",
          type = "",
          shape = "point",
          x = 320,
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
