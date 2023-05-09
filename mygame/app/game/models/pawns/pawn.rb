class Pawn
  def initialize(x_pos:, y_pos:)
    @pawn_data = PawnData.new(x_pos: x_pos, y_pos: y_pos)
    @sprite_sheet_path = 'sprites/pawns.png'
  end

  def sprite
    {
      path: @sprite_sheet_path,
      tile_w: 32,
      tile_h: 32,
      tile_x: @pawn_data.base_sprite_address[:x],
      tile_y: @pawn_data.base_sprite_address[:y],
      w: 16,
      h: 16,
      x: @pawn_data.x_pos,
      y: @pawn_data.y_pos,
      primitive_marker: :sprite
    }
  end
end
