require 'spec_helper'

describe AStar do
  let(:a_star) { AStar.new }
  let(:map) { WorldMap.new(width: 5, height: 5, tile_size: 10, seed: 123) }
  let(:start_tile) { map[0, 0] }
  let(:end_tile) { map[3, 4] }

  # 4 - - - - -
  # 3 - - - - -
  # 2 - - - - -
  # 1 - - - - -
  # 0 - - - - -
  #   0 1 2 3 4

  it 'returns a path from the start_tile to the destination_tile' do
    skip
    path = a_star.find_path(start_tile, end_tile)
    expect(path).to contain(map[0, 0])
    expect(path).to contain(map[1, 1])
    expect(path).to contain(map[2, 2])
    expect(path).to contain(map[3, 3])
    expect(path).to contain(map[3, 4])
  end
end