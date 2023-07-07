class Scene
  extend Utilities::GameData

  class << self
    def symbol_to_class(scene_symbol)
      Object.const_get(scene_symbol.to_s.split('_').map(&:capitalize).join)
    end

    def set_render_target(target_name, primitives)
      return if args.state.map_displayed[target_name]

      args.render_target(target_name).primitives.concat(primitives)
      args.render_target(target_name).w = 1280
      args.render_target(target_name).h = 720
      args.state.map_displayed[target_name] = true
    end
  end
end
