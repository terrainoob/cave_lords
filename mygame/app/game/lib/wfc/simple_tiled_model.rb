module Wfc
  class SimpleTiledModel
    MAX_ITERATIONS = 5_000

    attr_reader :output_width, :output_height, :process_grid, :result_grid

    # The tile_set should be an array of hashes. Each tile hash should be:
    #
    # { identifier: some_id, edge_types: [top, right, bottom, left], probability: some_float }
    # NOTE: the algorithm assumes the array of edge types is given in the order above
    #
    # identifier: this can be any unique identifier for the tile, e.g. a tile index
    # edge_type: an array of any kind of identifier that determines the types of edges this is
    #            this can be a color hash, an arbitrary number, or anything else that makes sense
    #            to you
    # probability: the weighted chance for tile to be picked from the available tiles when a
    #              cell is collapsed. Note that the total of the probabilities don't need to
    #              sum to 100.  The sum can be more or less. The algorithm handles that.
    #              These are treated more as relative weights than actual mathematical probabilities.

    def initialize(tile_set, output_width, output_height)
      @tile_set = tile_set
      @output_width = output_width
      @output_height = output_height

      # initialize uncollapsed_cells grid - this grid is to make finding lowest
      # entropy faster (I think) because we can constantly reduce the number of
      # cells we need to evaluate in that function
      # initialize processing grid - this is the final grid that will be returned
      @process_grid = Array.new(@output_width) { Array.new(@output_height) }
      x = 0
      while x < @output_width
        y = 0
        while y < @output_height
          cell = Wfc::Cell.new(x, y, @tile_set)
          @process_grid[x][y] = cell
          y += 1
        end
        x += 1
      end
      @uncollapsed_cells_grid = @process_grid.flatten
    end

    # this is the one-step solver.
    # Calling #solve_all has the same end result as calling #solve and then many #iterate
    def solve_all
      cell = randomize_first_cell
      process_starting_cell(cell)
      safety_net = 0
      while @uncollapsed_cells_grid.length.positive? && safety_net <= MAX_ITERATIONS
        next_cell = find_lowest_entropy
        process_starting_cell(next_cell) if next_cell
        @uncollapsed_cells_grid.compact!
        safety_net += 1
      end
      @result_grid = generate_result_grid
    end

    def solve
      cell = randomize_first_cell
      process_starting_cell(cell)
      @result_grid = generate_result_grid
    end

    def iterate
      @uncollapsed_cells_grid.compact!
      return false if @uncollapsed_cells_grid.empty?

      next_cell = find_lowest_entropy
      return false unless next_cell

      process_starting_cell(next_cell)
      @result_grid = generate_result_grid
    end

    def randomize_first_cell
      x = rand(@output_width)
      y = rand(@output_height)
      @process_grid[x][y]
    end

    def generate_result_grid
      # don't use map here. too slow!
      x = 0
      result = []
      lx = @process_grid.length
      while x < lx
        rx = result[x] = []
        y = 0
        pgx = @process_grid[x]
        ly = pgx.length
        while y < ly
          rx[y] = pgx[y].available_tiles[0][:identifier]
          y += 1
        end
        x += 1
      end
      result
    end

    def process_starting_cell(cell)
      cell.collapse
      @uncollapsed_cells_grid -= [cell]
      return if @uncollapsed_cells_grid.empty?

      propagate(cell)
    end

    def propagate(source_cell)
      evaluate_neighbor(source_cell, :up)
      evaluate_neighbor(source_cell, :right)
      evaluate_neighbor(source_cell, :down)
      evaluate_neighbor(source_cell, :left)
    end

    def evaluate_neighbor(source_cell, evaluation_direction)
      neighbor_cell = source_cell.neighbors(@process_grid)[evaluation_direction]
      return if neighbor_cell.nil? || neighbor_cell.collapsed # we can't evaluate further than "collapsed"

      original_tile_count = neighbor_cell.available_tiles.length
      source_edge_index = DIRECTION_TO_INDEX[evaluation_direction]
      check_edge_index = DIRECTION_TO_INDEX[OPPOSITE_OF[evaluation_direction]]
      source_cell.available_tiles.compact! # make sure there aren't any null in here (I actually got one in a test run)

      new_available_tiles = []
      source_available_tiles = source_cell.available_tiles
      neighbor_available_tiles = neighbor_cell.available_tiles
      source_available_tiles.each do |source_tile|
        source_edge_type = source_tile[:edge_types][source_edge_index]
        neighbor_available_tiles.each do |tile|
          new_available_tiles << tile if tile[:edge_types][check_edge_index] == source_edge_type
        end
      end
      neighbor_cell.available_tiles = new_available_tiles.uniq { |t| t[:identifier] } unless new_available_tiles.empty?
      neighbor_cell.update
      @uncollapsed_cells_grid -= [neighbor_cell] if neighbor_cell.collapsed

      # if the number of available_tiles changed, we need to evaluate THIS cell's neighbors now
      propagate(neighbor_cell) if neighbor_cell.available_tiles.length != original_tile_count
    end

    def find_lowest_entropy
      ucg = @uncollapsed_cells_grid
      i = 0
      l = ucg.length
      min_e = ucg[0].entropy
      acc = []
      while i < l
        cc = ucg[i]
        next i += 1 if !cc

        ce = cc.entropy
        if ce < min_e
          min_e = ce
          acc.clear
          acc << cc
        elsif ce == min_e
          acc << cc
        # else do nothing
        end

        i += 1
      end
      acc.sample
    end
  end
end

