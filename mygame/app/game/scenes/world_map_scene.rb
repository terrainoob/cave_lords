module Scene
  # TODO: refactor this and PlayMapScene into a MapScene
  class << self
    def world_map_tick(args)
      args.state.map_displayed ||= {}
      args.state.world_map_generated ||= false
      setup(args) unless args.state.world_map_generated
      set_render_target(:world_map, World.instance.world_map, args) if args.state.world_map_generated
      args.outputs.sprites << args.state.world_map_sprite
      try_map_click(args)
      tile_info_window(args.inputs.mouse.x, args.inputs.mouse.y, args)
      ask_start_location(args)
      try_button_click(args.state.select_start_button, args)
      try_button_click(args.state.select_cancel_button, args)
    end

    private

    def setup(args)
      args.render_target(:world_map)
      load_world(args)
      args.state.world_map_sprite = {
        x: 0,
        y: 0,
        w: 1280,
        h: 720,
        path: :world_map
      }
    end

    def load_world(args)
      @world_fiber ||= Fiber.new do
        World.instance.generate_world_map
      end
      @world_fiber.resume
      args.state.world_map_generated = !@world_fiber&.alive?
    end

    def tile_info_window(x, y, args)
      return if x > 1280 || y > 720

      if args.state.clicked_tile.nil?
        tile = World.instance.get_tile_at(x, y)
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

    def ask_start_location(args)
      return if args.state.clicked_tile.nil?

      x = 1280 / 2
      y = 720 / 2
      args.outputs.primitives << { x: x, y: y, w: 300, h: 150, r: 50, g: 250, b: 100, a: 255, primitive_marker: :solid }
      args.labels << { x: x + 20, y: y + 20, text: "Start here?" }
      col = (x / 53).floor
      row = (y / 60).floor
      create_yes_no_buttons(col, row, args)
    end

    def create_yes_no_buttons(col, row, args)
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

    def start_button_click(args)
      args.state.next_scene = :play_map
    end

    def cancel_button_click(args)
      args.state.clicked_tile = nil
    end

    def try_button_click(button, args)
      return unless args.inputs.mouse.click

      return unless button&.rect

      send(button.m, args) if args.inputs.mouse.intersect_rect? button.rect
    end

    def try_map_click(args)
      return unless args.inputs.mouse.click && args.state.clicked_tile.nil?

      args.state.clicked_tile = World.instance.get_tile_at(args.inputs.mouse.x, args.inputs.mouse.y)
    end
  end
end
