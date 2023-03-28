# this is where things start when ./dragonruby is executed

require 'app/requires.rb'

def tick(args)
  args.outputs.labels << {
    x: 30,
    y: 30.from_top,
    text: "#{$gtk.current_framerate.to_sf}" 
  }

  assign_default_state(args.state)
  case args.state.current_scene
  when :deploy
    PlayMapScene.instance.tick(args)
  else
    StartScene.instance.tick(args)
  end
end

def assign_default_state(state)
  state.current_scene ||= :world_map
  state.selected_layer ||= :world_map
  state.clicked_tile ||= nil
end

$gtk.reset