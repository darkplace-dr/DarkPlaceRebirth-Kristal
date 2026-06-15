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
  nextlayerid = 8,
  nextobjectid = 33,
  properties = {
    ["border"] = "",
    ["music"] = "deltarune/mike_zone",
    ["name"] = "MIKE ZONE",
    ["quietpipis"] = true
  },
  tilesets = {
    {
      name = "ch3_dw_tvland_stage",
      firstgid = 1,
      filename = "../../../../tilesets/ch3_dw_tvland_stage.tsx"
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "objects_floor",
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
          name = "greenroom_floor",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
      id = 1,
      name = "floor",
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
        36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
        36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
        36, 36, 36, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        36, 36, 36, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        36, 36, 36, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        36, 36, 36, 36, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259, 259,
        36, 36, 36, 36, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236,
        36, 36, 36, 36, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236,
        36, 36, 36, 36, 236, 236, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
        36, 36, 36, 36, 236, 236, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
        36, 36, 36, 36, 236, 236, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
        36, 36, 36, 36, 236, 236, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
      name = "objects_below",
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
          name = "greenroom_wall",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 80,
          width = 480,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {
            ["speed"] = 0.4
          }
        }
      }
    },
    {
      type = "imagelayer",
      image = "../../../../../../assets/sprites/world/maps/floor3/sloppy/overlay.png",
      id = 7,
      name = "overlay",
      class = "",
      visible = true,
      opacity = 0.4,
      offsetx = 0,
      offsety = 0,
      parallaxx = 0,
      parallaxy = 0,
      tintcolor = { 0, 0, 76 },
      repeatx = false,
      repeaty = false,
      properties = {}
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "objects_party",
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
          id = 20,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 480,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["exit_delay"] = 0.3,
            ["exit_sound"] = "doorclose",
            ["map"] = "floortv/placeholder_mike_entrance",
            ["marker"] = "entry",
            ["sound"] = "dooropen"
          }
        },
        {
          id = 23,
          name = "mike_statue",
          type = "",
          shape = "rectangle",
          x = 510,
          y = 138,
          width = 58,
          height = 116,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "mike_statue",
          type = "",
          shape = "rectangle",
          x = 330,
          y = 138,
          width = 58,
          height = 116,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 25,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 338,
          y = 208,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (It's a statue.)"
          }
        },
        {
          id = 32,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 518,
          y = 208,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* (It's a statue.)"
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
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 200,
          width = 480,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 320,
          width = 400,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
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
          id = 19,
          name = "spawn",
          type = "",
          shape = "point",
          x = 200,
          y = 300,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "entry",
          type = "",
          shape = "point",
          x = 200,
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
