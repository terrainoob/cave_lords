class WorldMap
  def initialize(width:, height:, tile_size:, seed:)
    @width = width
    @height = height
    @tile_size = tile_size
    @seed = seed
  end

  def map
    @map ||= generate_map
  end

  private

  def generate_map
    map = []
    generate_height_map
    generate_temperature_map
    (0...@width).each do |x|
      map[x] = []
      (0...@height).each do |y|
        tile = Tile.new(x: x, y: y, size: @tile_size)
        tile.height_value = @height_map[x][y]
        tile.temperature_value = @temperature_map[x][y]
        map[x][y] = tile
      end
    end
    map
  end

  def generate_height_map
    noise = Noise::PerlinNoise.new(
      width: @width,
      height: @height,
      octaves: 3,
      persistence: 0.5,
      lacunarity: 2,
      seed: @seed
    )
    @height_map = []

    x = 0
    while x < @width
      @height_map[x] = []
      y = 0
      while y < @height
        @height_map[x][y] = noise.noise2d_value(x, y)
        y += 1
      end
      x += 1
    end
    p "************************"
    p "minmx = #{@height_map.flatten.minmax}"
    p "distribution = #{@height_map.flatten.group_by{|e| e.round(1)}.sort.map{|k,v| [k, v.length]}}"
    p "************************"
    @height_map
  end

  def generate_temperature_map
    @temperature_map = Array.new(@height) { Array.new(@width) }
    equator_y = @height / 2
    max_temperature = 100
    # maybe we want to have C and F subclasses of Temperature class
    # to figure out temperature dropoff per latitude.
    # For now, we'll simplify.
    # F temperature range in the world is 100 - 0
    temperature_dropoff_value = max_temperature / (@height - equator_y)
    y = 0
    # byebug
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
end