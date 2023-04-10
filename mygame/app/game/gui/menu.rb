class Menu
  def self.setup(args)
    create_buttons(args)
  end

  def self.tick(args)
    args.state.debug_buttons.each do |button|
      args.outputs.primitives << button.primitives
      try_button_click(button, args)
    end
  end

  def self.try_button_click(button, args)
    return unless args.inputs.mouse.click

    args.state.selected_layer = button.opts[:map_layer] if args.inputs.mouse.intersect_rect? button.rect
  end

  private

  def self.create_buttons(args)
    args.state.debug_buttons = []

    ButtonDefs::DEBUG_BUTTONS.each do |button_def|
      args.state.debug_buttons << GuiElements.button(
        button_def[:display_options],
        { map_layer: button_def[:map_layer] },
        button_def[:callback_method],
        args
      )
    end
  end
end