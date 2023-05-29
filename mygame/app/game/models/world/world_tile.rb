class WorldTile < Tile
  attr_accessor :height_value, :temperature_value, :moisture_value, :biome

  def initialize(x:, y:, size:)
    super(x: x, y: y, size: size)
    @height_value = nil
    @temperature_value = nil
    @moisture_value = nil
    @biome = nil
    @sprite_sheet_manager = SpriteSheetManager.new('sprites/biomes.png')
    @sprite_sheet_manager.sprite_size = 4
  end

  def to_json(*_args)
    {
      x: @x,
      y: @y,
      sprite_x: @sprite_x,
      sprite_y: @sprite_y,
      height_value: @height_value,
      temperature_value: @temperature_value,
      moisture_value: @moisture_value,
      biome: @biome
    }.to_json(indent_depth: 0, indent_size: 4, minify: true, space_in_empty: true)
  end

  def sprite
    determine_biome
    hash = @sprite_sheet_manager.sprite_hash(@sprite_col, @sprite_row, 2.5)
    hash[:x] = @x * @size
    hash[:y] = @y * @size
    hash
  end

  def determine_biome
    found_def = Biome.biome_definitions[0]
    Biome.biome_definitions.each do |definition|
      next unless biome_found(definition)

      found_def = definition
      break
    end
    @biome = found_def[:biome]
    @sprite_col = found_def[:sprite_col] if found_def[:sprite_col]
    @sprite_row = found_def[:sprite_row] if found_def[:sprite_row]
  end

  def biome_found(definition)
    definition[:height].include?(@height_value) &&
      definition[:temperature].include?(@temperature_value) &&
      definition[:moisture].include?(@moisture_value)
  end
end
