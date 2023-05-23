class Biome
  SEA_LEVEL = 0.5

  def self.biome_definitions
    [
      { biome: :water, sprite_col: 0, sprite_row: 0, height: (-100..SEA_LEVEL), temperature: (0..100), moisture: (0.0..1.0) },
      { biome: :sand, sprite_col: 0, sprite_row: 1, height: (SEA_LEVEL..SEA_LEVEL + 0.05), temperature: (0..100), moisture: (0.0..1.0) },
      { biome: :ice, sprite_col: 0, sprite_row: 8, height: (-100..SEA_LEVEL), temperature: (-100..0), moisture: (0.5..1.0) },
      { biome: :ice, sprite_col: 0, sprite_row: 8, height: (0.90..100), temperature: (-100..0), moisture: (0..1.0) },
      { biome: :tundra, sprite_col: 0, sprite_row: 8, height: (SEA_LEVEL..SEA_LEVEL + 0.45), temperature: (-100..-1), moisture: (0.0..1.0) },
      { biome: :taiga, sprite_col: 0, sprite_row: 2, height: (SEA_LEVEL..SEA_LEVEL + 0.6), temperature: (-10..5), moisture: (0.0..0.9) },
      { biome: :grassland, sprite_col: 0, sprite_row: 4, height: (SEA_LEVEL..SEA_LEVEL + 0.6), temperature: (0..30), moisture: (0.0..0.5) },
      { biome: :deciduous_forest, sprite_col: 0, sprite_row: 6, height: (SEA_LEVEL..SEA_LEVEL + 0.6), temperature: (0..30), moisture: (0.5..1.0) },
      { biome: :desert, sprite_col: 0, sprite_row: 5, height: (SEA_LEVEL..SEA_LEVEL + 0.5), temperature: (25..100), moisture: (0.0..0.3) },
      { biome: :savannah, sprite_col: 0, sprite_row: 8, height: (SEA_LEVEL..SEA_LEVEL + 0.5), temperature: (20..100), moisture: (0.2..0.4) },
      { biome: :forest, sprite_col: 0, sprite_row: 6, height: (SEA_LEVEL..SEA_LEVEL + 0.6), temperature: (20..100), moisture: (0.3..0.5) },
      { biome: :rainforest, sprite_col: 0, sprite_row: 7, height: (SEA_LEVEL..SEA_LEVEL + 0.6), temperature: (20..100), moisture: (0.5..9.0) },
      { biome: :mountain, sprite_col: 0, sprite_row: 10, height: (0.93..100), temperature: (0..100), moisture: (0.0..1.0) }
    ]
  end
end
