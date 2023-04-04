# this is where things start when ./dragonruby is executed

require 'app/requires.rb'

def tick(args)
  args.outputs.labels << {
    x: 30,
    y: 30.from_top,
    text: "#{$gtk.current_framerate.to_sf}" 
  }

  assign_default_state(args.state)
  select_scene(args)
end

def assign_default_state(state)  
  state.current_scene ||= :main_menu
  state.next_scene ||= :main_menu
  state.selected_layer ||= :world_map
  state.clicked_tile ||= nil
end

def select_scene(args)
  args.state.current_scene = args.state.next_scene
  case args.state.current_scene
  when :deploy
    PlayMapScene.instance.tick(args)
  when :world_map
    WorldMapScene.instance.tick(args)
  when :main_menu
    MainMenuScene.instance.tick(args)
  else
    raise
  end
end

$gtk.reset