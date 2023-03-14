class StartScene
  #TODO refactor this and PlayMapScene into a MapScene
  def self.instance
    @instance ||= StartScene.new
  end

  def tick(args)
    setup(args) if args.tick_count.zero?
    Menu.tick(args)
    assign_world_map_sprite(args)
    try_map_click(args)
    tile_info_window(args.inputs.mouse.x, args.inputs.mouse.y, args)
    ask_start_location(args)
    try_start_button_click(args)
    try_cancel_button_click(args)
  end

  private

  def setup(args)
    load_world(args)
    Menu.setup(args)
  end

  def load_world(args)
    world = World.instance
    world.generate_world_map
    set_render_target(:world_map, world.world_map, args)
    assign_viz_maps(args)
  end

  def assign_viz_maps(args)
    world = World.instance
    set_render_target(:height_viz, world.height_viz, args)
    set_render_target(:temperature_viz, world.temperature_viz, args)
    set_render_target(:moisture_viz, world.moisture_viz, args)
  end

  def set_render_target(target_name, primitives, args)
    args.render_target(target_name).static_primitives << primitives
    args.render_target(target_name).w = 1280
    args.render_target(target_name).h = 720
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
    args.state.select_start_button = Menu.button(row, col, "Yes", nil, args)
    args.state.select_cancel_button = Menu.button(row, col + 2, "Cancel", nil, args)
    args.outputs.primitives << args.state.select_start_button.primitives
    args.outputs.primitives << args.state.select_cancel_button.primitives
  end

  def try_cancel_button_click(args)
    return unless args.inputs.mouse.click

    args.state.clicked_tile = nil if args.inputs.mouse.intersect_rect? args.state.select_cancel_button.rect
  end

  def try_start_button_click(args)
    return unless args.inputs.mouse.click

    args.state.current_scene = :deploy if args.inputs.mouse.intersect_rect? args.state.select_start_button.rect
  end

  def try_map_click(args)
    return unless args.inputs.mouse.click && args.state.clicked_tile.nil?

    args.state.clicked_tile = World.instance.get_tile_at(args.inputs.mouse.x, args.inputs.mouse.y)
  end

  def assign_world_map_sprite(args)
    args.state.world_map_sprite = {
      x: 0,
      y: 0,
      w: 1280,
      h: 720,
      path: args.state.selected_layer
    }
    args.outputs.sprites << args.state.world_map_sprite
  end
end