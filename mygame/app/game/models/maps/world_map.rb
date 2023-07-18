class WorldMap < GenericMap

  def initialize(width:, height:, tile_size:, seed:)
    super(width: width, height: height, tile_size: tile_size, seed: seed)
  end

  private

  def generate_map
    @current_progress = 0
    @max_progress = @width * 3
    generate_height_map
    generate_temperature_map
    generate_moisture_map
    map = []

    x = 0
    while x < @width
      map[x] = []
      y = 0
      while y < @height
        tile = WorldTile.new(x: x, y: y, size: @tile_size)
        tile.height_value = @height_map[x][y]
        tile.temperature_value = @temperature_map[x][y]
        tile.moisture_value = @moisture_map[x][y]
        tile.determine_biome
        map[x][y] = tile
        # @sprites << tile.sprite
        y += 1
      end
      x += 1
      @current_progress += 1
      begin
        Fiber.yield({ current_progress: @current_progress, max_progress: @max_progress })
      rescue FiberError
      end
    end
    generate_rivers(map)
    generate_sprite_hash_array(map)
    map
  end

  def adjust_temperature_by_height(x, y, initial_temperature)
    temperature = initial_temperature
    height = @height_map[x][y]
    temperature -= (height - Biome::SEA_LEVEL) * 10 if height > Biome::SEA_LEVEL
    temperature
  end

  def generate_height_map
    @height_map = create_perlin_map({ octaves: 3 })
  end

  def generate_temperature_map
    @temperature_map = Array.new(@width) { Array.new(@height) }
    equator_y = @height / 2
    max_temperature = 50
    # maybe we want to have C and F subclasses of Temperature class
    # to figure out temperature dropoff per latitude.
    # For now, we'll simplify.
    # C temperature range in the world is 50 - 0
    temperature_dropoff_value = max_temperature / (@height - equator_y)
    y = 0
    while y < @height
      x = 0
      y_temperature = max_temperature - ((equator_y - y).abs * temperature_dropoff_value)
      while x < @width
        @temperature_map[x][y] = adjust_temperature_by_height(x, y, y_temperature)
        x += 1
      end
      y += 1
    end
  end

  def generate_moisture_map
    @moisture_map = create_perlin_map({ octaves: 1, seed: @seed + 10 })
  end

  def generate_rivers(map)
    river_generator = RiverGenerator.new
    start_tiles = map.flatten.select(&:river_start_tile)
    start_tiles.each do |start_tile|
      start_tile.has_river = true
      river_generator.generate(start_tile, map)
    end
  end

  def generate_sprite_hash_array(tile_map)
    @sprites = tile_map.flatten.map(&:sprite)
  end

  def create_perlin_map(opts)
    options = { octaves: 3, persistence: 0.5, lacunarity: 2, seed: @seed }
    options.merge!(opts)
    noise = Noise::PerlinNoise.new(
      width: @width,
      height: @height,
      opts: options
    )
    map = []

    x = 0
    while x < @width
      map[x] = []
      y = 0
      while y < @height
        map[x][y] = noise.noise2d_value(x, y)
        y += 1
      end
      x += 1
      @current_progress += 1
      begin
        Fiber.yield({ current_progress: @current_progress, max_progress: @max_progress })
      rescue FiberError => e
      end
    end
    map
  end
end