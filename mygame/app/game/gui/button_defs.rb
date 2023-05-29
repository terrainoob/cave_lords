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
end
