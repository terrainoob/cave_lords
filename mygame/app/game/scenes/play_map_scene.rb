module Scene
  class << self
    def initialize
      @selected_world_tile = nil
    end

    def play_map_tick(args)
      args.state.current_scene ||= :world_map if args.state.clicked_tile.nil?
      @selected_world_tile = args.state.clicked_tile

      args.outputs.labels << { x: 990, y: 200, text: "Biome: #{@selected_world_tile.biome}" }
      generate_play_map(args) unless @play_map
      assign_play_map_sprite(args)
      set_render_target(:play_map, @play_map.sprites, args) if @play_map
    end

    private

    def set_render_target(target_name, primitives, args)
      args.render_target(target_name).primitives << primitives
      args.render_target(target_name).w = 1280
      args.render_target(target_name).h = 720
    end

    def generate_play_map(args)
      return if @selected_world_tile.nil?

      @play_map = PlayMap.new(width: 100, height: 50, tile_size: 4, seed: 123456789)
      @play_map.map
      spawn_a_pawn(args)
    end

    def spawn_a_pawn(args)
      pawn = Pawn.new(x_pos: 50, y_pos: 50)
      puts '*********************************'
      puts pawn.sprite
      puts '*********************************'

      args.outputs.sprites << pawn.sprite

      # target_name = 'pawn_dude'
      # args.render_target(target_name).primitives << pawn.sprite
      # args.render_target(target_name).w = 16
      # args.render_target(target_name).h = 16
    end

    def assign_play_map_sprite(args)
      # args.state.camera.offset_x ||= 640
      # args.state.camera.offset_y ||= 360
      args.state.camera.offset_x ||= 0
      args.state.camera.offset_y ||= 0
      args.state.camera.scale ||= 4
      args.state.camera.offset_x += args.inputs.left_right * 10
      args.state.camera.offset_y += args.inputs.up_down * 10

      # zoom in/out
      if args.inputs.keyboard.key_down.i
        args.state.camera.scale += 0.1
      elsif args.inputs.keyboard.key_down.o
        args.state.camera.scale -= 0.1
      end

      sprite_width = 2560 * args.state.camera.scale
      sprite_height = 1440 * args.state.camera.scale
      # x_offset = (1280 - sprite_width) / 2
      # y_offset = (720 - sprite_height) / 2
      x_offset = 0
      y_offset = 0
      args.state.play_map_sprite = {
        x: x_offset + (args.state.camera.offset_x / 2),
        y: y_offset + (args.state.camera.offset_y / 2),
        # x: 0,
        # y: 0,
        w: sprite_width,
        h: sprite_height,
        path: :play_map
      }
      args.outputs.sprites << args.state.play_map_sprite
    end
  end
end