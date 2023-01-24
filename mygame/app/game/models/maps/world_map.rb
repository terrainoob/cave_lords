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
    (0...@width).each do |x|
      map[x] = []
      (0...@height).each do |y|
        tile = Tile.new(x: x, y: y, size: @tile_size)
        tile.height_value = height_map(x, y)
        map[x][y] = tile
      end
    end
    map
  end

  def height_map(x, y)
    @height_map[x][y]
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
end