module Scene
  class << self
    def set_render_target(target_name, primitives, args)
      return if args.state.map_displayed[target_name]

      args.render_target(target_name).primitives.concat(primitives)
      args.render_target(target_name).w = 1280
      args.render_target(target_name).h = 720
      args.state.map_displayed[target_name] = true
    end
  end
end
