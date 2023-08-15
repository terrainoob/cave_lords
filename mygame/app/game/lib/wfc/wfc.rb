require_relative 'cell.rb'
require_relative 'simple_tiled_model.rb'

module Wfc
  OPPOSITE_OF = {
    up: :down,
    down: :up,
    left: :right,
    right: :left
  }.freeze

  DIRECTION_TO_INDEX = {
    up: 0,
    right: 1,
    down: 2,
    left: 3
  }.freeze
end
