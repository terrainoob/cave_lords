# this is where things start when ./dragonruby is executed

require 'app/game/models/noise/perlin_noise.rb'
require 'app/game/models/world/biome.rb'
require 'app/game/models/world/tile.rb'
require 'app/game/models/world/world.rb'
require 'app/game/models/maps/world_map.rb'

def tick(args)
  args.state.selected_layer ||= :height_viz
  setup(args) if args.tick_count.zero?
  menu_tick(args)
  set_map(args)
end

def menu_tick(args)
  args.outputs.primitives << args.state.height_button.primitives
  args.outputs.primitives << args.state.moisture_button.primitives
  args.outputs.primitives << args.state.temperature_button.primitives
  args.outputs.primitives << args.state.map_button.primitives

  try_button_click(args.state.height_button, args)
  try_button_click(args.state.moisture_button, args)
  try_button_click(args.state.temperature_button, args)
  try_button_click(args.state.map_button, args)
end

def set_map(args)
  args.state.world_map_sprite = {
    x: 0,
    y: 0,
    w: 1280,
    h: 720,
    path: args.state.selected_layer
  }
  args.outputs.sprites << args.state.world_map_sprite
end

def button(row, col, text, color, m, args)
  rect = args.layout.rect(row: row, col: col, w: 2, h: 1)
  {
    m: m,
    rect: rect,
    primitives: [
      color.merge(rect).solid!,
      {
        x: rect.x + ( rect.w / 2 ),
        y: rect.y + ( rect.h / 2 ),
        text: text,
        vertical_alignment_enum: 1,
        alignment_enum: 1
      }
    ]
  }
end

def setup(args)
  load_world(args)

  args.state.height_button = button(12, 1, 'Height', { r: 200, g: 30, b: 200 }, :height_clicked, args)
  args.state.moisture_button = button(12, 3, 'Moisture', { r: 100, g: 130, b: 180 }, :moisture_clicked, args)
  args.state.temperature_button = button(12, 5, 'Temperature', { r: 200, g: 100, b: 30 }, :temperature_clicked, args)
  args.state.map_button = button(12, 7, 'Map', { r: 100, g: 200, b: 30 }, :map_clicked, args)
end

def try_button_click(button, args)
  return if !args.inputs.mouse.click
  send(button.m, args) if args.inputs.mouse.intersect_rect? button.rect
end

def height_clicked(args)
  args.state.selected_layer = :height_viz
end

def temperature_clicked(args)
  args.state.selected_layer = :temperature_viz
end

def moisture_clicked(args)
  args.state.selected_layer = :moisture_viz
end

def map_clicked(args)
  args.state.selected_layer = :world_map
end

def load_world(args)
  world = World.instance
  world.generate_world_map
  set_render_target(:height_viz, world.height_viz, args)
  set_render_target(:temperature_viz, world.temperature_viz, args)
  set_render_target(:moisture_viz, world.moisture_viz, args)
  set_render_target(:world_map, world.world_map, args)
end

def set_render_target(target_name, primitives, args)
  args.render_target(target_name).static_primitives << primitives
  args.render_target(target_name).w = 1280
  args.render_target(target_name).h = 720
end

$gtk.reset