class AStar
  def find_path(start_tile, destination_tile, grid)
    @destination_tile = destination_tile
    @open = [{ tile: start_tile, f_score: 0, g_score: 0, h_score: 0 }]
    @closed = []

    @open.each do |tile|
      current_tile = find_lowest_f_cost

      @closed << current_tile

      # exit if current_tile == @destination_tile
      # add_open_tiles(grid, tile)
    end
  end

  def find_lowest_f_cost
    nil
    # @open.tile_with_lowest_cost
  end

  def add_open_tiles(grid, tile)
    neighbors = grid.get_neighbors(tile)
    neighbors.each do |neighbor|
      g_score = calc_g_cost(neighbor)
      h_score = calc_h_cost(neighbor)
      f_score = g_score + h_score
      @open << { tile: neighbor, f_score: f_score, g_score: g_score, h_score: h_score }
    end
  end
end