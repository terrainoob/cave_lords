class GenericMap
  attr_accessor :sprites

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
end