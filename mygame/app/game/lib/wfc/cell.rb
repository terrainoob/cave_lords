module Wfc
  class Cell
    attr_accessor :available_tiles
    attr_reader :x, :y, :collapsed, :grid, :tile_probabilities, :entropy

    # x: the x coord of this cell in the cell array
    # y: the y coord of this cell in the cell array
    # available_tiles: an array of tile hashes:
    #                  { identifier: some_id, edge_types: [top, right, bottom, left], probability: some_float }
    def initialize(x, y, available_tiles)
      @available_tiles = available_tiles
      @entropy = @available_tiles.length
      @collapsed = false
      @x = x
      @y = y
    end

    def update
      @entropy = @available_tiles.length
      @collapsed = @entropy == 1
    end

    def collapse
      return if @available_tiles.nil?

      @available_tiles = [@available_tiles.max_by { |t| rand**(1.0 / t[:probability]) }]
      @collapsed = true
    end

    def neighbors(grid)
      return if grid.nil?

      @neighbors ||= begin
        up = grid[@x][@y + 1] if grid[@x] && @y < grid[0].length - 1
        down = grid[@x][@y - 1] if grid[@x] && @y.positive?
        right = grid[@x + 1][@y] if @x < grid.length - 1
        left = grid[@x - 1][@y] if @x.positive?
        { up: up, down: down, right: right, left: left }
      end
    end
  end
end