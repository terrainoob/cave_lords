require 'spec_helper'

describe Tile do
  let(:world_map) { WorldMap.new(width: 10, height: 10, tile_size: 2, seed: 123) }
  let(:map) { world_map.map }

  it 'stores the height value for a cell' do
    expect(map[1][1].height_value.class).to eq Float
  end
end