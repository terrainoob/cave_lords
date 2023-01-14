module Noise
  class PerlinNoise < Noise::Base
    def initialize(width, height, random = Random.new)
      super
      @p = (0...(@width > @height ? @width : @height)).to_a.shuffle(random) * 2 #use this line for DR
      # @p = (0...(@width > @height ? @width : @height)).to_a.shuffle(random: random) * 2 # use this line for rspec
    end

    def noise(octave)
      noise     = array { nil }
      period    = 1 << octave
      frequency = 1.0 / period

      @width.times do |x|
        xa = (x * frequency) % (@width * frequency)
        x1 = xa.to_i
        x2 = (x1 + 1) % (@width * frequency)

        xf = xa - xa.to_i
        xb = fade(xf)

        @height.times do |y|
          ya = (y * frequency) % (@height * frequency)
          y1 = ya.to_i
          y2 = (y1 + 1) % (@height * frequency)

          yf = ya - ya.to_i
          yb = fade(yf)

          top    = interpolate(gradient(@p[@p[x1] + y1], xf, yf), gradient(@p[@p[x2] + y1], xf - 1, yf), xb)
          bottom = interpolate(gradient(@p[@p[x1] + y2], xf, yf - 1), gradient(@p[@p[x2] + y2], xf - 1, yf - 1), xb)

          noise[x][y] = (interpolate(top, bottom, yb) + 1) / 2
        end
      end

      noise
    end

    private

    def interpolate(a, b, alpha)
      linear_interpolation(a, b, alpha)
    end

    def fade(t)
      t * t * t * ((t * ((t * 6) - 15)) + 10)
    end

    def gradient(h, x, y)
      case h & 7
        when 0 then y
        when 1 then x + y
        when 2 then x
        when 3 then x - y
        when 4 then -y
        when 5 then -x - y
        when 6 then -x
        when 7 then -x + y
      end
    end
  end
end
