class Tile
  attr_accessor :x, :y

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

  def to_json(indent_depth: 0, indent_size: 2, minify: false)
    # TODO: implement this
  end
end