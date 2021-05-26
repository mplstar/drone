class Engine
  attr_reader :power, :status

  def initialize(drone)
    @drone = drone
    self.power = 0
    @status = :off
  end

  def power_on
    @status = :on
  end

  def power_off
    self.power = 0
    @status = :off
  end

  def power=(x)
    raise "power out of range" if x < 0 || x > 100
    @power = x
  end

  def break
    power_off
    @drone.send(:distress)
  end
end
