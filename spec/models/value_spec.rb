require "spec_helper"

describe Value do
  it "should have valid associations" do
    should belong_to :coordinate
    should belong_to :moment
    should belong_to :setup
  end

  it "should have a result set" do
    should validate_presence_of :result
    should validate_numericality_of :result
  end

  it "should create a new instance of a value" do
    Value.all.count.should == 0
    Value.create!(:result => 0.123)
    Value.all.count.should == 1
  end

  it "should not create a new instance with wrong params" do
    Value.new(:result => "").should_not be_valid
  end
end