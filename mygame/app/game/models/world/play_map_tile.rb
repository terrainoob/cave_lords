class PlayMapTile < Tile
  def initialize(index:, x:, y:, size:)
    @index = index
    @sprite_sheet_manager = SpriteSheetManager.new('sprites/punyworld-overworld-tileset.png', 27)
    @sprite_sheet_manager.sprite_size = 16
    super(x: x, y: y, size: size)
  end

  def sprite
    @sprite_sheet_manager.sprite_hash_by_index(@index, 2.5)
  end
end