require "spec_helper"

describe Coordinate do
  it "should have valid associations" do
    should have_many :values
  end

  it "should have the x and y values set" do
    Coordinate.new(:x => 123, :y => "").should_not be_valid
    should validate_presence_of :x
    should validate_presence_of :y
    should validate_numericality_of :x
    should validate_numericality_of :y
  end

  it "should create a new instance of a coordinate" do
    coordinates = Coordinate.all.count
    Coordinate.create!(:x => 123, :y => 456)
    Coordinate.all.count.should == coordinates + 1
  end

  it "should not create a new instance with wrong params" do
    Coordinate.new(:x => "abc", :y => "").should_not be_valid
  end

  it "should create a join between coordinates and moments called value" do
    c = Coordinate.create!(:x => 123, :y => 456)
    c.values.count.should == 0
    c.values << Value.create!(:result => 111.1)
    c.values << Value.create!(:result => 222.2)
    c.values.count.should == 2
  end
end
