require "spec_helper"

describe Value do
  it "should have valid associations" do
    should belong_to :moment
  end

  it "should have all values set" do
    should validate_presence_of :zone
    should validate_presence_of :scenario
    should validate_presence_of :var
    should validate_presence_of :result
  end

  it "should use correct constants for all zones" do
    Value::ZONES[:europe].should == 0
    Value::ZONES[:australia].should == 1
    Value::ZONES[:amerika].should == 2
  end

  it "should use correct constants for all scenarios" do
    Value::SCENARIOS[:bambu].should == 0
    Value::SCENARIOS[:gras].should == 1
    Value::SCENARIOS[:sedg].should == 2
  end
end