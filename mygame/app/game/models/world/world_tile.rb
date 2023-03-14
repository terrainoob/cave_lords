class WorldTile < Tile
  attr_accessor :height_value, :temperature_value, :moisture_value, :biome

  def initialize(x:, y:, size:)
    super(x: x, y: y, size: size)
    @height_value = nil
    @temperature_value = nil
    @moisture_value = nil
    @biome = nil
  end

  def sprite
    determine_biome
    {
      path: 'sprites/biomes.png',
      tile_w: @size,
      tile_h: @size,
      tile_x: @sprite_x,
      tile_y: @sprite_y,
      w: @size,
      h: @size,
      x: @x * @size,
      y: @y * @size,
      primitive_marker: :sprite
    }
  end

  def determine_biome
    found_def = Biome.biome_definitions[0]
    Biome.biome_definitions.each do |definition|
      next unless biome_found(definition)

      found_def = definition
      break
    end
    @biome = found_def[:biome]
    @sprite_x = found_def[:sprite_x] if found_def[:sprite_x]
    @sprite_y = found_def[:sprite_y] if found_def[:sprite_y]
  end

  def biome_found(definition)
    definition[:height].include?(@height_value) &&
      definition[:temperature].include?(@temperature_value) &&
      definition[:moisture].include?(@moisture_value)
  end

  def height_viz
    { x: (@x * @size), y: (@y * @size), w: @size, h: @size, r: 100 * @height_value, g: 100 * @height_value, b: 100 * @height_value, a: 255, primitive_marker: :solid }
  end

  def temperature_viz
    { x: (@x * @size), y: (@y * @size), w: @size, h: @size, r: 4 * @temperature_value, g: 80 - @temperature_value, b: 200 - (4 * temperature_value), a: 255, primitive_marker: :solid }
  end

  def moisture_viz
    { x: (@x * @size), y: (@y * @size), w: @size, h: @size, r: 0, g: 0, b: 255 * @moisture_value, a: 255, primitive_marker: :solid }
  end
end