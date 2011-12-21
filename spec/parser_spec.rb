require "spec_helper"
require_relative "../lib/tasks/parser.rb"

module Alarma 
  describe Parser do

    it "should raise an error, if data has already been imported" do
      Coordinate.stub!(:x => 123, :y => 123)
      lambda { initialize }.should raise_error if Coordinate.count != 0
    end

    it "should create the correct coordinates" do
      Coordinate.all.count.should == 0
      Parser.new
      Coordinate.all.count.should == 2

      Coordinate.first.x.should == 4 # (4 / 109)
      Coordinate.first.y.should == 109

      Coordinate.last.x.should == 6 # (6 / 107)
      Coordinate.last.y.should == 107
    end

     it "should create the correct moments" do
      Moment.all.count.should == 0
      Parser.new
      Moment.all.count.should == 48 # (4 years * 12 months)

      Moment.first.year.should == 2001
      Moment.first.month.should == 1
      Moment.first.values.first.result.should == 191 # (1910 * 0.1)
      Moment.first.values.last.result.should == 5.9 # (59 * 0.1)

      Moment.last.year.should == 2004
      Moment.last.month.should == 12
      Moment.last.values.first.result.should == 173.3 # (1733 * 0.1)
      Moment.last.values.last.result.should == 8.9 # (89 * 0.1)
    end

    it "should create the correct setups" do
      Setup.all.count.should == 0
      Parser.new
      Setup.all.count.should == 6 # 1 zone + (3 scenarios * 2 variables)

      Setup.first.zone.should == Setup::ZONES[:europe]
      Setup.first.scenario.should == Setup::SCENARIOS[:bambu]
      Setup.first.var.should == true # pre-format

      Setup.last.zone.should == Setup::ZONES[:europe]
      Setup.last.scenario.should == Setup::SCENARIOS[:sedg]
      Setup.last.var.should == false # tmp-format
    end

    it "should create the correct values" do
      Value.all.count.should == 0
      Parser.new
      Value.all.count.should == 513 # 1011

      Value.first.result.should == 191 # (1910 * 0.1)
      Value.last.result.should == 8.9 # (89 * 0.1)
    end

    it "should create the correct setup, coordinate and moment for a value" do
      Parser.new
      v = Value.first
      v.setup.zone.should == Setup::ZONES[:europe]
      v.setup.scenario.should == Setup::SCENARIOS[:bambu]
      v.setup.var.should == true

      v.coordinate.x.should == 4
      v.coordinate.y.should == 109

      v.moment.year.should == 2001
      v.moment.month.should == 1
    end

    it "should get the correct values for a coordinate and moment" do
      Parser.new
      Coordinate.first.values.count == 288 # (4 years * 12 months) * 6 scenarios
      Coordinate.last.values.count == 288

      Moment.first.values.count == 12 # (2 values * 6 scenarios)
      Moment.last.values.count == 12
    end
    
  end
end