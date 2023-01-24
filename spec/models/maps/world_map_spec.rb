require 'spec_helper'

describe WorldMap do
  let!(:world_map) { WorldMap.new(width: 50, height: 50, tile_size: 2, seed: 123) }

  it 'generates a 2d array of tiles' do
    expect(world_map.map[1][1].class).to eq Tile
  end
end
