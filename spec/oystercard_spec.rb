require 'oystercard'

describe Oystercard do
  let(:station_in)  { double(:station) }
  let(:station_out) { double(:station) }
  let(:journey)     { double(:journey, :minimum_fare => 1, :penalty_fare => 6) }

  it 'has a balance of 0 as default' do
    expect(subject.balance).to eq(0)
  end

  it 'should initialize with in_journey false' do
    subject.top_up(subject.limit)
    subject.touch_in(station_in)
    expect(subject.in_journey?).to eq(true)
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
      expect {subject.touch_out(station_out)}.to change{subject.balance}.by(-journey.minimum_fare)
    end

    it 'should change in_journey to false when touch_out' do
      subject.touch_out(station_out)
      expect(subject).not_to be_in_journey
    end
  end

  it 'should charge a penalty if there is no touch_out' do
    subject.top_up(subject.limit)
    subject.touch_in("Bob")
    subject.touch_in("Suzy")
    expect(subject.balance).to eq(subject.limit - journey.penalty_fare)
  end

  it 'should charge a penalty if there is no touch_in' do
    subject.top_up(subject.limit)
    subject.touch_out("Bob")
    expect(subject.balance).to eq(subject.limit - journey.penalty_fare)
  end
end
