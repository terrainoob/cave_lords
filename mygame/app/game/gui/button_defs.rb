module ButtonDefs
  # Main Menu Buttons
  RESUME_GAME_BUTTON = {
    display_options: { display_col: 4, display_row: 1, display_text: 'Resume Game' },
    callback_method: :resume_game_click
  }.freeze
  NEW_GAME_BUTTON = {
    display_options: { display_col: 4, display_row: 2, display_text: 'New Game' },
    callback_method: :new_game_click
  }.freeze
  SAVE_BUTTON = {
    display_options: { display_col: 4, display_row: 4, display_text: 'Save' },
    callback_method: :save_game_click
  }.freeze
  LOAD_BUTTON = {
    display_options: { display_col: 4, display_row: 6, display_text: 'Load' },
    callback_method: :load_game_click
  }.freeze

  MAIN_MENU_BUTTONS = [
    RESUME_GAME_BUTTON,
    NEW_GAME_BUTTON,
    SAVE_BUTTON,
    LOAD_BUTTON
  ].freeze

  # Debug buttons
  HEIGHT_MAP_BUTTON = {
    display_options: { display_col: 1, display_row: 11, display_text: 'Height' },
    map_layer: :height_viz,
    callback_method: :set_debug_map_layer
  }.freeze
  MOISTURE_MAP_BUTTON = {
    display_options: { display_col: 3, display_row: 11, display_text: 'Moisture' },
    map_layer: :moisture_viz,
    callback_method: :set_debug_map_layer
  }.freeze
  TEMPERATURE_MAP_BUTTON = {
    display_options: { display_col: 5, display_row: 11, display_text: 'Temp' },
    map_layer: :temperature_viz,
    callback_method: :set_debug_map_layer
  }.freeze
  FULL_MAP_BUTTON = {
    display_options: { display_col: 7, display_row: 11, display_text: 'World Map' },
    map_layer: :world_map,
    callback_method: :set_debug_map_layer
  }.freeze

  DEBUG_BUTTONS = [
    HEIGHT_MAP_BUTTON,
    MOISTURE_MAP_BUTTON,
    TEMPERATURE_MAP_BUTTON,
    FULL_MAP_BUTTON
  ].freeze
end
