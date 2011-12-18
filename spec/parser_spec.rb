require "spec_helper"
require_relative "../lib/tasks/parser.rb"

module Alarma 
  describe Parser do

    it "should raise an error, if data has already been imported" do
      Coordinate.stub!(:x => 123, :y => 123)
      lambda { initialize }.should raise_error if Coordinate.count != 0
    end

    it "should get the correct zone, scenario, variable and result" do
      Value.all.count.should == 0
      Parser.new
      Value.all.count.should == 1011 

      Value.first.zone.should == Value::ZONES[:europe]
      Value.first.scenario.should == Value::SCENARIOS[:bambu]
      Value.first.var.should == true # pre-format
      Value.first.result.should == 191 # (1910 * 0.1)

      Value.last.zone.should == Value::ZONES[:europe]
      Value.last.scenario.should == Value::SCENARIOS[:sedg]
      Value.last.var.should == false # tmp-format
      Value.last.result.should == 8.9 # (89 * 0.1)
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

    it "should get the correct moments for a coordinate" do
      Parser.new
      Coordinate.first.moments.count == 288 # (4 years * 12 months) * 6 scenarios
      Coordinate.last.moments.count == 288
    end

    it "should get the correct year and month for a coordinate" do
     Parser.new
     Coordinate.first.moments.first.year.should == 2001
     Coordinate.first.moments.first.month.should == 1 # January
     
     Coordinate.last.moments.last.year.should == 2004
     Coordinate.last.moments.last.month.should == 12 # December
    end

    it "should create the correct moments" do
      Moment.all.count.should == 0
      Parser.new
      Moment.all.count.should == 48 # (4 years * 12 months)

      Moment.first.year.should == 2001
      Moment.first.month.should == 1
      Moment.first.coordinates.uniq.count.should == 2
      
      Moment.last.year.should == 2004
      Moment.last.month.should == 12
      Moment.last.coordinates.uniq.count.should == 2
    end

  end
end