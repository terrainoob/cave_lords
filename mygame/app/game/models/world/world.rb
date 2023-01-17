class World
  attr_reader :tiles, :world_width, :world_height, :tile_size

  def initialize()
    @seed = 345672345
    @world_width = 640
    @world_height = 360
    @tile_size = 2
    @tiles = Array.new(@world_width) { Array.new(@world_height) }
  end

  def generate_world_map
    world_map = WorldMap.new(
      width: @world_width,
      height: @world_height,
      tile_size: @tile_size,
      seed: @seed
    )
    world_map.generate_map
    (0...@world_width).each do |x|
      (0...@world_height).each do |y|
        tile = Tile.new(x: x, y: y, size: @tile_size)
        tile.height_value = world_map.height_map(x, y)
        @tiles[x][y] = tile
        $gtk.args.render_target(:world_map).static_primitives << tile.sprite
      end
    end
  end
end