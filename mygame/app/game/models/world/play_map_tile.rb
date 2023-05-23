class PlayMapTile < Tile
  def initialize(x:, y:, size:)
    super(x: x, y: y, size: size)
    @sprite_sheet_manager = SpriteSheetManager.new('sprites/biomes.png')
    @sprite_sheet_manager.sprite_size = 4
  end

  def sprite
    # TODO: temporary sprite_x and sprite_y assignment here
    # this should be generated based on the selected biome
    @sprite_col = 0
    @sprite_row = [0, 2, 6].sample
    hash = @sprite_sheet_manager.sprite_hash(@sprite_col, @sprite_row, 2.5)
    hash[:x] = @x * @size
    hash[:y] = @y * @size
    hash
  end
end