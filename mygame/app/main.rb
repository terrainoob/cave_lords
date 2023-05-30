# this is where things start when ./dragonruby is executed

require 'app/requires.rb'

def tick(args)
  GC.disable
  args.outputs.labels << {
    x: 30,
    y: 30.from_top,
    text: "#{$gtk.current_framerate.to_sf}"
  }

  assign_default_state(args.state) if args.tick_count.zero?
  handle_input(args)
  select_scene(args)
  GC.start
end

def assign_default_state(state)
  state.current_scene ||= :main_menu
  state.next_scene ||= :main_menu
  state.clicked_tile ||= nil
  state.debug ||= false
end

def handle_input(args)
  args.state.next_scene = :main_menu if args.inputs.keyboard.key_down.escape
end

def select_scene(args)
  args.state.current_scene = args.state.next_scene
  Scene.send("#{args.state.current_scene}_tick", args)
end

$gtk.reset
