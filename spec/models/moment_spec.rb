require "spec_helper"

describe Moment do
  it "should have valid associations" do
    should have_many :values
  end
  
  it "should have the year and month values set" do
    should validate_presence_of :year
    should validate_presence_of :month
    should validate_numericality_of :year
    should validate_numericality_of :month
  end

  it "should create a new instance" do
    moments = Moment.all.count
    Moment.create!(:year => 123, :month => 456)
    Moment.all.count.should == moments + 1
  end

  it "should not create a new instance with wrong params" do
    Moment.new(:year => 123, :month => "").should_not be_valid
  end

  it "should create a join between coordinates and moments called value" do
    m = Moment.create!(:year => 2002, :month => 3)
    m.values.count.should == 0
    m.values << Value.create!(:result => 111.1)
    m.values << Value.create!(:result => 222.2)
    m.values.count.should == 2
  end
end