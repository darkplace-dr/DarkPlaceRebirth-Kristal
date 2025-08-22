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
  nextlayerid = 7,
  nextobjectid = 19,
  properties = {
    ["music"] = "deltarune/man_2"
  },
  tilesets = {
    {
      name = "arleeroom",
      firstgid = 1,
      filename = "../../../../tilesets/arleeroom.tsx",
      exportfilename = "../../../../tilesets/arleeroom.lua"
    }
  },
  layers = {
    {
      type = "imagelayer",
      image = "../../../../../../assets/sprites/world/maps/arleeroom/arlee_room.png",
      id = 2,
      name = "room",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      repeatx = false,
      repeaty = false,
      properties = {}
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
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 138,
          width = 400,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 138,
          width = 40,
          height = 268,
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
          y = 406,
          width = 204,
          height = 74,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 138,
          width = 40,
          height = 268,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 354,
          y = 406,
          width = 206,
          height = 74,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 178,
          width = 92,
          height = 102,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 378,
          width = 92,
          height = 28,
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
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 280,
          width = 92,
          height = 142,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 406,
          width = 92,
          height = 54,
          rotation = 0,
          gid = 2,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 138,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* You try to see over the darkness...[wait:5]\n* You see nothing."
          }
        },
        {
          id = 11,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 372,
          width = 92,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "arlee.computer"
          }
        },
        {
          id = 12,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 178,
          width = 92,
          height = 102,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "* Normal bed,[wait:5] for normal people."
          }
        },
        {
          id = 17,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 282,
          y = 480,
          width = 74,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["exit_delay"] = 0.3,
            ["exit_sound"] = "doorclose",
            ["map"] = "floor2/apartments_left",
            ["marker"] = "entry_arlee",
            ["sound"] = "dooropen"
          }
        },
        {
          id = 18,
          name = "npc",
          type = "",
          shape = "point",
          x = 440,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "arlee",
            ["cutscene"] = "arlee.starbits",
            ["flagcheck"] = "arlee_quest"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
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
          id = 15,
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
