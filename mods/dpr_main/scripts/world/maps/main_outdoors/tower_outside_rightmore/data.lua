return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 35,
  height = 20,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 16,
  nextobjectid = 155,
  properties = {
    ["border"] = "tower_outside",
    ["music"] = "mainhub_outside",
    ["notmusic"] = "sanctuarium_aeternum"
  },
  tilesets = {
    {
      name = "blue_grass_lol",
      firstgid = 1,
      class = "",
      tilewidth = 20,
      tileheight = 20,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../../../../../assets/sprites/tilesets/blue_grass_lol.png",
      imagewidth = 320,
      imageheight = 260,
      objectalignment = "unspecified",
      tilerendersize = "grid",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 40,
        height = 40
      },
      properties = {},
      wangsets = {},
      tilecount = 208,
      tiles = {}
    },
    {
      name = "main_area",
      firstgid = 209,
      class = "",
      tilewidth = 20,
      tileheight = 20,
      spacing = 0,
      margin = 0,
      columns = 13,
      image = "../../../../../assets/sprites/tilesets/main_area.png",
      imagewidth = 260,
      imageheight = 320,
      objectalignment = "unspecified",
      tilerendersize = "grid",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 40,
        height = 40
      },
      properties = {},
      wangsets = {},
      tilecount = 208,
      tiles = {}
    },
    {
      name = "cliffs",
      firstgid = 417,
      class = "",
      tilewidth = 20,
      tileheight = 20,
      spacing = 0,
      margin = 0,
      columns = 9,
      image = "../../../../../assets/sprites/tilesets/cliffs.png",
      imagewidth = 180,
      imageheight = 140,
      objectalignment = "unspecified",
      tilerendersize = "grid",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 20,
        height = 20
      },
      properties = {},
      wangsets = {},
      tilecount = 63,
      tiles = {}
    },
    {
      name = "hub_objects",
      firstgid = 480,
      class = "",
      tilewidth = 130,
      tileheight = 120,
      spacing = 0,
      margin = 0,
      columns = 0,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      wangsets = {},
      tilecount = 14,
      tiles = {
        {
          id = 0,
          image = "../../../../../assets/sprites/world/maps/hub/funfax_station.png",
          width = 77,
          height = 61
        },
        {
          id = 1,
          image = "../../../../../assets/sprites/world/events/money_hole.png",
          width = 30,
          height = 14
        },
        {
          id = 2,
          image = "../../../../../assets/sprites/world/maps/hub/desshouse.png",
          width = 120,
          height = 120
        },
        {
          id = 3,
          image = "../../../../../assets/sprites/world/maps/hub/plaque.png",
          width = 130,
          height = 66
        },
        {
          id = 6,
          image = "../../../../../assets/sprites/world/events/dark_stand.png",
          width = 41,
          height = 49
        },
        {
          id = 7,
          image = "../../../../../assets/sprites/world/events/light_stand.png",
          width = 41,
          height = 49
        },
        {
          id = 9,
          image = "../../../../../assets/sprites/world/events/mossy_stand.png",
          width = 41,
          height = 49
        },
        {
          id = 10,
          image = "../../../../../assets/sprites/world/events/void_fragment_1.png",
          width = 32,
          height = 32,
          animation = {
            {
              tileid = 10,
              duration = 200
            },
            {
              tileid = 11,
              duration = 200
            },
            {
              tileid = 12,
              duration = 200
            },
            {
              tileid = 13,
              duration = 200
            },
            {
              tileid = 11,
              duration = 200
            },
            {
              tileid = 12,
              duration = 200
            },
            {
              tileid = 13,
              duration = 200
            },
            {
              tileid = 12,
              duration = 200
            },
            {
              tileid = 11,
              duration = 200
            },
            {
              tileid = 10,
              duration = 200
            },
            {
              tileid = 13,
              duration = 200
            },
            {
              tileid = 11,
              duration = 200
            }
          }
        },
        {
          id = 11,
          image = "../../../../../assets/sprites/world/events/void_fragment_2.png",
          width = 32,
          height = 32
        },
        {
          id = 12,
          image = "../../../../../assets/sprites/world/events/void_fragment_3.png",
          width = 32,
          height = 32
        },
        {
          id = 13,
          image = "../../../../../assets/sprites/world/events/void_fragment_4.png",
          width = 32,
          height = 32
        },
        {
          id = 14,
          image = "../../../../../assets/sprites/world/events/blue_tree.png",
          width = 60,
          height = 60
        },
        {
          id = 15,
          image = "../../../../../assets/sprites/world/events/square_hole.png",
          width = 40,
          height = 30
        },
        {
          id = 16,
          image = "../../../../../assets/sprites/world/maps/hub/hub_vending.png",
          width = 30,
          height = 44
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 35,
      height = 20,
      id = 12,
      name = "back",
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 288, 0, 0, 0, 0, 0, 0, 0, 0, 0, 249, 249, 249, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1073741964, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        48, 48, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        48, 48, 48, 48, 48, 0, 0, 0, 0, 0, 48, 48, 0, 0, 0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        48, 48, 48, 48, 48, 48, 48, 0, 0, 48, 48, 48, 48, 0, 0, 0, 0, 0, 0, 48, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 35,
      height = 20,
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
        238, 288, 379, 288, 379, 288, 379, 288, 288, 288, 288, 288, 288, 288, 288, 288, 288, 288, 288, 288, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        288, 288, 379, 288, 379, 288, 379, 288, 288, 288, 288, 288, 288, 288, 288, 288, 288, 238, 288, 288, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        288, 238, 379, 288, 379, 288, 379, 288, 288, 288, 288, 288, 353, 354, 288, 288, 353, 354, 288, 288, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        238, 288, 379, 288, 379, 288, 379, 288, 288, 288, 238, 288, 366, 367, 288, 288, 366, 367, 288, 288, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        288, 0, 379, 367, 379, 288, 379, 288, 288, 288, 288, 288, 379, 380, 288, 288, 379, 380, 288, 288, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        288, 288, 379, 288, 379, 288, 379, 288, 288, 238, 288, 288, 379, 379, 210, 210, 210, 210, 210, 210, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        288, 288, 379, 288, 379, 238, 379, 288, 288, 288, 288, 2684354812, 379, 379, 236, 236, 223, 223, 223, 223, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 379, 379, 223, 223, 223, 210, 210, 210, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        89, 89, 108, 301, 392, 288, 379, 288, 288, 2684354812, 2684354812, 2684354812, 379, 379, 288, 288, 238, 288, 379, 379, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        105, 238, 105, 89, 108, 301, 392, 288, 2684354812, 2684354812, 2684354812, 238, 379, 1073742163, 288, 288, 288, 288, 379, 380, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        105, 105, 105, 105, 105, 89, 108, 2684354812, 2684354812, 2684354812, 288, 288, 0, 261, 288, 288, 288, 288, 380, 393, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        105, 105, 105, 105, 105, 105, 105, 108, 2684354812, 288, 288, 288, 0, 261, 288, 288, 288, 288, 393, 107, 105, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        105, 105, 105, 105, 105, 105, 105, 105, 108, 301, 301, 301, 302, 261, 223, 263, 300, 301, 107, 105, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        105, 105, 105, 105, 105, 105, 105, 105, 105, 89, 89, 89, 89, 89, 89, 89, 89, 89, 105, 105, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1073741913, 1073741913, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 124, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 123, 1073741913, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 123, 1073741913, 105, 105, 105, 105, 124, 125, 105, 105, 105, 105, 105, 105, 105, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 123, 1073741913, 1073741913, 126, 0, 0, 123, 1073741913, 1073741913, 1073741913, 1073741913, 1073741913, 1073741913, 126, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 35,
      height = 20,
      id = 9,
      name = "decoration",
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
        0, 0, 288, 380, 0, 380, 0, 242, 0, 0, 247, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 288, 380, 0, 380, 0, 255, 218, 219, 260, 0, 214, 215, 0, 0, 214, 215, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 288, 380, 0, 380, 0, 264, 265, 266, 2147483912, 0, 227, 228, 0, 0, 227, 228, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 288, 380, 0, 380, 0, 277, 278, 279, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        249, 249, 249, 249, 249, 249, 249, 249, 249, 249, 249, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 288, 380, 0, 380, 0, 303, 210, 210, 210, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 238, 380, 0, 380, 0, 316, 317, 318, 214, 0, 0, 0, 223, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        249, 249, 249, 249, 249, 249, 249, 249, 249, 249, 249, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        288, 288, 288, 380, 380, 380, 0, 379, 379, 288, 288, 288, 379, 0, 0, 0, 0, 0, 0, 0, 205, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        288, 238, 288, 380, 380, 381, 0, 379, 379, 288, 288, 288, 379, 379, 0, 0, 0, 0, 0, 0, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        288, 288, 288, 380, 381, 394, 405, 392, 379, 288, 288, 288, 379, 379, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        288, 288, 288, 393, 394, 137, 136, 391, 392, 288, 288, 288, 379, 379, 0, 0, 0, 0, 0, 394, 139, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        301, 301, 301, 406, 143, 144, 0, 138, 405, 0, 0, 0, 301, 301, 301, 301, 301, 0, 394, 140, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        129, 143, 137, 143, 147, 141, 114, 138, 146, 144, 138, 137, 0, 136, 136, 136, 0, 0, 0, 138, 137, 0, 0, 143, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 141, 143, 131, 143, 144, 137, 143, 143, 138, 142, 144, 0, 0, 0, 129, 140, 144, 142, 0, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        140, 142, 130, 143, 137, 142, 144, 148, 138, 143, 143, 137, 142, 113, 142, 1073741964, 0, 137, 137, 143, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 144, 114, 137, 143, 136, 141, 144, 137, 143, 143, 0, 144, 0, 142, 136, 143, 147, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        109, 110, 0, 0, 0, 142, 142, 144, 130, 137, 0, 0, 131, 137, 142, 140, 115, 142, 144, 144, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        125, 126, 0, 0, 0, 0, 0, 137, 0, 0, 107, 108, 0, 136, 113, 2147483785, 0, 140, 137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 109, 89, 89, 110, 0, 0, 0, 0, 104, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 35,
      height = 20,
      id = 10,
      name = "top",
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
        0, 0, 0, 0, 0, 0, 0, 0, 255, 260, 0, 0, 0, 0, 0, 0, 0, 0, 380, 368, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 238, 0, 0, 0, 380, 368, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 238, 0, 0, 0, 0, 0, 0, 380, 368, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 380, 368, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 250, 0, 0, 0, 288, 288, 0, 0, 380, 368, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        210, 210, 210, 210, 210, 210, 210, 210, 210, 210, 263, 0, 0, 0, 288, 238, 380, 380, 380, 368, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 263, 288, 0, 0, 288, 288, 380, 380, 380, 368, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 249, 288, 0, 0, 288, 288, 380, 380, 380, 368, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        380, 380, 380, 380, 380, 380, 380, 380, 380, 380, 368, 0, 0, 0, 238, 288, 380, 380, 0, 368, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        380, 380, 380, 0, 0, 393, 392, 0, 0, 380, 368, 238, 0, 0, 0, 0, 380, 380, 0, 368, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 393, 394, 391, 392, 0, 0, 288, 0, 0, 0, 0, 0, 380, 380, 0, 368, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 238, 0, 0, 0, 158, 159, 160, 380, 380, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 174, 175, 176, 0, 0, 0, 0, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 191, 0, 0, 0, 0, 0, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 92, 0, 0, 0, 0, 0, 173, 205, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 92, 0, 0, 92, 0, 0, 0, 0, 0, 0, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 14,
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
          id = 136,
          name = "npc",
          type = "",
          shape = "point",
          x = 240,
          y = 450,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "sneyek",
            ["text1"] = "* Wow, this place is nice.\nSo nice and shady.",
            ["text2"] = "* I might just stay in the shade down here"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "objects_mg",
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
          id = 116,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 520,
          width = 40,
          height = 40,
          rotation = 0,
          gid = 56,
          visible = true,
          properties = {}
        },
        {
          id = 118,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -40,
          y = 520,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "main_outdoors/tower_outside",
            ["marker"] = "entry2"
          }
        },
        {
          id = 133,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -40,
          y = 200,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "main_outdoors/tower_outside_right",
            ["marker"] = "entry3"
          }
        },
        {
          id = 137,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 520,
          width = 240,
          height = 200,
          rotation = 0,
          gid = 56,
          visible = true,
          properties = {}
        },
        {
          id = 138,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 400,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 56,
          visible = true,
          properties = {}
        },
        {
          id = 139,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 400,
          width = 120,
          height = 80,
          rotation = 0,
          gid = 56,
          visible = true,
          properties = {}
        },
        {
          id = 151,
          name = "magicglass",
          type = "",
          shape = "rectangle",
          x = 840,
          y = 440,
          width = 560,
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
      id = 11,
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
          id = 79,
          name = "",
          type = "",
          shape = "polygon",
          x = 800,
          y = 440,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -80, y = 80 },
            { x = -80, y = 0 }
          },
          properties = {}
        },
        {
          id = 81,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 480,
          width = 360,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 83,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 480,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 89,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 160,
          width = 400,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 90,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 280,
          width = 400,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 95,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 640,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 96,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 680,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 97,
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 720,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 98,
          name = "",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 760,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 100,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 760,
          width = 240,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 102,
          name = "",
          type = "",
          shape = "rectangle",
          x = 840,
          y = 480,
          width = 560,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 141,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 400,
          width = 600,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 104,
          name = "",
          type = "",
          shape = "polygon",
          x = 760,
          y = 760,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 40, y = -40 },
            { x = 40, y = 0 }
          },
          properties = {}
        },
        {
          id = 105,
          name = "",
          type = "",
          shape = "polygon",
          x = 360,
          y = 760,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 80, y = -80 },
            { x = 80, y = 0 }
          },
          properties = {}
        },
        {
          id = 106,
          name = "",
          type = "",
          shape = "polygon",
          x = 520,
          y = 760,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -80, y = -80 },
            { x = -80, y = 0 }
          },
          properties = {}
        },
        {
          id = 108,
          name = "",
          type = "",
          shape = "polygon",
          x = 200,
          y = 720,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -40, y = -40 },
            { x = -40, y = 0 }
          },
          properties = {}
        },
        {
          id = 109,
          name = "",
          type = "",
          shape = "polygon",
          x = 120,
          y = 680,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -40, y = -40 },
            { x = -40, y = 0 }
          },
          properties = {}
        },
        {
          id = 110,
          name = "",
          type = "",
          shape = "polygon",
          x = 280,
          y = 760,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -40, y = -40 },
            { x = -40, y = 0 }
          },
          properties = {}
        },
        {
          id = 127,
          name = "",
          type = "",
          shape = "polygon",
          x = 240,
          y = 400,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 120, y = 120 },
            { x = 120, y = 0 }
          },
          properties = {}
        },
        {
          id = 128,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 560,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 129,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 520,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 131,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 160,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 134,
          name = "",
          type = "",
          shape = "polygon",
          x = 120,
          y = 520,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = -120 },
            { x = 120, y = -120 }
          },
          properties = {}
        },
        {
          id = 152,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1400,
          y = 440,
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
      id = 15,
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
          id = 144,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 520,
          width = 40,
          height = 40,
          rotation = 0,
          gid = 56,
          visible = true,
          properties = {}
        },
        {
          id = 145,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -40,
          y = 520,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "main_outdoors/tower_outside_right",
            ["marker"] = "entry2"
          }
        },
        {
          id = 146,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -40,
          y = 200,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "main_outdoors/tower_outside_right",
            ["marker"] = "entry3"
          }
        },
        {
          id = 147,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 520,
          width = 240,
          height = 200,
          rotation = 0,
          gid = 56,
          visible = true,
          properties = {}
        },
        {
          id = 148,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 400,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 56,
          visible = true,
          properties = {}
        },
        {
          id = 149,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 400,
          width = 120,
          height = 80,
          rotation = 0,
          gid = 56,
          visible = true,
          properties = {}
        },
        {
          id = 154,
          name = "script",
          type = "",
          shape = "rectangle",
          x = 1397.5,
          y = 440,
          width = 40.5625,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "tower_outside.glassbridge",
            ["once"] = false,
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
          id = 64,
          name = "entry",
          type = "",
          shape = "point",
          x = 40,
          y = 600,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 132,
          name = "entry2",
          type = "",
          shape = "point",
          x = 40,
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
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 35,
      height = 20,
      id = 13,
      name = "light",
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483674, 2147483658
      }
    }
  }
}
