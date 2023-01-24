require 'spec_helper'

describe 'Perlin::Noise' do
  it 'returns random values between 0 and 2 for each cell' do
    # normally, Perlin noise algorithms will return values
    # either from -1 to 1 or from 0 to 1. However,
    # in our case, we use 0 to 2 because we want the wide
    # range of -1 to 1 but we want all the values positive
    # so that we can easily gray-scale the value colors for
    # quick visualization
    skip
  end

  it 'requires width and height values to be passed in' do
    skip
  end
end
