module Scene
  class << self
    def main_menu_tick(args)
      create_buttons(args) if args.tick_count.zero?
      args.state.main_menu_buttons.each do |button|
        args.outputs.primitives << button.primitives
        try_main_menu_click(button, args)
      end
    end

    private

    def create_buttons(args)
      args.state.main_menu_buttons = []

      ButtonDefs::MAIN_MENU_BUTTONS.each do |button_def|
        args.state.main_menu_buttons << GuiElements.button(
          button_def[:display_options],
          button_def[:callback_method],
          args
        )
      end
    end

    def try_main_menu_click(button, args)
      return unless args.inputs.mouse.click

      send(button.m, args) if args.inputs.mouse.intersect_rect? button.rect
    end

    def new_game_click(args)
      args.state.next_scene = :world_map
    end

    def resume_game_click(args)
      # TODO: we should return to where we came from, not necessarily play_map
      args.state.next_scene = :play_map
    end

    def save_game_click(args)
      return unless World.instance.tiles

      puts "I SAVED! (but not really! j/k!)"

      # $gtk.write_file("world.sav", World.instance.tiles.to_json)
    end

    def load_game_click(args)
      puts 'I LOADED!'
    end
  end
end