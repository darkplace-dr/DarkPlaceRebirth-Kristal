return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 16,
  properties = {
    ["music"] = "the_wild_east_house"
  },
  tilesets = {},
  layers = {
    {
      type = "imagelayer",
      image = "../../../../../assets/sprites/world/maps/apartments/ceroba.png",
      id = 2,
      name = "bg",
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
          x = 360,
          y = 408,
          width = 280,
          height = 72,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 408,
          width = 280,
          height = 72,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 640,
          height = 168,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 168,
          width = 98,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 540,
          y = 168,
          width = 100,
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
          id = 6,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 460,
          width = 80,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["exit_sound"] = "doorclose",
            ["map"] = "floor2/apartments_right",
            ["marker"] = "ceroba",
            ["sound"] = "dooropen"
          }
        },
        {
          id = 9,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 106,
          y = 168,
          width = 96,
          height = 144,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "apartments/ceroba.bed",
            ["solid"] = true
          }
        },
        {
          id = 10,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 204,
          y = 168,
          width = 44,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "apartments/ceroba.nightstand",
            ["solid"] = true
          }
        },
        {
          id = 11,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 252,
          y = 168,
          width = 100,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "apartments/ceroba.table",
            ["solid"] = true
          }
        },
        {
          id = 12,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 354,
          y = 150,
          width = 78,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "apartments/ceroba.fridge",
            ["solid"] = true
          }
        },
        {
          id = 13,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 438,
          y = 150,
          width = 102,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "apartments/ceroba.dresser",
            ["solid"] = true
          }
        },
        {
          id = 14,
          name = "npc",
          type = "",
          shape = "point",
          x = 300,
          y = 230,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "ceroba_dw",
            ["cond"] = "Game:hasUnlockedPartyMember(\"ceroba\") and not Game:hasPartyMember(\"ceroba\")",
            ["cutscene"] = "apartments/ceroba.thoughts",
            ["facing"] = "up"
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
          id = 7,
          name = "entrance",
          type = "",
          shape = "point",
          x = 320,
          y = 440,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "spawn",
          type = "",
          shape = "point",
          x = 320,
          y = 300,
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
