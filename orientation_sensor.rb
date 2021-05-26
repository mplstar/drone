class OrientationSensor
  attr_accessor :pitch, :roll

  def initialize(drone)
    @drone = drone
    stablize
  end

  def stablize
    @pitch = 0
    @roll = 0
  end
end
