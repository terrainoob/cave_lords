class Tile
  attr_accessor :x, :y, :height_value, :temperature_value, :moisture_value, :biome

  def initialize(x:, y:, size:)
    @x = x
    @y = y
    @size = size
    @height_value = nil
    @temperature_value = nil
    @moisture_value = nil
    @biome = nil
  end

  def sprite
    @biome = calc_biome
    {
      path: 'sprites/biomes.png',
      tile_w: @size,
      tile_h: @size,
      tile_x: Biome.sprite_pixels[@biome][0],
      tile_y: Biome.sprite_pixels[@biome][1],
      w: @size,
      h: @size,
      x: @x * @size,
      y: @y * @size,
      primitive_marker: :sprite
    }
  end

  def calc_biome
    Biome.biome_definitions.each do |definition|
      next unless biome_found(definition)

      return definition[:biome]
    end
    :water
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