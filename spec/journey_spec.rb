require 'journey'
require 'oystercard'

describe Journey do
  it 'should forget the entry station on touch_out' do
    subject.entry(nil)
    expect(subject.entry_station).to be_nil
  end

  it 'should store each journey as a hash in my history' do
    subject.entry("Barbican")
    subject.exit("Liverpool St")
    expect(subject.journey_history).to eq([{:entry => "Barbican", :exit => "Liverpool St"}])
  end

  it 'should charge the minimum fare' do
    subject.entry("Barbican")
    subject.exit("Liverpool St")
    expect(subject.fare).to eq(Journey::MINIMUM_FARE)
  end

  it 'should be able to create a journey without a touch_out' do
    subject.entry("Barbican")
    subject.entry("Liverpool St")
    expect(subject.journey_history).to eq([{:entry => "Barbican", :exit => nil}])
  end
end
