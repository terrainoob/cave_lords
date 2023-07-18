class WorldTile < Tile
  MINIMUM_RIVER_MOISTURE = 0.3
  RIVER_START_PCT = 0.05

  attr_accessor :height_value, :temperature_value, :moisture_value, :biome, :has_river, :river_start_tile

  def initialize(x:, y:, size:)
    super(x: x, y: y, size: size)
    @has_river = false
    @river_start_tile = false
    @height_value = nil
    @temperature_value = nil
    @moisture_value = nil
    @biome = nil
    @sprite_sheet_manager = SpriteSheetManager.new('sprites/landscape_tileset.png')
    @sprite_sheet_manager.sprite_size = 8
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
    # hash = @sprite_sheet_manager.sprite_hash(@sprite_col, @sprite_row, 2.5)
    hash = @sprite_sheet_manager.sprite_hash(@sprite_col, @sprite_row, 1.25)
    hash[:x] = @x * @size
    hash[:y] = @y * @size
    hash.merge!({ r: 0, g: 0, b: 255, path: :pixel }) if @has_river
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
    @sprite_col = found_def[:sprite_col]
    @sprite_row = found_def[:sprite_row]
    @river_start_tile = true if @moisture_value > MINIMUM_RIVER_MOISTURE && @biome == :mountain && rand > 1.0 - RIVER_START_PCT
  end

  def biome_found(definition)
    definition[:height].include?(@height_value) &&
      definition[:temperature].include?(@temperature_value) &&
      definition[:moisture].include?(@moisture_value)
  end
end
