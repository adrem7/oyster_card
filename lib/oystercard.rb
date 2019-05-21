require 'journey'

class Oystercard
  attr_reader :balance, :limit

  LIMIT = 90
  TOP_UP_ERROR = "You cannot top up beyond the limit of £#{LIMIT}".freeze
  INSUFFICIENT_BALANCE_ERROR = 'Insufficient balance to travel'.freeze

  def initialize(balance = 0, journey = Journey.new)
    @balance = balance
    @limit = LIMIT
    @journey = journey
  end

  def top_up(amount)
    raise TOP_UP_ERROR if @balance + amount > @limit
    @balance += amount
  end

  def touch_in(station)
    deduct(@journey.penalty_fare) if in_journey?
    raise INSUFFICIENT_BALANCE_ERROR if @balance < @journey.minimum_fare
    @journey.entry(station)
  end

  def touch_out(station)
    @journey.exit(station)
    deduct(@journey.fare)
  end

  def in_journey?
    !@journey.entry_station.nil?
  end

  def deduct(amount)
    @balance -= amount
  end
end
