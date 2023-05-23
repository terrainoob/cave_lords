require 'spec_helper'

describe SpriteSheetManager do
  let(:sprite_size) { 4 }
  let(:sprite_sheet_name) { 'dummy_sheet.png' }
  let(:sprite_sheet_manager) { described_class.new(sprite_sheet_name) }
  let(:x_index) { 2 }
  let(:y_index) { 2 }

  it 'returns sprite information based on sprite index' do
    sprite_sheet_manager.sprite_size = sprite_size
    [1, 2, 3].each do |x_index|
      [2, 4, 6].each do |y_index|
        expect(sprite_sheet_manager.sprite(x_index, y_index).x).to eq x_index * sprite_size
        expect(sprite_sheet_manager.sprite(x_index, y_index).y).to eq y_index * sprite_size
        expect(sprite_sheet_manager.sprite(x_index, y_index).width).to eq sprite_size
        expect(sprite_sheet_manager.sprite(x_index, y_index).height).to eq sprite_size
      end
    end
  end

  it 'returns correct sprite hash based on sprite index' do
    sprite = sprite_sheet_manager.sprite(x_index, y_index)
    expect(sprite_sheet_manager.sprite_hash(x_index, y_index)).to eq(
      {
        path: sprite_sheet_name,
        tile_w: sprite.width,
        tile_h: sprite.height,
        tile_x: sprite.x,
        tile_y: sprite.y,
        w: sprite.width,
        h: sprite.height,
        x: sprite.x,
        y: sprite.y,
        primitive_marker: :sprite
      }
    )
  end

  it 'can scale the sprite' do
    multiplier = 3.0
    sprite = sprite_sheet_manager.sprite(x_index, y_index)
    expect(sprite_sheet_manager.sprite_hash(x_index, y_index, multiplier)).to eq(
      {
        path: sprite_sheet_name,
        tile_w: sprite.width,
        tile_h: sprite.height,
        tile_x: sprite.x,
        tile_y: sprite.y,
        w: sprite.width * multiplier,
        h: sprite.height * multiplier,
        x: sprite.x,
        y: sprite.y,
        primitive_marker: :sprite
      }
    )
  end

  it 'defaults the multiplier to 1' do
    sprite = sprite_sheet_manager.sprite(x_index, y_index)
    expect(sprite_sheet_manager.sprite_hash(x_index, y_index)).to eq(
      {
        path: sprite_sheet_name,
        tile_w: sprite.width,
        tile_h: sprite.height,
        tile_x: sprite.x,
        tile_y: sprite.y,
        w: sprite.width,
        h: sprite.height,
        x: sprite.x,
        y: sprite.y,
        primitive_marker: :sprite
      }
    )
  end

  it 'prevents the multiplier from being negative' do
    multiplier = -0.5
    sprite = sprite_sheet_manager.sprite(x_index, y_index)
    expect(sprite_sheet_manager.sprite_hash(x_index, y_index, multiplier)).to eq(
      {
        path: sprite_sheet_name,
        tile_w: sprite.width,
        tile_h: sprite.height,
        tile_x: sprite.x,
        tile_y: sprite.y,
        w: sprite.width,
        h: sprite.height,
        x: sprite.x,
        y: sprite.y,
        primitive_marker: :sprite
      }
    )
  end
end
