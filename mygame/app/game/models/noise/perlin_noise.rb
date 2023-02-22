module Noise
  if !Object.const_defined? :MRUBY_VERSION
    module RubyShimArray
      def shuffle(random)
        super(random: random)
      end
    end

    Array.prepend(RubyShimArray)
  end

  class PerlinNoise
    # opts can include any of:
    # {
    #   octaves:
    #   persistence:
    #   lacunarity:
    #   seed
    # }
    def initialize(width:, height:, opts: {})
      @width = width
      @height = height
      options = { octaves: 1, persistence: 0.5, lacunarity: 2, seed: 123 }
      options.merge!(opts)
      @octaves = options[:octaves]
      @persistence = options[:persistence]
      @lacunarity = options[:lacunarity]
      @p = (0...([@width, @height].max)).to_a.shuffle(Random.new(options[:seed])) * 2
      @cache = []
      @grad_ary = [
        -> (x, y) { y },
        -> (x, y) { x + y },
        -> (x, y) { x },
        -> (x, y) { x - y },
        -> (x, y) { -y },
        -> (x, y) { -x - y },
        -> (x, y) { -x },
        -> (x, y) { -x + y }
      ]
    end

    def noise2d_value(x, y)
      if @cache[x]&.[](y)
        @cache[x][y]
      else
        cx = (@cache[x] ||= [])
        total = 0.0
        amplitude = 1

        @frequency = 0.05
        @octaves.times do |octave|
          total += noise2d(x, y, octave) * amplitude
          amplitude *= @persistence
          @frequency *= @lacunarity
        end
        cx[y] = total
      end
    end

    private

    def noise2d(x, y, octave)
      period = 1 << octave
      frequency = @frequency / period
      w_frequency = @width * frequency
      h_frequency = @height * frequency

      xa = (x * frequency) % w_frequency
      x1 = xa.to_i
      x2 = (x1 + 1) % w_frequency

      xf = xa - x1
      xb = fade(xf)

      px1 = @p[x1]
      px2 = @p[x2]

      ya = (y * frequency) % h_frequency
      y1 = ya.to_i
      y2 = (y1 + 1) % h_frequency

      yf = ya - y1
      yb = fade(yf)
      top = lerp(@grad_ary[@p[px1 + y1] & 0x7][xf, yf], @grad_ary[@p[px2 + y1] & 0x7][xf - 1, yf], xb)
      bottom = lerp(@grad_ary[@p[px1 + y2] & 0x7][xf, yf - 1], @grad_ary[@p[px2 + y2] & 0x7][xf - 1, yf - 1], xb)
      (lerp(top, bottom, yb) + 1) / 2
    end

    def lerp(start, stop, step)
      (stop * step) + (start * (1.0 - step))
    end

    def fade(t)
      t * t * t * ((t * ((t * 6) - 15)) + 10)
    end
  end
end