class RiverGenerator
  def generate(start_tile, end_tile)
    @start_tile = start_tile
    @end_tile = end_tile
    river_sprite
  end

  def river_sprite
    {
      x: @start_tile.x.div(4),
      y: @start_tile.y.div(4),
      x2: @end_tile.x.div(4),
      y2: @end_tile.y.div(4),
      r: 0,
      g: 150,
      b: 200,
      a: 255
    }
  end
end