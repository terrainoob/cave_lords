# this is where things start when ./dragonruby is executed

require 'app/game/models/noise/perlin_noise.rb'
require 'app/game/models/maps/world_map.rb'

def tick(args)
  setup(args) if args.tick_count.zero?
end

def setup(args)
  set_variables(args)
  generate_world_map(args)
end

def set_variables(args)
  args.state.world_map_width = 640
  args.state.world_map_height = 360
  args.state.tile_size = 2
  args.state.world_seed = 483290
end

def generate_world_map(args)
  world_map = WorldMap.new(
    args.state.world_map_width,
    args.state.world_map_height,
    args.state.tile_size,
    args.state.world_seed
  )
  # create the information for the world map grid
  args.state.world_tiles = world_map.generate_map
  # create a render target
  args.render_target(:world_map).static_primitives << args.state.world_tiles
  # create the world_map sprite once and store in args.state
  args.state.world_map_sprite = {
    x: 0,
    y: 0,
    w: args.state.world_map_width * args.state.tile_size,
    h: args.state.world_map_height * args.state.tile_size,
    path: :world_map
  }
  args.outputs.static_sprites << args.state.world_map_sprite
end