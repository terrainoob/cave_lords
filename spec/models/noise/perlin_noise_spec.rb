require 'spec_helper'

describe 'Perlin::Noise' do
  it 'returns random values between 0 and 1 for each cell' do
    noise = Perlin::Noise.new(2)
    0.step(1, 0.01) do |x|
      0.step(1, 0.01) do |y|
        expect(noise[x, y]).to be_between(0.0, 1.0)
      end
    end
  end
end
