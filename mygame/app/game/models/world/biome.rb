class Biome
  SEA_LEVEL = 0.5

  def self.biome_definitions
    [
      { biome: :water, sprite_x: 0, sprite_y: 0, height: (-100..SEA_LEVEL), temperature: (0..100), moisture: (0.0..1.0) },
      { biome: :sand, sprite_x: 0, sprite_y: 4, height: (SEA_LEVEL..SEA_LEVEL + 0.05), temperature: (0..100), moisture: (0.0..1.0) },
      { biome: :ice, sprite_x: 0, sprite_y: 36, height: (-100..SEA_LEVEL), temperature: (-100..0), moisture: (0.5..1.0) },
      { biome: :ice, sprite_x: 0, sprite_y: 36, height: (0.90..100), temperature: (-100..0), moisture: (0..1.0) },
      { biome: :tundra, sprite_x: 0, sprite_y: 36, height: (SEA_LEVEL..SEA_LEVEL + 0.45), temperature: (-100..-1), moisture: (0.0..1.0) },
      { biome: :taiga, sprite_x: 0, sprite_y: 8, height: (SEA_LEVEL..SEA_LEVEL + 0.6), temperature: (-10..5), moisture: (0.0..0.9) },
      { biome: :grassland, sprite_x: 0, sprite_y: 16, height: (SEA_LEVEL..SEA_LEVEL + 0.6), temperature: (0..30), moisture: (0.0..0.5) },
      { biome: :deciduous_forest, sprite_x: 0, sprite_y: 24, height: (SEA_LEVEL..SEA_LEVEL + 0.6), temperature: (0..30), moisture: (0.5..1.0) },
      { biome: :desert, sprite_x: 0, sprite_y: 20, height: (SEA_LEVEL..SEA_LEVEL + 0.5), temperature: (25..100), moisture: (0.0..0.3) },
      { biome: :savannah, sprite_x: 0, sprite_y: 32, height: (SEA_LEVEL..SEA_LEVEL + 0.5), temperature: (20..100), moisture: (0.2..0.4) },
      { biome: :forest, sprite_x: 0, sprite_y: 24, height: (SEA_LEVEL..SEA_LEVEL + 0.6), temperature: (20..100), moisture: (0.3..0.5) },
      { biome: :rainforest, sprite_x: 0, sprite_y: 28, height: (SEA_LEVEL..SEA_LEVEL + 0.6), temperature: (20..100), moisture: (0.5..9.0) },
      { biome: :mountain, sprite_x: 0, sprite_y: 40, height: (0.93..100), temperature: (0..100), moisture: (0.0..1.0) }
    ]
  end
end