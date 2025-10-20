return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 6,
  nextobjectid = 16,
  properties = {
    ["border"] = "white",
    ["music"] = "gimmieyourwalletmiss",
    ["name"] = "Dess - THE FIRST HALF"
  },
  tilesets = {
    {
      name = "whitespace",
      firstgid = 1,
      filename = "../../tilesets/whitespace.tsx",
      exportfilename = "../../tilesets/whitespace.lua"
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
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 7, 8,
        5, 5, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 4, 5, 5, 8, 8, 8, 8, 8, 8, 8, 8, 9, 2, 2,
        5, 5, 4, 5, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 4, 5, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 4, 5, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
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
          class = "",
          shape = "rectangle",
          x = 200,
          y = 360,
          width = 360,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          class = "",
          shape = "rectangle",
          x = 560,
          y = 320,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          class = "",
          shape = "rectangle",
          x = 560,
          y = 240,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          class = "",
          shape = "rectangle",
          x = 80,
          y = 200,
          width = 480,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          class = "",
          shape = "rectangle",
          x = 40,
          y = 240,
          width = 40,
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
      id = 5,
      name = "paths",
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
          name = "ufoofdoom",
          class = "",
          shape = "ellipse",
          x = 240,
          y = 200,
          width = 320,
          height = 160,
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
          id = 11,
          name = "enemy",
          class = "",
          shape = "rectangle",
          x = 380,
          y = 260,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "ufoofdoom",
            ["aura"] = false,
            ["chase"] = false,
            ["encounter"] = "ufoofdooms",
            ["once"] = true,
            ["path"] = "ufoofdoom",
            ["progress"] = "-0.1"
          }
        },
        {
          id = 13,
          name = "transition",
          class = "",
          shape = "rectangle",
          x = 40,
          y = 480,
          width = 200,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "dessstuff/dessstart",
            ["marker"] = "entry"
          }
        },
        {
          id = 14,
          name = "transition",
          class = "",
          shape = "rectangle",
          x = 640,
          y = 240,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "dessstuff/desssecondhalf",
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
          class = "",
          shape = "point",
          x = 140,
          y = 310,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "entry",
          class = "",
          shape = "point",
          x = 140,
          y = 470,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "entry_2",
          class = "",
          shape = "point",
          x = 610,
          y = 310,
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
