class WorldMap
  def initialize(width:, height:, tile_size:, seed:)
    @width = width
    @height = height
    @tile_size = tile_size
    @seed = seed
  end

  def generate_map
    generate_height_map
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
    @height_map = Array.new(@width) { Array.new(@height) }

    (0..@width - 1).each do |x|
      (0..@height - 1).each do |y|
        value = noise.noise2d_value(x, y)
        @height_map[x][y] = value
      end
    end
    # p "cell count = #{@height_map.count * @height_map[0].count}"
    # p "minmx = #{@height_map.flatten.minmax}"
    # p "distribution = #{@height_map.flatten.group_by{|e| e.round(1)}.sort.map{|k,v| [k, v.length]}}"
  end
end