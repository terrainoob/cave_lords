class Tile
  attr_accessor :height_value, :temperature_value, :moisture_value, :biome

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
    calc_biome
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
    if @height_value <= 0.5
      @biome = :water
    elsif @height_value <= 0.7
      if @moisture_value < 0.3
        @biome = :desert
      else
        @biome = :sand
      end
    else
      @biome = :grassland
    end
  end

  def height_viz
    if @height_value <= 0.4
      sprite = { x: (@x * @size), y: (@y * @size), w: @size, h: @size, r: 0, g: 0, b: 255, a: 255, primitive_marker: :solid }
    elsif @height_value > 1.5
      sprite = { x: (@x * @size), y: (@y * @size), w: @size, h: @size, r: 255, g: 255, b: 255, a: 255, primitive_marker: :solid }
    else
      sprite = { x: (@x * @size), y: (@y * @size), w: @size, h: @size, r: 100 * @height_value, g: 100 * @height_value, b: 100 * @height_value, a: 255, primitive_marker: :solid }
    end
    sprite
  end

  def temperature_viz
    { x: (@x * @size), y: (@y * @size), w: @size, h: @size, r: 1 * @temperature_value, g: 0, b: 0, a: 255, primitive_marker: :solid }
  end

  def moisture_viz
    { x: (@x * @size), y: (@y * @size), w: @size, h: @size, r: 0, g: 0, b: 255 * @moisture_value, a: 255, primitive_marker: :solid }
  end
end