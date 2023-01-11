class WorldMap
  def initialize(args)
    @args = args
    generate_height_map
  end

  def generate_height_map
    noise = Perlin::Noise.new(2)
    100.times do |x|
      100.times do |y|
        noise_x = x * 0.01
        noise_y = y * 0.01
        @args.outputs.static_solids << [x, y, 1, 1, 0, 255, 0, 255] if noise[noise_x, noise_y] < 0.5
        @args.outputs.static_solids << [x, y, 1, 1, 255, 0, 0, 255] if noise[noise_x, noise_y] >= 0.5
        log("#{x},#{y} = #{noise[noise_x, noise_y]}")
      end
    end
  end
end