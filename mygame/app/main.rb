# this is where things start when ./dragonruby is executed

require 'app/game/models/noise/perlin_noise.rb'
require 'app/game/models/world/tile.rb'
require 'app/game/models/world/world.rb'
require 'app/game/models/maps/world_map.rb'

def tick(args)
  setup(args) if args.tick_count.zero?
end

def setup(args)
  load_world(args)
end

def load_world(args)
  world = World.new
  world.generate_world_map
  args.state.world_map_sprite = {
    x: 0,
    y: 0,
    w: world.world_width * world.tile_size,
    h: world.world_height * world.tile_size,
    path: :height_map
  }
  args.outputs.static_sprites << args.state.world_map_sprite
end