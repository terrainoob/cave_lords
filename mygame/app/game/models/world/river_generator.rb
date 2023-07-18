class RiverGenerator
  COUNTER_MAX = 1000
  END_BIOMES = [:water, :ice, :desert].freeze

  def generate(start_tile, map_array)
    @start_tile = start_tile
    @map_array = map_array
    @counter = 1

    find_next_tile(@start_tile)
  end

  def find_next_tile(source_tile)
    return if @counter > COUNTER_MAX || source_tile.nil? || END_BIOMES.include?(source_tile.biome)

    neighbors = get_neighbots(source_tile)
    return if neighbors.empty? || !neighbors.all?

    tile = neighbors.min_by(&:height_value)

    # TODO: if the height_values are ==, make a lake here!
    return if tile.height_value >= source_tile.height_value || tile.has_river

    tile.has_river = true
    @counter += 1
    find_next_tile(tile)
  end

  def get_neighbots(tile)
    neighbors = []
    (-1..1).each do |x_offset|
      x_check = tile.x + x_offset
      (-1..1).each do |y_offset|
        y_check = tile.y + y_offset
        next if x_check == tile.x && y_check == tile.y

        neighbor = get_tile_at(x_check, y_check)
        neighbors << neighbor if neighbor
      end
    end
    neighbors
  end

  def get_tile_at(x, y)
    return nil unless @map_array && @map_array[x]

    return nil if x.negative? || y.negative?
    return nil if x > @map_array.length || y > @map_array[x].length

    @map_array[x][y] if @map_array && @map_array[x]
  end
end