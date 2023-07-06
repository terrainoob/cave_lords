class PlayMapScene < Scene
  class << self
    def initialize
      @selected_world_tile = nil
    end

    def tick(args)
      args.state.current_scene ||= :world_map if args.state.clicked_tile.nil?
      @selected_world_tile = args.state.clicked_tile

      args.outputs.labels << { x: 990, y: 200, text: "Biome: #{@selected_world_tile.biome}" }
      generate_play_map(args) unless @play_map
      adjust_camera(args)
      set_sprite_offsets
      set_render_target(:play_map, @play_map.sprites, args) if @play_map
      set_render_target(:pawn_map, args.state.pawns.map(&:sprite), args) if args.state.pawns
      paint_map(args)
      paint_pawns(args)
    end

    private

    def set_sprite_offsets
      # x_offset = (1280 - sprite_width) / 2
      # y_offset = (720 - sprite_height) / 2
      @x_offset = 0
      @y_offset = 0
    end

    def adjust_camera(args)
      # zoom in/out
      if args.inputs.keyboard.key_down.i || args.inputs.mouse.wheel&.y.to_i.positive?
        args.state.camera.scale += 0.1
      elsif args.inputs.keyboard.key_down.o || args.inputs.mouse.wheel&.y.to_i.negative?
        args.state.camera.scale -= 0.1
      end

      # args.state.camera.offset_x ||= 640
      # args.state.camera.offset_y ||= 360
      args.state.camera.offset_x ||= 0
      args.state.camera.offset_y ||= 0
      args.state.camera.scale ||= 4
      args.state.camera.offset_x += args.inputs.left_right * 10
      args.state.camera.offset_y += args.inputs.up_down * 10

      @sprite_width = 2560 * args.state.camera.scale
      @sprite_height = 1440 * args.state.camera.scale
    end

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

    def paint_sprite(path_name, args)
      {
        x: @x_offset + (args.state.camera.offset_x / 2),
        y: @y_offset + (args.state.camera.offset_y / 2),
        w: @sprite_width,
        h: @sprite_height,
        path: path_name
      }.to_sprite
    end

    def paint_pawns(args)
      args.outputs.sprites << paint_sprite(:pawn_map, args)
    end

    def paint_map(args)
      args.outputs.sprites << paint_sprite(:play_map, args)
    end
  end
end
