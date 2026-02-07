return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 20,
  height = 16,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 5,
  nextobjectid = 18,
  properties = {
    ["music"] = "forgottenbone"
  },
  tilesets = {},
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 16,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
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
          name = "npc",
          type = "",
          shape = "point",
          x = 360,
          y = 400,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "snowtree",
            ["cutscene"] = "cyber.snowtree"
          }
        },
        {
          id = 15,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 420,
          width = 80,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["flagcheck"] = "!snowtreetalk",
            ["text"] = "* He is behind the tree."
          }
        },
        {
          id = 17,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 0,
          width = 160,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "floorcyber/cyber_store",
            ["marker"] = "marker2"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "collisions",
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
          x = 0,
          y = 0,
          width = 320,
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
          y = 0,
          width = 320,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "polygon",
          x = 600,
          y = 120,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 120, y = 120 },
            { x = 200, y = 120 },
            { x = 200, y = 0 }
          },
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 720,
          y = 240,
          width = 80,
          height = 400,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "polygon",
          x = 200,
          y = 120,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -120, y = 120 },
            { x = -200, y = 120 },
            { x = -200, y = 0 }
          },
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 240,
          width = 80,
          height = 400,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "polygon",
          x = 80,
          y = 480,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 80, y = 80 },
            { x = 80, y = 160 },
            { x = 0, y = 160 }
          },
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 560,
          width = 480,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "polygon",
          x = 720,
          y = 480,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -80, y = 80 },
            { x = -80, y = 160 },
            { x = 0, y = 160 }
          },
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 340,
          y = 380,
          width = 120,
          height = 60,
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
          id = 14,
          name = "entry",
          type = "",
          shape = "point",
          x = 400,
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
