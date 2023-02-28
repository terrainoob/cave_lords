class PlayMapScene
  def self.instance
    @instance ||= PlayMapScene.new
  end

  def tick(args)
    args.state.current_scene ||= :world_map if args.state.clicked_tile.nil?
    selected_world_tile = args.state.clicked_tile

    args.outputs.labels << { x: 990, y: 200, text: "Biome: #{selected_world_tile.biome}" }
  end
end