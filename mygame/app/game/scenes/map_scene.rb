class MapScene < Scene
  extend Utilities::Input
  extend Utilities::Camera

  class << self
    def set_sprite_offsets
      @sprite_width = 2560 * camera.scale
      @sprite_height = 1440 * camera.scale

      @x_offset = 0
      @y_offset = 0
    end

    def handle_camera
      adjust_camera
      set_sprite_offsets
    end

    def draw_sprite(path_name)
      args.outputs.sprites <<
        {
          x: @x_offset + (camera.offset_x / 2),
          y: @y_offset + (camera.offset_y / 2),
          w: @sprite_width,
          h: @sprite_height,
          path: path_name
        }.to_sprite
    end
  end
end
