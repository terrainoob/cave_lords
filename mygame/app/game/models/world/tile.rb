class Tile
  attr_accessor :x, :y, :sprite_x, :sprite_y

  def initialize(x:, y:, size:)
    @x = x
    @y = y
    @sprite_x = 0
    @sprite_y = 0
    @size = size
  end

  def sprite
    puts 'Tile.sprite: override me'
  end

  def to_json
    {
      x: @x,
      y: @y,
      sprite_x: @sprite_x,
      sprite_y: @sprite_y
    }.to_json(indent_depth: 0, indent_size: 4, minify: true, space_in_empty: true)
  end
end
