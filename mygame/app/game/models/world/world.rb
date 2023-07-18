class World
  attr_reader :tiles, :world_width, :world_height, :tile_size, :rivers

  def self.instance
    @instance ||= World.new
  end

  def to_json
    json_output = {}
    json_output[:seed] = @seed
    json_output[:tiles] = @tiles
    json_output.to_json(minify: true)
  end

  def load_from_json(json)
    @seed = json['seed']
    @tiles = []
    json['tiles'].each do |row|
      @tiles << row.map do |tile|
        new_tile = WorldTile.new(x: tile['x'], y: tile['y'], size: Config::WORLD_TILE_SIZE)
        new_tile.sprite_x = tile['sprite_x']
        new_tile.sprite_y = tile['sprite_y']
        new_tile.height_value = tile['height_value']
        new_tile.temperature_value = tile['temperature_value']
        new_tile.moisture_value = tile['moisture_value']
        new_tile.biome = tile['biome']
        new_tile
      end
    end
  end

  def get_tile_at(x, y)
    tile_x = (x / Config::WORLD_TILE_SIZE).floor
    tile_y = (y / Config::WORLD_TILE_SIZE).floor
    @tiles[tile_x][tile_y]
  end

  def world_map
    @world_map.sprites
  end

  def initialize
    @seed = 345672345
    @tiles = Array.new(Config::WORLD_WIDTH) { Array.new(Config::WORLD_HEIGHT) }
  end

  def generate_world_map
    @world_map = WorldMap.new(
      width: Config::WORLD_WIDTH,
      height: Config::WORLD_HEIGHT,
      tile_size: Config::WORLD_TILE_SIZE,
      seed: @seed
    )
    @tiles = @world_map.map
  end
end