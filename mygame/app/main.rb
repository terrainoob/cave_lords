# this is where things start when ./dragonruby is executed

require 'app/requires.rb'
# require 'app/game/gui/menu.rb'
# require 'app/game/scenes/start_scene.rb'
# require 'app/game/scenes/play_map_scene.rb'
# require 'app/game/models/noise/perlin_noise.rb'
# require 'app/game/models/world/biome.rb'
# require 'app/game/models/world/tile.rb'
# require 'app/game/models/world/world_tile.rb'
# require 'app/game/models/world/play_map_tile.rb'
# require 'app/game/models/world/world.rb'
# require 'app/game/models/maps/generic_map.rb'
# require 'app/game/models/maps/world_map.rb'
# require 'app/game/models/maps/play_map.rb'

def tick(args)
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