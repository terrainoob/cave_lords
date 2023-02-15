class Menu
  def self.setup(args)
    create_buttons(args)
  end

  def self.tick(args)
    args.outputs.primitives << args.state.height_button.primitives
    args.outputs.primitives << args.state.moisture_button.primitives
    args.outputs.primitives << args.state.temperature_button.primitives
    args.outputs.primitives << args.state.map_button.primitives

    try_button_click(args.state.height_button, args)
    try_button_click(args.state.moisture_button, args)
    try_button_click(args.state.temperature_button, args)
    try_button_click(args.state.map_button, args)
    end

  def self.try_button_click(button, args)
    return unless args.inputs.mouse.click

    args.state.selected_layer = button.map_layer if args.inputs.mouse.intersect_rect? button.rect
  end

  private

  def self.create_buttons(args)
    args.state.height_button = map_button(1, 'Height', :height_viz, args)
    args.state.moisture_button = map_button(3, 'Moisture', :moisture_viz, args)
    args.state.temperature_button = map_button(5, 'Temp', :temperature_viz, args)
    args.state.map_button = map_button(7, 'World Map', :world_map, args)
  end

  def self.map_button(col, text, map_layer, args)
    button = button(col, text, nil, args)
    button.merge({ map_layer: map_layer })
  end

  def self.button(col, text, m, args)
    rect = args.layout.rect(row: 11, col: col, w: 2, h: 1)
    {
      m: m,
      rect: rect,
      primitives: [
        { r: 150, g: 200, b: 200 }.merge(rect).solid!,
        {
          x: rect.x + (rect.w / 2),
          y: rect.y + (rect.h / 2),
          text: text,
          vertical_alignment_enum: 1,
          alignment_enum: 1
        }
      ]
    }
  end
end