
require 'station'

describe Station do

  let(:station) {Station.new("Barbican", 1)}

  it 'can have a zone' do
  expect(station.zone).to eq 1
  end

  it 'can have a name' do
  expect(station.name).to eq "Barbican"
  end
end