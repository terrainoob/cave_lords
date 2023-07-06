if $gtk
  require "/lib/giatros/frametimer.rb"
  require "/lib/giatros/array_median.rb"
  require "/lib/giatros/array_sum.rb"
  require "/lib/giatros/ducks.rb"
end
require "#{File.dirname(__FILE__)}/game/lib/utilities/input.rb"
require "#{File.dirname(__FILE__)}/game/lib/utilities/camera.rb"
require "#{File.dirname(__FILE__)}/game/lib/levis_lib.rb"
require "#{File.dirname(__FILE__)}/game/lib/sprite_sheet_manager.rb"
require "#{File.dirname(__FILE__)}/game/lib/heap.rb"
require "#{File.dirname(__FILE__)}/game/lib/a_star.rb"
require "#{File.dirname(__FILE__)}/game/gui/gui_elements/button.rb"
require "#{File.dirname(__FILE__)}/game/gui/button_defs.rb"
require "#{File.dirname(__FILE__)}/game/scenes/scene_base.rb"
require "#{File.dirname(__FILE__)}/game/scenes/main_menu_scene.rb"
require "#{File.dirname(__FILE__)}/game/scenes/world_map_scene.rb"
require "#{File.dirname(__FILE__)}/game/scenes/play_map_scene.rb"
require "#{File.dirname(__FILE__)}/game/models/noise/perlin_noise.rb"
require "#{File.dirname(__FILE__)}/game/models/world/river_generator.rb"
require "#{File.dirname(__FILE__)}/game/models/world/biome.rb"
require "#{File.dirname(__FILE__)}/game/models/world/tile.rb"
require "#{File.dirname(__FILE__)}/game/models/world/world_tile.rb"
require "#{File.dirname(__FILE__)}/game/models/world/play_map_tile.rb"
require "#{File.dirname(__FILE__)}/game/models/world/world.rb"
require "#{File.dirname(__FILE__)}/game/models/maps/generic_map.rb"
require "#{File.dirname(__FILE__)}/game/models/maps/world_map.rb"
require "#{File.dirname(__FILE__)}/game/models/maps/play_map.rb"
require "#{File.dirname(__FILE__)}/game/models/pawns/pawn_data.rb"
require "#{File.dirname(__FILE__)}/game/models/pawns/pawn.rb"
