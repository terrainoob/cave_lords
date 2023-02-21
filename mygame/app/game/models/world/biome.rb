class Biome
  def self.sprite_pixels
    {
      water:      [0, 0],
      sand:       [0, 4],
      taiga:      [0, 8],
      grassland:  [0, 16],
      desert:     [0, 20],
      forest:     [0, 24],
      rainforest: [0, 28],
      savannah:   [0, 32],
      ice:        [0, 36]
    }
  end

  # def self.biome_definitions
  #   {
  #     water: { height: [0..0.4], temperature: [0..50], moisture: [] },
  #     sand: { height: [0.4..0.5], temperature: [], moisture: [] }
  #   }
  # end
end