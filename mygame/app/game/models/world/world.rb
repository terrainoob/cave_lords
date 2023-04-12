class World
  attr_reader :tiles, :world_width, :world_height, :tile_size, :tiles

  def self.instance
    @instance ||= World.new
  end

  def to_json
    json_output = {}
    json_output[:seed] = @seed
    json_output[:tile_size] = @tile_size
    json_output[:world_width] = @world_width
    json_output[:world_height] = @world_height
    json_output[:tiles] = @tiles
    json_output.to_json(minify: true)
  end

  def load_from_json(json)
    @seed = json['seed']
    @tile_size = json['tile_size']
    @world_width = json['world_width']
    @world_height = json['world_height']
    @tiles = []
    json['tiles'].each do |row|
      @tiles << row.map do |tile|
        new_tile = WorldTile.new(x: tile['x'], y: tile['y'], size: @tile_size)
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
    tile_x = (x / @tile_size).floor
    tile_y = (y / @tile_size).floor
    @tiles[tile_x][tile_y]
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
    # @world_width = 320
    # @world_height = 180
    # @tile_size = 4
    @world_width = 128
    @world_height = 72
    @tile_size = 10
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