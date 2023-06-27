require 'spec_helper'

describe GenericMap do
  let(:map_width) { 5 }
  let(:map_height) { 5 }
  let(:world_map) { WorldMap.new(width: map_width, height: map_height, tile_size: 10, seed: 123) }

  describe '#get_neighbor_tiles' do
    context 'when the tile is on the map edge' do
      it 'returns only non-nil neighbors' do
        current_tile = world_map.map[0][0]
        neighbors = world_map.get_neighbors(current_tile)
        expect(neighbors.size).to eq 3
        expect(neighbors).to include world_map.map[0][1]
        expect(neighbors).to include world_map.map[1][0]
        expect(neighbors).to include world_map.map[1][1]
      end
    end

    context 'when the tile is not on the map edge' do
      it 'returns all surrounding neighbors' do
        current_tile = world_map.map[2][2]
        neighbors = world_map.get_neighbors(current_tile)
        expect(neighbors.size).to eq 8
        expect(neighbors).to include world_map.map[2][1]
        expect(neighbors).to include world_map.map[2][3]
        expect(neighbors).to include world_map.map[1][1]
      end
    end
  end
end