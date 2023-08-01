class PlayMap < GenericMap
  def initialize(width:, height:, tile_size:, seed:, selected_world_tile:)
    @selected_world_tile = selected_world_tile
    super(width: width, height: height, tile_size: tile_size, seed: seed)
  end

  def generate_map
    if @selected_world_tile
      # select tileset based on biome
      # use wfc to generate random map from that tileset.
    else
      puts "YOU DON'T HAVE A SELECTED WORLD TILE IN THE PLAYMAP GEN!!!  STUPID!!!"
    end
  end
end