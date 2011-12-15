require "spec_helper"

describe Coordinate do
  it "should have valid associations" do
    should have_and_belong_to_many :moments
    Coordinate.new(:x => 123, :y => "").should_not be_valid
  end

  it "should have the x and y values set" do
    should validate_presence_of :x
    should validate_presence_of :y
    should validate_numericality_of :x
    should validate_numericality_of :y
  end

  it "should create a new instance of a coordinate" do
    Coordinate.all.count.should == 0
    Coordinate.create!(:x => 123, :y => 456)
    Coordinate.all.count.should == 1
  end

  it "should not create a new instance with wrong params" do
    Coordinate.new(:x => "abc", :y => "").should_not be_valid
  end

  it "should create a join between coordinates and moments" do
    m = Moment.create!(:year => 123, :month => 456)
    m.coordinates.count.should == 0
    m.coordinates << Coordinate.create!(:x => 8, :y => 8)
    m.coordinates << Coordinate.create!(:x => 123, :y => 123)
    m.coordinates.count.should == 2
  end
end
