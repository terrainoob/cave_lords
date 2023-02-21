# this is where things start when ./dragonruby is executed

require 'app/game/controls/player_input.rb'
require 'app/game/gui/menu.rb'
require 'app/game/models/noise/perlin_noise.rb'
require 'app/game/models/world/biome.rb'
require 'app/game/models/world/tile.rb'
require 'app/game/models/world/world.rb'
require 'app/game/models/maps/world_map.rb'

def tick(args)
  args.state.selected_layer ||= :world_map
  setup(args) if args.tick_count.zero?
  Menu.tick(args)
  assign_world_map_sprite(args)

  if args.inputs.mouse.button_left
    x = args.inputs.mouse.x
    y = args.inputs.mouse.y
    tile_x = (x / World.instance.tile_size).floor
    tile_y = (y / World.instance.tile_size).floor
    tile = World.instance.tiles[tile_x][tile_y]
    tile_info_window(x, y, tile, args)
  end
end

def tile_info_window(x, y, tile, args)
  box =
    {
      x: x,
      y: y,
      w: 300,
      h: 250,
      r: 100,
      g: 100,
      b: 100,
      a: 200,
      primitive_marker: :solid
    }
  args.outputs.primitives << box
  args.outputs.labels << { x: x + 10, y: y + 50, text: "Biome: #{tile.biome}" }
  args.outputs.labels << { x: x + 10, y: y + 100, text: "Temperature: #{tile.temperature_value.floor} C" }
  args.outputs.labels << { x: x + 10, y: y + 150, text: "Height Value: #{tile.height_value.round(2)}" }
  args.outputs.labels << { x: x + 10, y: y + 200, text: "Precipitation: #{(tile.moisture_value * 100).floor}%" }
end

def assign_world_map_sprite(args)
  args.state.world_map_sprite = {
    x: 0,
    y: 0,
    w: 1280,
    h: 720,
    path: args.state.selected_layer
  }
  args.outputs.sprites << args.state.world_map_sprite
end

def setup(args)
  load_world(args)
  Menu.setup(args)
end

def load_world(args)
  world = World.instance
  world.generate_world_map
  set_render_target(:world_map, world.world_map, args)
  assign_viz_maps(args)
end

def assign_viz_maps(args)
  world = World.instance
  set_render_target(:height_viz, world.height_viz, args)
  set_render_target(:temperature_viz, world.temperature_viz, args)
  set_render_target(:moisture_viz, world.moisture_viz, args)
end

def set_render_target(target_name, primitives, args)
  args.render_target(target_name).static_primitives << primitives
  args.render_target(target_name).w = 1280
  args.render_target(target_name).h = 720
end

$gtk.reset