return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  name = "city_objects",
  class = "",
  tilewidth = 110,
  tileheight = 84,
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
  tilecount = 3,
  tiles = {
    {
      id = 0,
      image = "../../../assets/sprites/world/maps/cyber/ddelta_dream/diamonds_symbol.png",
      width = 84,
      height = 84
    },
    {
      id = 3,
      image = "../../../assets/sprites/world/maps/cyber/sign_poster_ferris_wheel_smaller_1.png",
      width = 110,
      height = 75,
      animation = {
        {
          tileid = 3,
          duration = 250
        },
        {
          tileid = 4,
          duration = 250
        }
      }
    },
    {
      id = 4,
      image = "../../../assets/sprites/world/maps/cyber/sign_poster_ferris_wheel_smaller_2.png",
      width = 110,
      height = 75
    }
  }
}
