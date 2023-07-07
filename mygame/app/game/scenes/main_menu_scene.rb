class MainMenuScene < Scene
  extend Utilities::GameData

  class << self
    def tick
      create_buttons if args.tick_count.zero?
      args.state.main_menu_buttons.each do |button|
        args.outputs.primitives << button.primitives
        try_main_menu_click(button)
      end
    end

    private

    def create_buttons
      args.state.main_menu_buttons = []

      ButtonDefs::MAIN_MENU_BUTTONS.each do |button_def|
        args.state.main_menu_buttons << GuiElements.button(
          button_def[:display_options],
          button_def[:callback_method],
          args
        )
      end
    end

    def try_main_menu_click(button)
      return unless args.inputs.mouse.click

      send(button.m) if args.inputs.mouse.intersect_rect? button.rect
    end

    def new_game_click
      args.state.next_scene = :world_map_scene
    end

    def resume_game_click
      # TODO: we should return to where we came from, not necessarily play_map
      args.state.next_scene = :play_map_scene
    end

    def save_game_click
      return unless World.instance.tiles

      $gtk.write_file('world.sav', World.instance.to_json)
    end

    def load_game_click
      json = $gtk.parse_json_file('world.sav')
      World.instance.load_from_json(json)
      args.state.next_scene = :world_map_scene
    end
  end
end
