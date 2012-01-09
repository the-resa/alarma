require "rake"

describe "alarma rake tasks" do

  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    load "#{Rails.root}/lib/tasks/importer.rake"
    Rake::Task.define_task(:environment)
    
    Dir.glob("spec/fixtures/sql/*").each { |file| File.delete(file) }
  end

  it "should have 'environment' set" do
    @rake["alarma:parse"].prerequisites.should include("environment")
    @rake["alarma:import"].prerequisites.should include("environment")
    @rake["alarma:all"].prerequisites.should include("parse")
    @rake["alarma:all"].prerequisites.should include("dump")
  end

  describe "rake alarma:parse" do
    it "should create sql dumps during parsing" do
      Dir.entries("spec/fixtures/sql").count.should == 2 # 1 "." + 1 ".."

      @rake["alarma:parse"].invoke

      # 9 value-sqls + 1 coordinate-sql + 1 moment-sql + 1 setup-sql + 1 "." + 1 ".."
      Dir.entries("spec/fixtures/sql").count.should == 14
    end
  end

  describe "rake alarma:dump" do

    before(:all) do
      @rake["alarma:import"].invoke
    end

    it "should create the correct coordinates" do
      Coordinate.all.count.should == 2

      Coordinate.first.x.should == 4 # (4 / 109)
      Coordinate.first.y.should == 109

      Coordinate.last.x.should == 6 # (6 / 107)
      Coordinate.last.y.should == 107
    end

    it "should create the correct moments" do
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
      Setup.all.count.should == 9 # 1 zone * (3 scenarios * 3 variables)

      Setup.first.zone.should == Setup::ZONES[:europe]
      Setup.first.scenario.should == Setup::SCENARIOS[:bambu]
      Setup.first.variable.should == Setup::VARIABLES[:gdd]

      Setup.last.zone.should == Setup::ZONES[:europe]
      Setup.last.scenario.should == Setup::SCENARIOS[:sedg]
      Setup.last.variable.should == Setup::VARIABLES[:tmp]
    end

    it "should create the correct values" do
      Value.all.count.should == 864 # 9 scenarios * 2 coords * (4 years * 12 months)

      Value.first.result.should == 53.0 # (53 * 1.0)
      Value.last.result.should == 8.9 # (89 * 0.1)
    end

    it "should create the correct setup, coordinate and moment for a value" do
      value_1 = Value.first
      value_1.setup.zone == Setup::ZONES[:europe]
      value_1.setup.scenario == Setup::SCENARIOS[:bambu]
      value_1.setup.variable == Setup::VARIABLES[:gdd]

      value_1.coordinate.x.should == 4
      value_1.coordinate.y.should == 109

      value_1.moment.year.should == 2001
      value_1.moment.month.should == 1

      value_2 = Value.last
      value_2.setup.zone == Setup::ZONES[:europe]
      value_2.setup.scenario == Setup::SCENARIOS[:sedg]
      value_2.setup.variable == Setup::VARIABLES[:tmp]

      value_2.coordinate.x.should == 6
      value_2.coordinate.y.should == 107

      value_2.moment.year.should == 2004
      value_2.moment.month.should == 12
    end

    it "should get the correct values for a coordinate and moment" do
      Coordinate.first.values.count == 432 # (4 years * 12 months) * 9 scenarios
      Coordinate.last.values.count == 432

      Moment.first.values.count == 18 # (2 values * 9 scenarios)
      Moment.last.values.count == 18
    end
  end

end