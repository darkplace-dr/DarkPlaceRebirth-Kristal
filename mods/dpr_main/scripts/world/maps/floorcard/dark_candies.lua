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
  nextlayerid = 6,
  nextobjectid = 19,
  properties = {
    ["border"] = "field",
    ["music"] = "deltarune/field_of_hopes"
  },
  tilesets = {
    {
      name = "darkfield_tiles",
      firstgid = 1,
      filename = "../../tilesets/darkfield_tiles.tsx"
    },
    {
      name = "other-objects",
      firstgid = 73,
      filename = "../../tilesets/other-objects.tsx",
      exportfilename = "../../tilesets/other-objects.lua"
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 1, 1, 1, 13, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 1, 1, 1, 13, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 1, 1, 1, 13, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 1, 1, 1, 13, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 1, 1, 1, 13, 0, 0,
        0, 0, 0, 20, 20, 20, 20, 20, 20, 21, 1, 1, 1, 13, 0, 0,
        0, 0, 15, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 13, 0, 0,
        0, 0, 15, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 13, 0, 0,
        0, 0, 15, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 13, 0, 0,
        0, 0, 15, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 13, 0, 0,
        0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "objects_bg",
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
          name = "candytree",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 60,
          width = 140,
          height = 164,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "purplegrass",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 240,
          width = 400,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "purplegrass",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 0,
          width = 120,
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
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 0,
          width = 40,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 200,
          width = 40,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 400,
          width = 480,
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
          x = 520,
          y = 0,
          width = 40,
          height = 400,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 200,
          width = 240,
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
          id = 14,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 400,
          y = -40,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floorcard/junction_1",
            ["marker"] = "entry_up"
          }
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 240,
          width = 40,
          height = 40,
          rotation = 0,
          gid = 77,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 200,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text1"] = "* (These types of trees DON'T contain an item that can heal you.)",
            ["text2"] = "* (Whatever you do,[wait:5] DON'T check the tree and use [bind:menu] to open your menu!)",
            ["text3"] = "* (You got it!?)\n* (SIGNED,[wait:5] LANCER)"
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
          id = 12,
          name = "spawn",
          type = "",
          shape = "point",
          x = 440,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "entry_down",
          type = "",
          shape = "point",
          x = 460,
          y = 80,
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
