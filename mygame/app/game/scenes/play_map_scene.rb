class PlayMapScene < MapScene
  class << self
    def target_defs
      [
        { name: :play_map, value: @play_map.sprites, condition: @play_map },
        { name: :pawn_map, value: args.state.pawns.map(&:sprite), condition: args.state.pawns }
      ]
    end

    def initialize
      @selected_world_tile = nil
    end

    def tick
      set_defaults if args.state.defaults_needed
      args.state.current_scene ||= :world_map if args.state.clicked_tile.nil?
      @selected_world_tile = args.state.clicked_tile
      generate_play_map unless @play_map
      draw
    end

    private

    def set_defaults
      Utilities::Camera.reset_scale(16)
      @map_sprite_width = 2560
      @map_sprite_height = 1440
      args.state.defaults_needed = false
    end

    def draw
      draw_gui
      handle_camera
      create_render_targets
      draw_render_targets(%i[play_map pawn_map])
    end

    def generate_play_map
      return if @selected_world_tile.nil?

      @play_map = PlayMap.new(
        width: Config::PLAYMAP_WIDTH,
        height: Config::PLAYMAP_HEIGHT,
        tile_size: Config::PLAYMAP_TILE_SIZE,
        seed: 123456789,
        selected_world_tile: @selected_world_tile
      )
      tile_ids = @play_map.map
      draw_map(tile_ids)
      # spawn_a_pawn
    end

    def draw_map(tile_ids)
      playmap = []
      x = 0
      while x < tile_ids.length
        y = 0
        playmap[x] = []
        while y < tile_ids[0].length
          playmap[x][y] = Tile.new(index: tile_ids[x][y], x: x, y: y, size: 16)
          y += 1
        end
        x += 1
      end
      args.state.playmap = playmap
      args.outputs.primitives << playmap.map(&:sprite)
    end

    def draw_gui
      args.outputs.labels << { x: 990, y: 200, text: "Biome: #{@selected_world_tile.biome}" }
    end

    def spawn_a_pawn
      args.state.pawns ||= []
      args.state.pawns << Pawn.new(x_pos: 50, y_pos: 50)
    end
  end
end