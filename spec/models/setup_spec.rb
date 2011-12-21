require 'spec_helper'

describe Setup do

  it "should have valid associations" do
    should have_many :values
  end
  
  it "should have all values set" do
    should validate_numericality_of :zone
    should validate_numericality_of :scenario
    should allow_value(false).for(:var)
    should allow_value(true).for(:var)
  end

  it "should use correct constants for all zones" do
    Setup::ZONES[:europe].should == 1
    Setup::ZONES[:australia].should == 2
    Setup::ZONES[:amerika].should == 3
  end

  it "should use correct constants for all scenarios" do
    Setup::SCENARIOS[:bambu].should == 1
    Setup::SCENARIOS[:gras].should == 2
    Setup::SCENARIOS[:sedg].should == 3
  end

  it "should create a new instance of a setup" do
    Setup.all.count.should == 0
    Setup.create!(:zone => Setup::ZONES[:amerika], :scenario => Setup::SCENARIOS[:sedg], :var => false)
    Setup.all.count.should == 1
  end
end
