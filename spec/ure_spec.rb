require 'spec_helper'

describe Ure do
  before (:each) do
    @car = Ure::Struct.new(fields: { paint: "blue", deluxe: false } )
  end

  it 'has a version number' do
    expect(Ure::VERSION).not_to be nil
  end

  it 'sets readers for field keys' do
    expect(@car.paint).to eq("blue")
    expect(@car.deluxe).to eq(false)
  end

  it 'raises an error when field keys are existing methods' do
    expect{ Ure::Struct.new(fields: { select: "something" } ) }
      .to raise_error(/is already an existing method!/)
  end

  it 'is immutable' do
    expect(@car.frozen?).to eq(true)
    expect { @car.instance_variable_set(:@paint, "red") }.to raise_error(RuntimeError)
  end

  it 'has an each method' do
    values = []
    @car.each { |value| values << value}
    expect(values).to eq(["blue", false])
  end

  it 'has an each_pair method' do
    pairs = {}
    @car.each_pair { |key, value| pairs[key] = value }
    expect(pairs).to eq({:paint => "blue", :deluxe => false })
  end

  it 'returns to_s' do
    expect(@car.to_s).to eq("{:paint=>\"blue\", :deluxe=>false}")
  end

  it 'has an inspect method' do
    expect(@car.inspect).to eq("{:paint=>\"blue\", :deluxe=>false}")
  end

  it 'has a length method' do
    expect(@car.length).to eq(2)
  end

  it 'has a members method' do
    expect(@car.members).to eq([:paint, :deluxe])
  end

  it 'has a select method' do
    expect(@car.select { |v| v =~ /[b]/ }).to eq(["blue"])
  end

  it 'has a size method' do
    expect(@car.size).to eq(2)
  end

  it 'has a to_a method' do
    expect(@car.to_a).to eq(["blue", false])
  end

  it 'has a to_h method' do
    expect(@car.to_h).to eq({:paint => "blue", :deluxe => false })
  end

  it 'has a values method' do
    expect(@car.values).to eq(["blue", false])
  end

  it 'has a values_at method' do
    expect(@car.values_at(0, 2)).to eq(["blue", nil])
  end
end
