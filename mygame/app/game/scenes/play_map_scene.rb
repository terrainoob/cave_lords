class PlayMapScene
  def self.instance
    @instance ||= PlayMapScene.new
  end

  def initialize
    @selected_world_tile = nil
  end

  def tick(args)
    args.state.current_scene ||= :world_map if args.state.clicked_tile.nil?
    @selected_world_tile = args.state.clicked_tile

    args.outputs.labels << { x: 990, y: 200, text: "Biome: #{@selected_world_tile.biome}" }
    generate_play_map(args)
  end

  private

  def generate_play_map(args)
    return if @selected_world_tile.nil?

    @play_map = PlayMap.new(width: 80, height: 45, tile_size: 16, seed: 123456789)
  end
end