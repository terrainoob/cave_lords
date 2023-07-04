module Giatros
  module Ducks
    module Initialize
      def initialize(**args)
        args.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
        instance_variables.each do |ivar_sym|
          define_singleton_method(ivar_sym.to_s[1..-1].to_sym) do
            instance_variable_get(ivar_sym)
          end
          define_singleton_method((ivar_sym.to_s[1..-1]+?=).to_sym) do |arg|
            instance_variable_set(ivar_sym, arg)
          end
        end
      end
    end
    
    module Serialize
      def serialize
        instance_variables.map do |key|
          [key.to_s[1..-1].to_sym, instance_variable_get(key)]
        end.to_h
      end
      
      def to_s
        serialize.to_s
      end
      
      def inspect
        to_s
      end
    end
    
    class Sprite
      include Initialize
      include Serialize
      include AttrSprite
      
      def initialize(**args)
        @primitive_marker = :sprite
        @x, @y, @w, @h = 0, 0, 50, 50
        @r, @g, @b, @a = 255, 255, 255, 255
        @path = object_id.to_s.to_sym
        @source_x, @source_y, @source_w, @source_h = 0, 0, -1, -1
        @tile_x, @tile_y, @tile_w, @tile_h = 0, 0, -1, -1
        @angle, @angle_anchor_x, @angle_anchor_y = 0, @w/2, @h/2
        @flip_horizontally, @flip_vertically = false, false
        super
      end
    end
  end
end
