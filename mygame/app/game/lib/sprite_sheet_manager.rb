# This assumes the following:
# 1. all sprites are square
# 2. all sprites on a sheet are the same size
class SpriteSheetManager
  attr_accessor :sprite_size, :sprite_sheet_name

  Sprite = Struct.new(:x, :y, :width, :height)

  def initialize(sprite_sheet_name)
    @sprite = Sprite.new
    @sprite_size = 1
    @sprite_sheet_name = sprite_sheet_name
  end

  def sprite(index_col, index_row)
    Sprite.new(
      index_col * @sprite_size,
      index_row * @sprite_size,
      sprite_size,
      sprite_size
    )
  end

  def sprite_hash(index_col, index_row, scale_multiplier = 1.0)
    scale_multiplier = 1.0 if scale_multiplier.negative?
    s = sprite(index_col, index_row)
    {
      path: @sprite_sheet_name,
      tile_w: s.width,
      tile_h: s.height,
      tile_x: s.x,
      tile_y: s.y,
      w: s.width * scale_multiplier,
      h: s.height * scale_multiplier,
      x: s.x,
      y: s.y,
      primitive_marker: :sprite
    }
  end
end
