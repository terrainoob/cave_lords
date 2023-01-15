module Noise
  class PerlinNoise
    def initialize(
      width = 1280,
      height = 720,
      octaves = 1,
      persistence = 0.5,
      lacunarity = 2,
      random = Random.new()
    )
      @width = width
      @height = height
      @octaves = octaves
      @persistence = persistence
      @lacunarity = lacunarity
      @p = (0...([@width, @height].max)).to_a.shuffle(random) * 2
    end

    def noise2d_value(x, y)
      total = 0.0
      frequency = 0.1
      amplitude = 1

      @octaves.times do
        total += noise2d(x * frequency, y * frequency) * amplitude
        amplitude *= @persistence
        frequency *= @lacunarity
      end
      return total.clamp(0, 1)
    end

    private

    def noise2d(x, y)
      xi = x & @width
      yi = y & @height
      xf = x - x.to_i
      yf = y - y.to_i
      u = fade(xf)
      v = fade(yf)

      aa = @p[@p[xi    ] +  yi     ]
      ab = @p[@p[xi    ] + (yi + 1)]
      ba = @p[@p[xi + 1] +  yi     ]
      bb = @p[@p[xi + 1] + (yi + 1)]

      x1 = lerp(gradient(aa, xf, yf), gradient(ba, xf - 1, yf), u)
      x2 = lerp(gradient(ab, xf -1, yf), gradient(bb, xf - 1, yf - 1), u)
      return (lerp(x1, x2, v) + 1) / 2
    end

    def lerp(start, stop, step)
      (stop * step) + (start * (1.0 - step))
    end

    def fade(t)
      t * t * t * ((t * ((t * 6) - 15)) + 10)
    end

    def gradient(hash, x, y)
      case hash & 7
      when  0 then      y
      when  1 then  x + y
      when  2 then  x
      when  3 then  x - y
      when  4 then    - y
      when  5 then -x - y
      when  6 then -x
      when  7 then -x + y
      end
    end
  end
end