require 'spec_helper'

describe Game do
  it 'returns a default name' do
    expect(Game.new.name).to eq 'Cave Lords'
  end
end
