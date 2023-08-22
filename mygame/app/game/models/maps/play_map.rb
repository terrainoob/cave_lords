class PlayMap < GenericMap
  def initialize(width:, height:, tile_size:, seed:, selected_world_tile:)
    @selected_world_tile = selected_world_tile
    super(width: width, height: height, tile_size: tile_size, seed: seed)
  end

  def generate_map
    if @selected_world_tile
      # select tileset based on biome
      # use wfc to generate random map from that tileset.
      json = $gtk.read_file('sprites/punyworld-overworld-wfc.json')
      tileset = LevisLibs::JSON.parse(json, symbolize_keys: true, extensions: true)
      model = Wfc::SimpleTiledModel.new(tileset, Config::PLAYMAP_WIDTH, Config::PLAYMAP_HEIGHT)
      tiled_map = model.solve_all

      # @sprites = tile_map.flatten.map(&:sprite)
    else
      puts "YOU DON'T HAVE A SELECTED WORLD TILE IN THE PLAYMAP GEN!!!  STUPID!!!"
    end
  end
end