require 'spec_helper'

describe AStar do
  let(:a_star) { AStar.new }
  let(:world_map) { WorldMap.new(width: 5, height: 5, tile_size: 10, seed: 123).map }
  let(:start_tile) { world_map[0, 0] }
  let(:end_tile) { world_map[3, 4] }

  # 4 - - - - -
  # 3 - - - - -
  # 2 - - - - -
  # 1 - - - - -
  # 0 - - - - -
  #   0 1 2 3 4

  it 'returns a path from the start_tile to the destination_tile' do
    skip
    path = a_star.find_path(start_tile, end_tile, world_map)

    expect(path).to include(world_map[0, 0])
    expect(path).to include(world_map[1, 1])
    expect(path).to include(world_map[2, 2])
    expect(path).to include(world_map[3, 3])
    expect(path).to include(world_map[3, 4])
  end
end