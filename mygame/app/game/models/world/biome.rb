class Biome
  def self.lookup
    {
      water: [0, 0],
      sand: [0, 4],
      ice: [0, 36],
      taiga: [0, 8],
      grassland: [0, 16],
      desert: [0, 20],
      forest: [0, 24],
      rainforest: [0, 28],
      savannah: [0, 32]
    }
  end
end