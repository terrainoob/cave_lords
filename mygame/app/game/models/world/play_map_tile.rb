class PlayMapTile < Tile
  def initialize(x:, y:, size:)
    super(x: x, y: y, size: size)
  end

  def sprite
    # TODO: temporary sprite_x and sprite_y assignment here
    # this should be generated based on the selected biome
    @sprite_x = 0
    @sprite_y = [0, 8, 24].sample
    {
      path: 'sprites/biomes.png',
      tile_w: @size,
      tile_h: @size,
      tile_x: @sprite_x,
      tile_y: @sprite_y,
      w: @size,
      h: @size,
      x: @x * @size,
      y: @y * @size,
      primitive_marker: :sprite
    }
  end
end