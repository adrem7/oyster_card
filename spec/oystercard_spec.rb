require 'oystercard'

describe Oystercard do
  let(:station_in) { double(:station) }
  let(:station_out) { double(:station) }

  it 'has a balance of 0 as default' do
    expect(subject.balance).to eq(0)
  end

  it 'should initialize with in_journey false' do
    expect(subject.in_journey?).to eq(false)
  end

  it 'should throw insufficient balance error where applicable' do
    expect { subject.touch_in(station_in) }.to raise_error 'Insufficient balance to travel'
  end

  describe 'Card has money on it' do
    before(:each) { subject.top_up(subject.limit) }

    it 'should error if try to top up balance above limit' do
      expect { subject.top_up(1) }.to raise_error "You cannot top up beyond the limit of £#{subject.limit}"
    end

    before(:each) { subject.touch_in(station_in) }

    it 'should charge people for their journey' do
      expect {subject.touch_out(station_out)}.to change{subject.balance}.by(-Oystercard::MINIMUM_FARE)
    end

    it 'should change in_journey to false when touch_out' do
      subject.touch_out(station_out)
      expect(subject).not_to be_in_journey
    end

    it 'should forget the entry station on touch_out' do
      subject.touch_out(station_out)
      expect(subject.journey_entry).to be_nil
    end

    it 'should store each journey as a hash in my history' do
      subject.touch_out(station_out)
      expect(subject.journey_history).to eq([{:entry => station_in, :exit => station_out}])
    end
  end
end
