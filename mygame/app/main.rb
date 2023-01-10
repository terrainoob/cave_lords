# this is where things start when ./dragonruby is executed
require 'app/models/matrix.rb'
require 'app/models/noise/perlin/curve.rb'
require 'app/models/noise/perlin/gradient_table.rb'
require 'app/models/noise/perlin/noise.rb'
require 'app/models/maps/world_map.rb'

def tick(args)
  args.state.map ||= WorldMap.new(args)
end
