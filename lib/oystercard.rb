class Oystercard
  attr_reader :balance, :limit, :journey_entry,  :journey_history

  LIMIT = 90
  MINIMUM_FARE = 1
  TOP_UP_ERROR = "You cannot top up beyond the limit of £#{LIMIT}".freeze
  INSUFFICIENT_BALANCE_ERROR = 'Insufficient balance to travel'.freeze

  def initialize(balance = 0)
    @balance = balance
    @limit = LIMIT
    @journey_history = []
  end

  def top_up(amount)
    raise TOP_UP_ERROR if @balance + amount > @limit

    @balance += amount
  end

  def touch_in(station)
    raise INSUFFICIENT_BALANCE_ERROR if @balance < MINIMUM_FARE

    @journey_entry = station
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @journey_history << {:entry => @journey_entry, :exit => station}
    @journey_entry = nil
  end

  def in_journey?
    !@journey_entry.nil?
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
