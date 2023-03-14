class Tile
  attr_accessor :x, :y

  def initialize(x: 0, y: 0, size: 1)
    @x = x
    @y = y
    @sprite_x = 0
    @sprite_y = 0
    @size = size
  end

  def sprite
    puts 'override me'
  end
end