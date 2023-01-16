require 'spec_helper'

describe 'Perlin::Noise' do
  let(:width) { 100 }
  let(:height) { 100 }
  let(:seed) { 123 }
  it 'returns random values between 0 and 1 for each cell' do
    skip("we don't really need this. it was just to get the spec flow running")
    # generator = Noise::PerlinNoise.new(width, height, Random.new(seed))
    # noise = generator.generate(6, 0.6)
    # width.times do |x|
    #   height.times do |y|
    #     expect(noise[x][y]).to be_between(-1.0, 1.0)
    #   end
    # end
  end
end
