require 'spec_helper'

describe WorldMap do
  let(:height) { 50 }
  let(:width) { 50 }
  let(:max_temperature) { 100 }
  let(:map_equator) { height / 2 }
  let(:temperature_dropoff) { max_temperature / (height - map_equator) }
  let(:world_map) { WorldMap.new(width: width, height: height, tile_size: 2, seed: 123) }

  before { pending 'disabled until shuffle call resolved in perlin_noise.rb' }
  it 'generates a 2d array of tiles' do
    expect(world_map.map[1][1].class).to eq Tile
  end

  it 'assigns a height value to each tile' do
    expect(world_map.map[1][1].height_value).not_to be_nil
  end

  it 'assigns a temperature value to each tile' do
    y = 1
    expect(world_map.map[1][y].temperature_value).to eq max_temperature - ((map_equator - y).abs * temperature_dropoff)
  end

  it 'assigns a moisture value for each tile' do
    expect(world_map.map[1][1].moisture_value).not_to be_nil
  end
end
