class GenericMap
  attr_accessor :sprites, :width, :height

  def initialize(width:, height:, tile_size:, seed:)
    @width = width
    @height = height
    @tile_size = tile_size
    @seed = seed
    @sprites = []
  end

  def map
    @map ||= generate_map
  end

  def generate_map
    puts 'GenericMap.generate_map: override me!'
  end

  def get_tile_at(x, y)
    return nil if x.negative? || y.negative?
    return nil if x > @width || y > @height

    @map[x][y] if @map
  end

  def get_neighbors(tile)
    neighbors = []
    (-1..1).each do |x_offset|
      x_check = tile.x + x_offset
      (-1..1).each do |y_offset|
        y_check = tile.y + y_offset
        next if x_check == tile.x && y_check == tile.y
        neighbor = get_tile_at(x_check, y_check)
        neighbors << neighbor if neighbor
      end
    end
    neighbors
  end
end
