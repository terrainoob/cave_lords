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
    generate_play_map(args) unless @play_map
    assign_play_map_sprite(args)
    set_render_target(:play_map, @play_map.sprites, args)
  end

  private

  def set_render_target(target_name, primitives, args)
    args.render_target(target_name).static_primitives << primitives
    args.render_target(target_name).w = 1280
    args.render_target(target_name).h = 720
  end

  def generate_play_map(args)
    return if @selected_world_tile.nil?

    @play_map = PlayMap.new(width: 200, height: 100, tile_size: 4, seed: 123456789)
    @play_map.generate_map
  end

  def assign_play_map_sprite(args)
    args.state.play_map_sprite = {
      x: 0,
      y: 0,
      w: 1280,
      h: 720,
      path: :play_map
    }
    args.outputs.sprites << args.state.play_map_sprite
  end
end