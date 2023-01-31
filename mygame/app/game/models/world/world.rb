class World
  attr_reader :tiles, :world_width, :world_height, :tile_size

  def self.instance
    @instance ||= World.new
  end

  def initialize
    @seed = 345672345
    @world_width = 640
    @world_height = 360
    @tile_size = 2
    @tiles = Array.new(@world_width) { Array.new(@world_height) }
  end

  def generate_world_map
    world_map = WorldMap.new(
      width: @world_width,
      height: @world_height,
      tile_size: @tile_size,
      seed: @seed
    )
  end
end