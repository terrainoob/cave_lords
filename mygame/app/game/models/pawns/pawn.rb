class Pawn
  def initialize(x_pos:, y_pos:)
    @pawn_data = PawnData.new(x_pos: x_pos, y_pos: y_pos)
    @sprite_sheet_path = 'sprites/pawns.png'

  end

  def sprite
    {
      path: @sprite_sheet_path,
      tile_w: 4,
      tile_h: 4,
      tile_x: @pawn_data.base_sprite_address[:x],
      tile_y: @pawn_data.base_sprite_address[:y],
      w: 4,
      h: 4,
      x: @pawn_data.x_pos,
      y: @pawn_data.y_pos,
      primitive_marker: :sprite
    }
  end
end
