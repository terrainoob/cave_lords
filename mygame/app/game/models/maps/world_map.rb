class WorldMap

  def initialize(width, height, tile_size, seed)
    @width = width
    @height = height
    @tile_size = tile_size
    @seed = seed
  end

  def generate_map
    generate_height_map
    @temp_map_vis
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
    @temp_map_vis = []
    @height_map = Array.new(@width) { Array.new(@height) }

    (0..@width - 1).each do |x|
      x_offset = x * @tile_size
      (0..@height - 1).each do |y|
        y_offset = y * @tile_size
        value = noise.noise2d_value(x, y)

        @height_map[x][y] = value
        if value <= 0.7
          primitive = { x: x_offset, y: y_offset, w: @tile_size, h: @tile_size, r: 0, g: 0, b: 255, a: 255 }.solid!
        elsif value > 1.5
          primitive = { x: x_offset, y: y_offset, w: @tile_size, h: @tile_size, r: 255, g: 255, b: 255, a: 255 }.solid!
        else
          primitive = { x: x_offset, y: y_offset, w: @tile_size, h: @tile_size, r: 100 * value, g: 100 * value, b: 100 * value, a: 255 }.solid!
        end

        @temp_map_vis << primitive
      end
    end
    p "cell count = #{@height_map.count * @height_map[0].count}"
    p "minmx = #{@height_map.flatten.minmax}"
    p "distribution = #{@height_map.flatten.group_by{|e| e.round(1)}.sort.map{|k,v| [k, v.length]}}"
  end
end