require 'spec_helper'

describe PawnData do
  let(:pawn_data) { PawnData.new(x_pos: 100, y_pos: 100) }

  it 'knows where it is at all times' do
    expect(pawn_data.x_pos).to eq 100
    expect(pawn_data.y_pos).to eq 100
  end

  describe 'stats' do
    it 'has max_health' do
      expect(pawn_data.max_health).to eq 100
    end

    it 'has current health' do
      expect(pawn_data.current_health).to eq 100
    end

    it 'has bio information' do
      expect(pawn_data.bio[:first_name]).to eq ''
      expect(pawn_data.bio[:last_name]).to eq ''
    end
  end

  describe '#health' do
    it 'can take damage to reduce its health' do
      pawn_data.take_damage(10)
      expect(pawn_data.current_health).to eq 90
    end

    it 'can heal to increase health' do
      pawn_data.take_damage(10)
      pawn_data.heal(5)
      expect(pawn_data.current_health).to eq 95
    end

    it 'cannot heal past max_health' do
      pawn_data.heal(5)
      expect(pawn_data.current_health).to eq 100
    end
  end

  describe '#state' do
    it 'has a valid state' do
      expect(pawn_data.state).to eq PawnData::States::IDLE
    end

    it 'can have its state changed' do
      pawn_data.set_state(PawnData::States::MOVING)
      expect(pawn_data.state).to eq PawnData::States::MOVING
    end

    it 'cannot have its state changed to a non-valid state' do
      pawn_data.set_state('bogus_state')
      expect(pawn_data.state).to eq PawnData::States::IDLE
    end
  end

  describe '#sprite' do
    it 'have a base_sprite_address' do
      expect(pawn_data.base_sprite_address).to eq [0, 0]
    end

    it 'can have its base_sprite_address changed' do
      pawn_data.base_sprite_address = [1, 1]
      expect(pawn_data.base_sprite_address).to eq [1, 1]
    end
  end
end
