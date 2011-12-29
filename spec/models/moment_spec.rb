require "spec_helper"

describe Moment do
  it "should have valid associations" do
    should have_many :values
    should have_and_belong_to_many :coordinates
  end
  
  it "should have the year and month values set" do
    should validate_presence_of :year
    should validate_presence_of :month
  end

  it "should create a new instance" do
    Moment.all.count.should == 0
    Moment.create!(:year => 123, :month => 456)
    Moment.all.count.should == 1
  end

  it "should not create a new instance with wrong params" do
    Moment.new(:year => 123, :month => "").should_not be_valid
  end

  it "should create a join between coordinates and moments" do
    coord = Coordinate.create!(:x => 9, :y => 9)
    coord.moments.count.should == 0
    coord.moments << Moment.create!(:year => 123, :month => 456)
    coord.moments.count.should == 1
  end

  it "should return clima values" do
    coord = Coordinate.create!(:x => 9, :y => 9)
    coord.moments << Moment.create(:year => 2003, :month => 12)
    coord.moments.first.values << Value.create(
      :zone => Value::ZONES[:europe],
      :scenario => Value::SCENARIOS[:bambu],
      :var => true,
      :result => 11.11)

    data = Moment.data(12, 2003)

    data[coord.x].should be_an(Array)
    
    data[coord.x].count.should == (coord.y + 1)
    data[coord.x][coord.y].should == 11.11

  end
end