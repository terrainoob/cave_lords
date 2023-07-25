class WorldMapScene < MapScene
  class << self
    def target_defs
      [
        { name: :world_map, value: World.instance.world_map, condition: args.state.world_map_generated }
      ]
    end

    def tick
      set_defaults if args.state.defaults_needed
      handle_progress_bar
      setup unless args.state.world_map_generated
      draw
      handle_input
    end

    private

    def set_defaults
      Utilities::Camera.reset_scale(1)
      @map_sprite_width = 1280
      @map_sprite_height = 720
      args.state.map_displayed ||= {}
      args.state.world_map_generated ||= false
      args.state.defaults_needed = false
    end

    def handle_progress_bar
      create_progress_bar if args.state.progress_bar.nil?
      @progress ||= { current_progress: 0, max_progress: 1 }
      progress_tick unless args.state.world_map_generated
    end

    def progress_tick
      args.state.progress_bar[:primitives][0][:w] = 300.0 * (@progress[:current_progress] / @progress[:max_progress])
      args.outputs.primitives << args.state.progress_bar[:primitives]
    end

    def handle_input
      try_map_click
      ask_start_location
      try_button_click(args.state.select_start_button)
      try_button_click(args.state.select_cancel_button)
    end

    def draw
      handle_camera
      draw_rivers
      create_render_targets
      draw_render_targets(%i[world_map])
      tile_info_window(args.inputs.mouse.x, args.inputs.mouse.y)
    end

    # def create_render_targets
    #   set_render_target(:world_map, World.instance.world_map) if args.state.world_map_generated
    # end

    def draw_rivers
      args.outputs.lines << args.state.rivers
    end

    def setup
      args.render_target(:world_map) # have to call this here so we don't get the pink squares on map generation
      load_world
      args.state.rivers = World.instance.rivers
    end

    def load_world
      @world_fiber ||= Fiber.new do
        World.instance.generate_world_map
      end
      @progress = @world_fiber.resume
      args.state.world_map_generated = !@world_fiber&.alive?
    end

    def tile_info_window(x, y)
      return if x > 1280 || y > 720

      if args.state.clicked_tile.nil?
        tile = World.instance.tile_from_mouse_position(x, y, args.state.camera.scale)
      else
        tile = args.state.clicked_tile
      end
      return unless tile

      args.outputs.primitives << { x: 980, y: 0, w: 300, h: 270, r: 150, g: 150, b: 150, a: 200, primitive_marker: :solid }
      args.outputs.labels << { x: 990, y: 250, text: "Coordinates: #{tile.x}, #{tile.y}" }
      args.outputs.labels << { x: 990, y: 200, text: "Biome: #{tile.biome}" }
      args.outputs.labels << { x: 990, y: 100, text: "Temperature: #{tile.temperature_value.floor} C" }
      args.outputs.labels << { x: 990, y: 150, text: "Height Value: #{tile.height_value.round(2)}" }
      args.outputs.labels << { x: 990, y: 50, text: "Precipitation: #{(tile.moisture_value * 100).floor}%" }
    end

    def ask_start_location
      return if args.state.clicked_tile.nil?

      x = 1280 / 2
      y = 720 / 2
      args.outputs.primitives << { x: x, y: y, w: 300, h: 150, r: 50, g: 250, b: 100, a: 255, primitive_marker: :solid }
      args.labels << { x: x + 20, y: y + 20, text: "Start here?" }
      col = (x / 53).floor
      row = (y / 60).floor
      create_yes_no_buttons(col, row)
    end

    def create_yes_no_buttons(col, row)
      args.state.select_start_button = GuiElements.button(
        { display_col: col, display_row: row, display_text: 'Yes' },
        {},
        :start_button_click,
        args
      )
      args.state.select_cancel_button = GuiElements.button(
        { display_col: col + 2, display_row: row, display_text: 'No' },
        {},
        :cancel_button_click,
        args
      )
      args.outputs.primitives << args.state.select_start_button.primitives
      args.outputs.primitives << args.state.select_cancel_button.primitives
    end

    def start_button_click
      args.state.next_scene = :play_map_scene
    end

    def cancel_button_click
      args.state.clicked_tile = nil
    end

    def try_button_click(button)
      return unless args.inputs.mouse.click

      return unless button&.rect

      send(button.m) if args.inputs.mouse.intersect_rect? button.rect
    end

    def try_map_click
      return unless args.inputs.mouse.click && args.state.clicked_tile.nil?

      args.state.clicked_tile = World.instance.tile_from_mouse_position(args.inputs.mouse.x, args.inputs.mouse.y, args.state.camera.scale)
    end

    def create_progress_bar
      x = 640
      y = 360
      args.state.progress_bar = {
        text: 'Loading World',
        primitives: [
          { anchor_x: 0.5, anchor_y: 0.5, x: x, y: y, w: 300, h: 50, r: 50, g: 200, b: 100, primitive_marker: :solid }, # sets definition for solid (which fills the bar with gray)
          { anchor_x: 0.5, anchor_y: 0.5, x: x, y: y, text: 'Loading World', size_enum: 2, alignment_enum: 1, primitive_marker: :label }, # sets definition for label, positions inside border
          { anchor_x: 0.5, anchor_y: 0.5, x: x, y: y, w: 300, h: 50, primitive_marker: :border } # sets definition of border
        ]
      }
    end
  end
end
