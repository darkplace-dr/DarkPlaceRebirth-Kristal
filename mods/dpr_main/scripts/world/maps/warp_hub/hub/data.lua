return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.11.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 13,
  properties = {
    ["music"] = "warphub"
  },
  tilesets = {
    {
      name = "space",
      firstgid = 1,
      filename = "../../../tilesets/space.tsx",
      exportfilename = "../../../tilesets/space.lua"
    },
    {
      name = "main_area",
      firstgid = 13,
      filename = "../../../tilesets/main_area.tsx",
      exportfilename = "../../../tilesets/main_area.lua"
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "objects_bg",
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
        0, 0, 0, 0, 0, 0, 87, 87, 87, 87, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 74, 74, 74, 74, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 87, 87, 87, 87, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 0, 0, 0,
        0, 0, 0, 4, 5, 5, 5, 5, 5, 5, 5, 5, 6, 0, 0, 0,
        0, 0, 0, 4, 5, 5, 5, 5, 5, 5, 5, 5, 6, 0, 0, 0,
        0, 0, 0, 4, 5, 5, 5, 5, 5, 5, 5, 5, 6, 0, 0, 0,
        0, 0, 0, 4, 5, 5, 5, 5, 5, 5, 5, 5, 6, 0, 0, 0,
        0, 0, 0, 7, 8, 8, 8, 8, 8, 8, 8, 8, 9, 0, 0, 0,
        0, 0, 0, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 0, 0, 0,
        0, 0, 0, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 0, 0, 0,
        0, 0, 0, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
      id = 6,
      name = "Tile Layer 2",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 20,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 74, 74, 74, 74, 74, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 87, 87, 87, 87, 87, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 74, 74, 74, 74, 74, 0, 0, 0, 0, 0, 0,
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
          x = 320,
          y = 320,
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
          id = 5,
          name = "warpbin",
          type = "",
          shape = "rectangle",
          x = 260,
          y = 220,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["skin"] = "cyber_city"
          }
        },
        {
          id = 7,
          name = "space_bg",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 0,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "npc",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 112,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "diamond_giant",
            ["cutscene"] = "warp_hub.diamond_store",
            ["sprite"] = "hole_empty"
          }
        },
        {
          id = 11,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 40,
          width = 160,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "warp_hub.bin_codes"
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
          x = 80,
          y = 120,
          width = 40,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 360,
          width = 400,
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
          x = 520,
          y = 120,
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
          x = 120,
          y = 80,
          width = 400,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
