# most of this originally developed by kfischer_okarin here:
# https://github.com/kfischer-okarin/dragon_skeleton/blob/main/lib/dragon_skeleton/pathfinding/a_star.rb

class AStar
  def find_path(start_tile, destination_tile, grid)
    # @destination_tile = destination_tile
    came_from = { start_tile => nil }
    @open = Heap.new
    @open.insert(start_tile, 0)
    cost_so_far = { start_tile => 0 }

    until @open.empty?
      current_tile = @open.pop
      break if current_tile == destination_tile

      grid.get_neighbors(current_tile).each do |neighbor|
        # g_cost
        neighbor_cost = calc_neighbor_cost(current_tile, neighbor)
        total_cost_to_neighbor = cost_so_far[current_tile] + neighbor_cost
        neighbor_already_found_cheaper = cost_so_far.include?(neighbor) && cost_so_far[neighbor] <= total_cost_to_neighbor
        next if neighbor_already_found_cheaper

        cost_so_far[neighbor] = total_cost_to_neighbor

        # h_cost
        h_cost = get_heuristic_cost(neighbor, destination_tile)
        total_cost = total_cost_to_neighbor + h_cost
        @open.insert(neighbor, total_cost)
        came_from[neighbor] = current_tile
      end
      current_tile = destination_tile
    end

    result = []
    until current_tile.nil?
      result.prepend(current_tile)
      current_tile = came_from[current_tile]
    end
    result
  end

  def get_heuristic_cost(neighbor, destination_tile)
    1
  end

  def calc_neighbor_cost(current_tile, neighbor)
    is_diagonal = (current_tile.x != neighbor.x) && (current_tile.y != neighbor.y)
    cost_multiplier = is_diagonal ? 1.4 : 1
    neighbor.size * cost_multiplier
  end
end
