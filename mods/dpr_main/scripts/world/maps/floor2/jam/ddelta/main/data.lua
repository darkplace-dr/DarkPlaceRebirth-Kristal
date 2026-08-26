return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.12.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 6,
  nextobjectid = 18,
  properties = {
    ["music"] = "megaton_kikky"
  },
  tilesets = {
    {
      name = "floor2",
      firstgid = 1,
      filename = "../../../../../tilesets/floor2.tsx",
      exportfilename = "../../../../../tilesets/floor2.lua"
    },
    {
      name = "jam26ddelta_kikkyworld_objects",
      firstgid = 171,
      filename = "../../../../../tilesets/jam26ddelta_kikkyworld_objects.tsx"
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
        4, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 5,
        20, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 18,
        20, 55, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 18,
        20, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 39, 18,
        20, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 18,
        20, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 18,
        20, 56, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 55, 18,
        20, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 18,
        20, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 18,
        20, 40, 41, 41, 41, 41, 41, 26, 27, 41, 41, 41, 41, 41, 42, 18,
        21, 2, 2, 2, 2, 2, 3, 23, 25, 1, 2, 2, 2, 2, 2, 22,
        0, 0, 0, 0, 0, 0, 20, 23, 25, 18, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
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
          x = 40,
          y = 400,
          width = 240,
          height = 80,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 400,
          width = 240,
          height = 80,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 280,
          width = 40,
          height = 160,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 280,
          width = 560,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 280,
          width = 40,
          height = 160,
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
      id = 2,
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
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 480,
          width = 80,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "floor2/jam/main",
            ["marker"] = "entry_room4"
          }
        },
        {
          id = 13,
          name = "jam26ddelta_kikkyscreen",
          type = "",
          shape = "point",
          x = 48,
          y = 48,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 282,
          y = 340,
          width = 76,
          height = 34,
          rotation = 0,
          opacity = 1,
          gid = 171,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 282,
          y = 320,
          width = 76,
          height = 20,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["cutscene"] = "kikkyworld.use_console",
            ["solid"] = true
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
          id = 11,
          name = "entry",
          type = "",
          shape = "point",
          x = 320,
          y = 460,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "spawn",
          type = "",
          shape = "point",
          x = 320,
          y = 380,
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
