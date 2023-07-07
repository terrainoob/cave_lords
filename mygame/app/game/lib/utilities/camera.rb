module Utilities
  module Camera
    def self.reset_scale(scale)
      $args.state.camera.scale = scale
    end

    def camera
      args.state.camera
    end

    def adjust_camera(scale_increment = 0.1, pan_increment = 10)
      # camera.scale ||= @initial_camera_scale
      zoom(scale_increment)
      pan(pan_increment)
    end

    def zoom(scale_increment)
      if keyboard.key_down.i || mouse.wheel&.y.to_i.positive?
        camera.scale += scale_increment
      elsif keyboard.key_down.o || mouse.wheel&.y.to_i.negative?
        camera.scale -= scale_increment
      end
    end

    def pan(pan_increment)
      camera.offset_x ||= 0
      camera.offset_y ||= 0
      camera.offset_x += inputs.left_right * pan_increment
      camera.offset_y += inputs.up_down * pan_increment
    end
  end
end
