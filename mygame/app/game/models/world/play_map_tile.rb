class PlayMapTile < Tile
  def initialize(x:, y:, size:, index:)
    @index = index
    @sprite_sheet_manager = SpriteSheetManager.new('sprites/punyworld-overworld-tileset.png', 27)
    @sprite_sheet_manager.sprite_size = Config::PLAYMAP_TILE_SIZE
    super(x: x, y: y, size: size)
  end

  def sprite
    hash = @sprite_sheet_manager.sprite_hash_by_index(@index, 2.5)
    hash[:x] = @x * @size
    hash[:y] = @y * @size
    hash
  end
end