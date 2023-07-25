class MapScene < Scene
  extend Utilities::Input
  extend Utilities::Camera

  class << self
    def set_sprite_offsets
      camera.scale ||= 1
      @sprite_width = @map_sprite_width * camera.scale
      @sprite_height = @map_sprite_height * camera.scale
    end

    def handle_camera
      adjust_camera
      set_sprite_offsets
    end

    def draw_sprite(path_name)
      args.outputs.sprites <<
        {
          x: (camera.offset_x / 2) + camera.x,
          y: (camera.offset_y / 2) + camera.y,
          w: @sprite_width,
          h: @sprite_height,
          path: path_name
        }
    end
  end
end
