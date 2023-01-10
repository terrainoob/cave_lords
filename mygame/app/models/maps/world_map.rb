class WorldMap
  def initialize(args)
    @args = args
    generate_height_map
  end

  def generate_height_map
    noise = Perlin::Noise.new(2)
    100.times do |x|
      100.times do |y|
        # @args.outputs.static_solids << [x, y, 1, 1, 0, 255, 0, 255] if noise[x,y] < 0.5
        # @args.outputs.static_solids << [x, y, 1, 1, 255, 0, 0, 255] if noise[x,y] >= 0.5
        log("#{x},#{y} = #{noise[x, y]}")
      end
    end
  end
end