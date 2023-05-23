module Scene
  class << self
    def set_render_target(target_name, primitives, args)
      args.render_target(target_name).primitives << primitives
      args.render_target(target_name).w = 1280
      args.render_target(target_name).h = 720
    end
  end
end
