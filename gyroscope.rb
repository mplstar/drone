class Gyroscope
  attr_accessor :velocity_x, :velocity_y, :velocity_z

  def initialize(drone)
    @drone = drone
    stablize
  end

  def set_velocity(direction, velocity)
    stablize
    instance_variable_set(:"@velocity_#{direction}", velocity)
  end

  def stablize
    @velocity_x = 0
    @velocity_y = 0
    @velocity_z = 0
  end
end
