# this is where things start when ./dragonruby is executed

require 'app/game/models/noise/perlin_noise.rb'
require 'app/game/models/world/biome.rb'
require 'app/game/models/world/tile.rb'
require 'app/game/models/world/world.rb'
require 'app/game/models/maps/world_map.rb'

def tick(args)
  args.state.selected_layer ||= :moisture_viz
  setup(args) if args.tick_count.zero?

  args.outputs.primitives << args.state.height_button.primitives
  args.outputs.primitives << args.state.moisture_button.primitives
  args.outputs.primitives << args.state.temperature_button.primitives

  try_button_click(args.state.height_button, args)
  try_button_click(args.state.moisture_button, args)
  try_button_click(args.state.temperature_button, args)

  args.state.world_map_sprite = {
    x: 0,
    y: 0,
    # w: world.world_width * world.tile_size * 10,
    # h: world.world_height * world.tile_size * 10,
    w: 720,
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

  args.state.height_button = button(10, 3, 'Height', { r: 200, g: 30, b: 200 }, :height_clicked, args )
  args.state.moisture_button = button(10, 5, 'Moisture', { r: 100, g: 130, b: 180 }, :moisture_clicked, args )
  args.state.temperature_button = button(10, 7, 'Temperature', { r: 200, g: 100, b: 30 }, :temperature_clicked, args )
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

def load_world(args)
  world = World.instance
  world.generate_world_map
  args.render_target(:moisture_viz).static_primitives << world.moisture_viz
  args.render_target(:moisture_viz).w = 64
  args.render_target(:moisture_viz).h = 128
  args.render_target(:temperature_viz).static_primitives << world.temperature_viz
  args.render_target(:temperature_viz).w = 64
  args.render_target(:temperature_viz).h = 128
  args.render_target(:height_viz).static_primitives << world.height_viz
  args.render_target(:height_viz).w = 32
  args.render_target(:height_viz).h = 64
end

$gtk.reset