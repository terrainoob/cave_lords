# this is where things start when ./dragonruby is executed

require 'app/requires.rb'

def tick(args)
  assign_default_state(args.state) if args.tick_count.zero?
  handle_input(args)
  select_scene(args)

  debug_display(args) unless $gtk.production?

  GC.enable
  GC.start
  GC.disable
end

def debug_display(args)
  args.outputs.labels <<
    [
      Giatros::Frametimer.frametime_label,
      Giatros::Frametimer.fps_label,
      { y: $gtk.args.grid.top - 40, r: 255, text: "DR v#{$gtk.version}" }
    ]
end

def assign_default_state(state)
  state.current_scene ||= :main_menu_scene
  state.next_scene ||= :main_menu_scene
  state.clicked_tile ||= nil
  state.debug ||= false
end

def handle_input(args)
  args.state.next_scene = :main_menu_scene if args.inputs.keyboard.key_down.escape
end

def select_scene(args)
  args.state.current_scene = args.state.next_scene
  Scene.symbol_to_class(args.state.current_scene).tick(args)
end

$gtk.reset
