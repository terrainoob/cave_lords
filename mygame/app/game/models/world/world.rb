class World
  attr_reader :tiles, :world_width, :world_height, :tile_size, :tiles

  def self.instance
    @instance ||= World.new
  end

  def height_viz
    @world_map.height_viz
  end

  def temperature_viz
    @world_map.temperature_viz
  end

  def moisture_viz
    @world_map.moisture_viz
  end

  def world_map
    @world_map.sprites
  end

  def initialize
    @seed = 345672345
    @world_width = 320
    @world_height = 180
    @tile_size = 4
    @tiles = Array.new(@world_width) { Array.new(@world_height) }
  end

  def generate_world_map
    @world_map = WorldMap.new(
      width: @world_width,
      height: @world_height,
      tile_size: @tile_size,
      seed: @seed
    )
    @tiles = @world_map.map
  end
end