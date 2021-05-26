require './engine.rb'
require './gyroscope.rb'
require './orientation_sensor.rb'

class Drone
  attr_reader :status

  # pitch is aligned with x axis, it seems it has two meaning here, 
  # 1) thinking of x axis as the axis for the pitch to rotate
  # 2) thinking of x axis as the direction of the plane when pitch is 0
  # I am assuming 2 here.
  MOVES = {
    forward: [:x, 20],
    back: [:x, -20],
    left: [:y, -20],
    right: [:y, 20],
    up: [:z, 20],
    down: [:z, -20]
  }

  def initialize(n)
    @engines = []
    n.times { @engines << Engine.new(self) }
    @gyroscope = Gyroscope.new(self)
    @orientation_sensor = OrientationSensor.new(self)
    @status = :off
  end

  def take_off
    raise "drone has already take off" unless status == :off
    @engines.map(&:power_on)
    # assuming it is a vertical takeoff, 
    # if it is not, then need to set the pitch and velocity_x
    @gyroscope.velocity_z = 40
    puts "drone is taking off"
    sleep(5)
    @gyroscope.velocity_z = 0
    _stablize
    @status = :hovering
    puts "drone has taken off"
  end

  MOVES.keys.each do |direction|
    define_method(direction) { _move(direction) }
  end

  def stablize
    raise "drone cannot stablize because drone is off" if status == :off
    _stablize
    @status = :hovering
    puts "drone is hovering"
  end

  def land
    raise "drone has already landed" if status == :off
    stablize
    # assuming it is a vertical landing, 
    # if it is not, then need to set the pitch and velocity_x
    @gyroscope.velocity_z = -20 # make it a negative number
    puts "drone is landing..."
    sleep(2)
    @gyroscope.velocity_z = 0
    @status = :off
    @engines.map(&:power_off)
    puts "drone landed"
  end

  def tap
    ## not sure how to implement it..
    puts "drone tapped"
    stablize
  end

  private

  def distress
    puts "distress received"
    land unless @status == :off
  end

  def _move(direction:)
    raise "drone cannot move because drone is off" if status == :off
    @gyroscope.set_velocity(*MOVES[direction.to_s])
    @status = :moving
    puts "drone is moving #{direction}"
  end

  def _stablize
    @gyroscope.stablize
    @orientation_sensor.stablize
  end
end
