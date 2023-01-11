# this is where things start when ./dragonruby is executed
require 'app/game/models/matrix.rb'
require 'app/game/models/noise/curve.rb'
require 'app/game/models/noise/gradient_table.rb'
require 'app/game/models/noise/perlin_noise.rb'
require 'app/game/models/maps/world_map.rb'

def tick(args)
  args.state.map ||= WorldMap.new(args)
end
