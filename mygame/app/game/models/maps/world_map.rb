class WorldMap
  attr_accessor :height_viz, :temperature_viz, :moisture_viz, :sprites

  def initialize(width:, height:, tile_size:, seed:)
    @width = width
    @height = height
    @tile_size = tile_size
    @seed = seed
    @sprites = []

    @moisture_viz = []
    @temperature_viz = []
    @height_viz = []
  end

  def map
    @map ||= generate_map
  end

  private

  def generate_map
    map = []
    generate_height_map
    generate_temperature_map
    generate_moisture_map
    (0...@width).each do |x|
      map[x] = []
      (0...@height).each do |y|
        tile = Tile.new(x: x, y: y, size: @tile_size)
        tile.height_value = @height_map[x][y]
        tile.temperature_value = @temperature_map[x][y]
        tile.moisture_value = @moisture_map[x][y]
        map[x][y] = tile
        @moisture_viz << tile.moisture_viz
        @height_viz << tile.height_viz
        @temperature_viz << tile.temperature_viz
      end
    end
    map
  end

  def generate_height_map
    @height_map = create_perlin_map({ octaves: 3 })
  end

  def generate_temperature_map
    @temperature_map = Array.new(@width) { Array.new(@height) }
    equator_y = @height / 2
    max_temperature = 100
    # maybe we want to have C and F subclasses of Temperature class
    # to figure out temperature dropoff per latitude.
    # For now, we'll simplify.
    # F temperature range in the world is 100 - 0
    temperature_dropoff_value = max_temperature / (@height - equator_y)
    y = 0
    while y < @height
      x = 0
      y_temperature = max_temperature - ((equator_y - y).abs * temperature_dropoff_value)
      while x < @width
        @temperature_map[x][y] = y_temperature
        x += 1
      end
      y += 1
    end
  end

  def generate_moisture_map
    @moisture_map = create_perlin_map({ octaves: 1 })
  end

  def create_perlin_map(args)
    options = { octaves: 3, persistence: 0.5, lacunarity: 2 }
    options.merge!(args)
    noise = Noise::PerlinNoise.new(
      width: @width,
      height: @height,
      octaves: options[:octaves],
      persistence: options[:persistence],
      lacunarity: options[:lacunarity],
      seed: @seed
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
    end
    # p "************************"
    # p "minmx = #{map.flatten.minmax}"
    # p "distribution = #{map.flatten.group_by{|e| e.round(1)}.sort.map{|k,v| [k, v.length]}}"
    # p "************************"
    map
  end
end