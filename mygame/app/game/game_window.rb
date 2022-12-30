require 'gosu'
require 'hasu'

# to hotload files:
# Hasu.load('something.rb')

class GameWindow < Hasu::Window
  def initialize
    super(1920, 1080)
    self.caption = 'Cave Lords'
  end

  def reset
    # put hot-loaded init code here instead of .initialize for hasu
  end

  def update
    #
  end

  def draw
    #
  end
end
