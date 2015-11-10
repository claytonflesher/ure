require 'spec_helper'

describe Ure do
  Car    = Ure.new(:paint, :deluxe)
  before (:each) do
    @van   = Car.new(paint: :mural, deluxe: false)
  end

  it 'has a version number' do
    expect(Ure::VERSION).not_to be nil
  end

  it "has an ==() method" do
    sedan = Car.new(paint: "red", deluxe: true)
    van2  = Car.new(paint: :mural, deluxe: false)
    expect(@van == van2).to eq(true)
    expect(@van == sedan).to eq(false)
    expect(@van == {}).to eq(false)
  end

  it "creates methods from the hash" do
    expect(@van.paint).to    eq(:mural)
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
    expect(@van.to_s).to eq("#<ure {:paint=>:mural, :deluxe=>false}")
  end

  it "has an inspect method" do
    expect(@van.inspect).to eq("#<ure {:paint=>:mural, :deluxe=>false}")
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
end
