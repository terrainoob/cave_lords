module Scene
  class << self
    def main_menu_tick(args)
      create_buttons(args) if args.tick_count.zero?
      args.outputs.primitives << args.state.resume_game_button.primitives
      args.outputs.primitives << args.state.new_game_button.primitives
      args.outputs.primitives << args.state.save_button.primitives
      args.outputs.primitives << args.state.load_button.primitives

      try_main_menu_click(args.state.new_game_button, args)
      try_main_menu_click(args.state.resume_game_button, args)
      try_main_menu_click(args.state.save_button, args)
      try_main_menu_click(args.state.load_button, args)
    end

    private

    def create_buttons(args)
      args.state.resume_game_button = GuiElements.button(
        { display_col: 4, display_row: 1, display_text: 'Resume Game' },
        :resume_game_click,
        args
      )
      args.state.new_game_button = GuiElements.button(
        { display_col: 4, display_row: 2, display_text: 'New Game' },
        :new_game_click,
        args
      )
      args.state.save_button = GuiElements.button(
        { display_col: 4, display_row: 4, display_text: 'Save' },
        :save_game_click,
        args
      )
      args.state.load_button = GuiElements.button(
        { display_col: 4, display_row: 6, display_text: 'Load' },
        :load_game_click,
        args
      )
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

      $gtk.write_file("world.sav", World.instance.tiles.to_json)
    end

    def load_game_click(args)
      puts 'I LOADED!'
    end
  end
end