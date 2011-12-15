require "spec_helper"

describe Value do
  it "should have valid associations" do
    should belong_to :moment
  end

  it "should have all values set" do
    should validate_numericality_of :zone
    should validate_numericality_of :scenario
    should validate_presence_of :result
    should allow_value(false).for(:var)
    should allow_value(true).for(:var)
  end

  it "should use correct constants for all zones" do
    Value::ZONES[:europe].should == 1
    Value::ZONES[:australia].should == 2
    Value::ZONES[:amerika].should == 3
  end

  it "should use correct constants for all scenarios" do
    Value::SCENARIOS[:bambu].should == 1
    Value::SCENARIOS[:gras].should == 2
    Value::SCENARIOS[:sedg].should == 3
  end

  it "should create a new instance of a value" do
    Value.all.count.should == 0
    Value.create!(:zone => Value::ZONES[:amerika], :scenario => Value::SCENARIOS[:sedg], :var => false, :result => 0.123)
    Value.all.count.should == 1
  end

  it "should not create a new instance with wrong params" do
    Value.new(:zone => -1, :scenario => -2, :var => true, :result => 0.123).should_not be_valid
  end
end