class Biome
  SEA_LEVEL = 0.5

  def self.sprite_pixels
    {
      water:            [0, 0],
      sand:             [0, 4],
      taiga:            [0, 8],
      grassland:        [0, 16],
      desert:           [0, 20],
      forest:           [0, 24],
      deciduous_forest: [0, 24],
      rainforest:       [0, 28],
      savannah:         [0, 32],
      ice:              [0, 36],
      tundra:           [0, 36],
      mountain:         [0, 40]
    }
  end

  def self.biome_definitions
    [
      { biome: :water,             height: (-100..SEA_LEVEL),             temperature: (   0..100), moisture: (0.0..1.0) },
      { biome: :sand,              height: (SEA_LEVEL..SEA_LEVEL + 0.05), temperature: (   0..100), moisture: (0.0..1.0) },
      { biome: :ice,               height: (-100..SEA_LEVEL),             temperature: (-100..0),   moisture: (0.5..1.0) },
      { biome: :ice,               height: (0.90..100),                   temperature: (-100..0),   moisture: (0..1.0) },
      { biome: :tundra,            height: (SEA_LEVEL..SEA_LEVEL + 0.45), temperature: (-100..-1),  moisture: (0.0..1.0) },
      { biome: :taiga,             height: (SEA_LEVEL..SEA_LEVEL + 0.6),  temperature: ( -10..5),   moisture: (0.0..0.9) },
      { biome: :grassland,         height: (SEA_LEVEL..SEA_LEVEL + 0.6),  temperature: (   0..30),  moisture: (0.0..0.5) },
      { biome: :deciduous_forest,  height: (SEA_LEVEL..SEA_LEVEL + 0.6),  temperature: (   0..30),  moisture: (0.5..1.0) },
      { biome: :desert,            height: (SEA_LEVEL..SEA_LEVEL + 0.5),  temperature: (  25..100), moisture: (0.0..0.3) },
      { biome: :savannah,          height: (SEA_LEVEL..SEA_LEVEL + 0.5),  temperature: (  20..100), moisture: (0.2..0.4) },
      { biome: :forest,            height: (SEA_LEVEL..SEA_LEVEL + 0.6),  temperature: (  20..100), moisture: (0.3..0.5) },
      { biome: :rainforest,        height: (SEA_LEVEL..SEA_LEVEL + 0.6),  temperature: (  20..100), moisture: (0.5..9.0) },
      { biome: :mountain,          height: (0.93..100),                   temperature: (   0..100), moisture: (0.0..1.0) }
    ]
  end
end