# This implementation of Noise is taken from
# https://github.com/mjwhitt/fractal_noise
#
# the algorithm is unchanged. I've just rearranged/merged
# some of the file structure to make 'requires' a little
# cleaner in DragonRuby. I also gave it a once-over with
# Rubocop

module Noise
  class Base
    attr_reader :fractal, :octaves

    def initialize(width, height, random = Random.new)
      @width = width
      @height = height
    end

    def generate(octaves=6, persistence=0.6)
      @fractal = array { 0.0 }
      @octaves = Array.new(octaves) { |octave| noise(octave) }

      amplitude = array { 1.0 }
      max       = array { 0.0 }

      (octaves - 1).downto(0) do |octave|
        xy do |x, y|
          amplitude[x][y] *= persistence.is_a?(Array) ? persistence[x][y] : persistence
          max[x][y]       += amplitude[x][y]
          @fractal[x][y]  += @octaves[octave][x][y] * amplitude[x][y]
        end
      end

      xy { |x, y| @fractal[x][y] /= max[x][y] }

      @fractal
    end

    private

    def linear_interpolation(a, b, alpha)
      (a * (1 - alpha)) + (b * alpha)
    end

    def cosine_interpolation(a, b, alpha)
      alpha = (1.0 - Math.cos(alpha*Math::PI)) / 2.0
      (a * (1 - alpha)) + (b * alpha)
    end

    def array
      Array.new(@width) { Array.new(@height) { yield } }
    end

    def xy
      @width.times { |x| @height.times { |y| yield(x, y) } }
    end
  end

  def normalize
    min = 1.0
    max = 0.0

    xy do |x, y|
      value = @fractal[x][y]
      min   = value if value < min
      max   = value if value > max
    end

    xy { |x, y| @fractal[x][y] = (@fractal[x][y] - min) / (max - min) }
  end

  def gamma_filter(gamma)
    xy { |x, y| @fractal[x][y] = @fractal[x][y] ** gamma }
  end

  def median_filter(window)
    edgex = (window / 2).floor
    edgey = (window / 2).floor
    noise = array { 0 }

    xy { |x, y| noise[x][y] = @fractal[x][y] }

    xy do |x, y|
      values = []

      window.times do |fx|
        window.times do |fy|
          wx = x + fx - edgex
          wy = y + fy - edgey

          wx -= @width  if wx >= @width
          wy -= @height if wy >= @height

          values << @fractal[wx][wy]
        end
      end

      values.sort!
      len = values.length
      new_value = len % 2 == 1 ? values[len / 2] : (values[(len / 2) - 1] + values[len / 2]).to_f / 2
      noise[x][y] = new_value
    end

    @fractal = noise
  end

  def range(min, max)
    xy { |x, y| @fractal[x][y] = ((@fractal[x][y] * (max - min)) / 1.0) + min }
  end
end
