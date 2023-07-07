class PlayMapScene < MapScene
  class << self
    def initialize
      @selected_world_tile = nil
    end

    def tick(args)
      args.state.current_scene ||= :world_map if args.state.clicked_tile.nil?
      @selected_world_tile = args.state.clicked_tile

      args.outputs.labels << { x: 990, y: 200, text: "Biome: #{@selected_world_tile.biome}" }
      generate_play_map(args) unless @play_map
      adjust_camera
      set_sprite_offsets
      set_render_target(:play_map, @play_map.sprites, args) if @play_map
      set_render_target(:pawn_map, args.state.pawns.map(&:sprite), args) if args.state.pawns
      paint_map(args)
      paint_pawns(args)
    end

    private

    def generate_play_map(args)
      return if @selected_world_tile.nil?

      @play_map = PlayMap.new(width: 100, height: 50, tile_size: 4, seed: 123456789)
      @play_map.map
      spawn_a_pawn(args)
    end

    def spawn_a_pawn(args)
      args.state.pawns ||= []
      args.state.pawns << Pawn.new(x_pos: 50, y_pos: 50)
    end

    def paint_pawns(args)
      args.outputs.sprites << paint_sprite(:pawn_map)
    end

    def paint_map(args)
      args.outputs.sprites << paint_sprite(:play_map)
    end
  end
end
