class MainMenuScene
  def self.instance
    @instance ||= MainMenuScene.new
  end

  def tick(args)
    create_buttons(args) if args.tick_count.zero?
    args.outputs.primitives << args.state.new_game_button.primitives
    args.outputs.primitives << args.state.save_button.primitives
    args.outputs.primitives << args.state.load_button.primitives

    try_main_menu_click(args.state.new_game_button, args)
    try_main_menu_click(args.state.save_button, args)
    try_main_menu_click(args.state.load_button, args)
  end

  private

  def create_buttons(args)
    args.state.new_game_button = Menu.button(2, 4, 'New Game', :new_game_click, args)
    args.state.save_button = Menu.button(4, 4, 'Save', :save_game_click, args)
    args.state.load_button = Menu.button(6, 4, 'Load', :load_game_click, args)
  end

  def try_main_menu_click(button, args)
    return unless args.inputs.mouse.click

    send(button.m, args) if args.inputs.mouse.intersect_rect? button.rect
  end

  def new_game_click(args)
    args.state.next_scene = :world_map
  end

  def save_game_click(args)
    puts 'I SAVED!'
  end

  def load_game_click(args)
    puts 'I LOADED!'
  end
end