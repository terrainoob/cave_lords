require 'spec_helper'

describe World do
  it 'keeps a single instance of itself at all times' do
    expect(World.instance.equal?(World.instance)).to be_truthy
  end
end