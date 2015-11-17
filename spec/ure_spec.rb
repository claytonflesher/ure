require 'spec_helper'

describe Ure do
  Car = Ure.new(:paint, :deluxe)

  it "doesn't care about the order of arguments" do
    van = Car.new(deluxe: false, paint: :mural)

    expect(van.paint).to be(:mural)
  end

  it "has a frozen members class method" do
    expect(Car.members).to eq([:paint, :deluxe])
    expect(Car.members.frozen?).to be_truthy
  end


  before (:each) do
    @van   = Car.new(paint: :mural, deluxe: false)
  end

  it 'has a version number' do
    expect(Ure::VERSION).not_to be nil
  end

  #Instance method tests

  it "has frozen members" do
    expect(@van.members.frozen?).to be_truthy
  end

  it "has frozen fields" do
    expect(@van.fields.frozen?).to be_truthy
  end
  it "has an ==() method" do
    van2  = Car.new(paint: :mural, deluxe: false)
    expect(@van).to eq(van2)

    sedan = Car.new(paint: "red", deluxe: true)
    expect(@van).not_to eq(sedan)

    expect(@van).not_to eq({})

    house = Ure.new(:paint, :deluxe)
    expect(@van).not_to eq(house.new(paint: @van.paint, deluxe: @van.deluxe))

    expect(@van).not_to eq(BasicObject.new)
  end

  it "creates methods from the hash" do
    expect(@van.paint).to eq(:mural)
  end

  it "is immutable" do
    expect { @van.instance_variable_set(:paint, "red") }.to raise_error(NameError)
  end

  it "has a [] method" do
    expect(@van[:paint]).to eq(:mural)
  end

  it "has an each method" do
    pairs = {}
    @van.each { |key, value| pairs[key] = value }
    expect(pairs).to eq({:paint => :mural, :deluxe => false})
  end

  it "has a to_s method" do
    expect(@van.to_s).to eq("#<Ure Car {:paint=>:mural, :deluxe=>false}")
  end

  it "has an inspect method" do
    expect(@van.inspect).to eq("#<Ure Car {:paint=>:mural, :deluxe=>false}")
  end

  it "has a to_a method" do
    expect(@van.to_a).to eq([:mural, false])
  end

  it "has a to_h method" do
    expect(@van.to_h).to eq({:paint => :mural, :deluxe => false})
  end

  it "has a values method" do
    expect(@van.values).to eq([:mural, false])
  end

  it "has a values_at method" do
    expect(@van.values_at(:deluxe)).to eq([false])
    expect(@van.values_at(:deluxe, :paint)).to eq([false, :mural])
  end

  it "has a class method" do
    expect(@van.class).to eq(Car)
  end

  it "has a to_json method" do
    expect(@van.to_json).to eq("{\"paint\":\"mural\",\"deluxe\":false}")
  end
end
