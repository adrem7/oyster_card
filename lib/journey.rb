class Journey
  attr_reader :entry_station, :journey_history, :minimum_fare, :penalty_fare

  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  def initialize
    @minimum_fare = MINIMUM_FARE #Don't delete, needed in Ocard
    @penalty_fare = PENALTY_FARE
    @journey_history = []
    @entry_station = nil
    @exit_station = nil
  end

  def entry(station)
    create_journey if @entry_station != nil
    @entry_station = station
  end

  def exit(station)
    @penalty = @entry_station.nil?
    @exit_station = station
    create_journey
  end

  def create_journey
    @journey_history << {:entry => @entry_station, :exit => @exit_station}
    reset_stations
  end

  def reset_stations
    @entry_station = nil
    @exit_station = nil
  end

  def fare
    @penalty ? PENALTY_FARE : MINIMUM_FARE
  end
end
