class PawnData
  attr_accessor :x_pos, :y_pos, :max_health, :current_health, :bio, :base_sprite_address
  attr_reader :state

  module States
    IDLE = 'idle'.freeze
    MOVING = 'moving'.freeze
  end

  def initialize(x_pos:, y_pos:)
    @state = States::IDLE
    @bio = {
      first_name: '',
      last_name: '',
      background: ''
    }
    @x_pos = x_pos
    @y_pos = y_pos
    @max_health = 100
    @current_health = 100
    @base_sprite_address = [0, 0]
  end

  def set_state(state)
    @state = state if States.const_defined?(state.upcase.to_s)
  end

  def take_damage(amount)
    adjust_health(-amount)
  end

  def heal(amount)
    adjust_health(amount)
  end

  private

  def adjust_health(amount)
    @current_health += amount
    @current_health = @current_health.clamp(0, max_health)
  end
end
