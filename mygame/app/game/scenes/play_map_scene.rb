class PlayMapScene < MapScene
  class << self
    def initialize
      @selected_world_tile = nil
    end

    def tick
      args.state.current_scene ||= :world_map if args.state.clicked_tile.nil?
      @selected_world_tile = args.state.clicked_tile
      generate_play_map unless @play_map
      draw
    end

    private

    def draw
      draw_gui
      handle_camera
      set_render_targets
      draw_render_targets(%i[play_map pawn_map])
    end

    def generate_play_map
      return if @selected_world_tile.nil?

      @play_map = PlayMap.new(
        width: Config::PLAYMAP_WIDTH,
        height: Config::PLAYMAP_HEIGHT,
        tile_size: Config::PLAYMAP_TILE_SIZE,
        seed: 123456789
      )
      @play_map.map
      spawn_a_pawn
    end

    def draw_gui
      args.outputs.labels << { x: 990, y: 200, text: "Biome: #{@selected_world_tile.biome}" }
    end

    def set_render_targets
      set_render_target(:play_map, @play_map.sprites) if @play_map
      set_render_target(:pawn_map, args.state.pawns.map(&:sprite)) if args.state.pawns
    end

    def spawn_a_pawn
      args.state.pawns ||= []
      args.state.pawns << Pawn.new(x_pos: 50, y_pos: 50)
    end
  end
end
