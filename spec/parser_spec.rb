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
      Moment.first.values.first.result == 53.0 # (53 * 1.0)
      Moment.first.values.last.result == 5.9 # (59 * 0.1)

      Moment.last.year.should == 2004
      Moment.last.month.should == 12
      Moment.last.values.first.result == 127.0 # (127 * 1.0)
      Moment.last.values.last.result == 8.9 # (89 * 0.1)
    end

    it "should create the correct setups" do
      Setup.all.count.should == 0
      Parser.new
      Setup.all.count.should == 9 # 1 zone + (3 scenarios * 3 variables)

      Setup.first.zone.should == Setup::ZONES[:europe]
      Setup.first.scenario.should == Setup::SCENARIOS[:bambu]
      Setup.first.variable.should == Setup::VARIABLES[:gdd]

      Setup.last.zone.should == Setup::ZONES[:europe]
      Setup.last.scenario.should == Setup::SCENARIOS[:sedg]
      Setup.last.variable.should == Setup::VARIABLES[:tmp]
    end

    it "should create the correct values" do
      Value.all.count.should == 0
      Parser.new
      Value.all.count.should == 595

      Value.first.result.should == 53.0 # (53 * 1.0)
      Value.last.result.should == 8.9 # (89 * 0.1)
    end

    it "should create the correct setup, coordinate and moment for a value" do
      Parser.new
      v_1 = Value.first
      v_1.setup.zone == Setup::ZONES[:europe]
      v_1.setup.scenario == Setup::SCENARIOS[:bambu]
      v_1.setup.variable == Setup::VARIABLES[:gdd]

      v_1.coordinate.x.should == 4
      v_1.coordinate.y.should == 109

      v_1.moment.year.should == 2001
      v_1.moment.month.should == 1

      v_2 = Value.last
      v_2.setup.zone == Setup::ZONES[:europe]
      v_2.setup.scenario == Setup::SCENARIOS[:sedg]
      v_2.setup.variable == Setup::VARIABLES[:tmp]

      v_2.coordinate.x.should == 6
      v_2.coordinate.y.should == 107

      v_2.moment.year.should == 2004
      v_2.moment.month.should == 12
    end

    it "should get the correct values for a coordinate and moment" do
      Parser.new
      Coordinate.first.values.count == 432 # (4 years * 12 months) * 9 scenarios
      Coordinate.last.values.count == 432

      Moment.first.values.count == 18 # (2 values * 9 scenarios)
      Moment.last.values.count == 18
    end
    
  end
end