class PlayMap < GenericMap
  def generate_map
    map = []
    (0...@width).each do |x|
      map[x] = []
      (0...@height).each do |y|
        tile = Tile.new(x: x, y: y, size: @tile_size)
        map[x][y] = tile
        @sprites << tile.sprite
      end
    end
  end
end