require "spec_helper"
require_relative "../lib/tasks/parser.rb"

module Alarma
  describe Parser do

    before(:all) do
      @dir = "spec/fixtures/sql"
      Dir.glob("#{@dir}/*").each { |file| File.delete(file) }
    end
    
    it "should raise an error, if data has already been parsed" do
      @dir.stub!(:entries).and_return(["test.sql, test_2.sql"])
      lambda { initialize }.should raise_error if Dir.entries(@dir).size > 2
    end

    describe "parsing process and results" do   
      before(:each) do
        Parser.new
      end

      it "should create the correct sql-dumps" do
        # 9 value-sqls + 1 coordinate-sql + 1 moment-sql + 1 setup-sql + 1 "." + 1 ".."
        Dir.entries(@dir).count.should == 14

        Dir.entries(@dir).sort[2].should == "alarma_coordinates.sql"
        Dir.entries(@dir).sort[3].should == "alarma_moments.sql"
        Dir.entries(@dir).sort[4].should == "alarma_setups.sql"
        Dir.entries(@dir).sort[6].should == "alarma_values_bambu_pre.sql"
        Dir.entries(@dir).sort[9].should == "alarma_values_gras_pre.sql"
        Dir.entries(@dir).sort.last.should == "alarma_values_sedg_tmp.sql"
      end

      it "should parse the correct coordinates" do
        file = File.read("#{@dir}/alarma_coordinates.sql")
        file.should include("INSERT INTO `coordinates` (`id`, `x`, `y`) VALUES")
        file.should include("(1, 4, 109),")
        file.should include("(2, 6, 107);") # last sql-entry with ';' - 2 coords max
      end

      it "should parse the correct moments" do
        file = File.read("#{@dir}/alarma_moments.sql")
        file.should include("INSERT INTO `moments` (`id`, `year`, `month`) VALUES")
        file.should include("(1, 2001, 1),")
        file.should include("(20, 2002, 8),")
        file.should include("(48, 2004, 12);") # last sql-entry with ';' - 48 moments max
      end

      it "should parse the correct setups" do
        file = File.read("#{@dir}/alarma_setups.sql")
        file.should include("INSERT INTO `setups` (`id`, `zone`, `scenario`, `variable`) VALUES")
        file.should include("(1, 1, 1, 3),") # zone = europe, scenario = bambu, variable = gdd
        file.should include("(6, 1, 2, 2),") # zone = europe, scenario = gras, variable = tmp
        file.should include("(9, 1, 3, 2);") # last sql-entry with ';' - 9 setups max
      end

      it "should parse the correct values for scenario bambu and variable gdd" do
        file = File.read("#{@dir}/alarma_values_bambu_gdd.sql")
        file.should include("INSERT INTO `values` (`id`, `result`, `coordinate_id`, `moment_id`, `setup_id`) VALUES")
        file.should include("(10, 208.0, 1, 10, 1),") # 10th value => 1st coordinate, year 2001, month October
        file.should include("(68, 319.0, 2, 20, 1),") # 68th value => 2nd coordinate, year 2002, month August
        file.should include("(96, 121.0, 2, 48, 1);") # last sql-entry with ';' - 96 values max (starting at id 1 + 95 others)
      end

      it "should parse the correct values for scenario bambu and variable pre" do
        file = File.read("#{@dir}/alarma_values_bambu_pre.sql")
        file.should include("INSERT INTO `values` (`id`, `result`, `coordinate_id`, `moment_id`, `setup_id`) VALUES")
        file.should include("(97, 191.0, 1, 1, 2),") # 97th value => 1st coordinate, year 2001, month January
        file.should include("(186, 78.2, 2, 42, 2),") # 186th value => 2nd coordinate, year 2004, month June
        file.should include("(192, 172.5, 2, 48, 2);") # last sql-entry with ';' - 96 values max (starting at id 97 + 95 others)
      end

      it "should parse the correct values for scenario bambu and variable tmp" do
        file = File.read("#{@dir}/alarma_values_bambu_tmp.sql")
        file.should include("INSERT INTO `values` (`id`, `result`, `coordinate_id`, `moment_id`, `setup_id`) VALUES")
        file.should include("(193, 6.1, 1, 1, 3),") # 193rd value => 1st coordinate, year 2001, month January
        file.should include("(273, 14.0, 2, 33, 3),") # 273rd value => 2nd coordinate, year 2003, month September
        file.should include("(288, 8.8, 2, 48, 3);") # last sql-entry with ';' - 96 values max (starting at id 193 + 95 others)
      end

      it "should parse the correct values for scenario gras and variable gdd" do
        file = File.read("#{@dir}/alarma_values_gras_gdd.sql")
        file.should include("INSERT INTO `values` (`id`, `result`, `coordinate_id`, `moment_id`, `setup_id`) VALUES")
        file.should include("(289, 53.0, 1, 1, 4),") # 289th value => 1st coordinate, year 2001, month January
        file.should include("(376, 136.0, 2, 40, 4),") # 376th value => 2nd coordinate, year 2004, month April
        file.should include("(384, 121.0, 2, 48, 4);") # last sql-entry with ';' - 96 values max (starting at id 289 + 95 others)
      end

      it "should parse the correct values for scenario gras and variable pre" do
        file = File.read("#{@dir}/alarma_values_gras_pre.sql")
        file.should include("INSERT INTO `values` (`id`, `result`, `coordinate_id`, `moment_id`, `setup_id`) VALUES")
        file.should include("(385, 190.3, 1, 1, 5),") # 385th value => 1st coordinate, year 2001, month January
        file.should include("(446, 37.8, 2, 14, 5),") # 446th value => 2nd coordinate, year 2002, month February
        file.should include("(480, 172.5, 2, 48, 5);") # last sql-entry with ';' - 96 values max (starting at id 385 + 95 others)
      end

      it "should parse the correct values for scenario gras and variable tmp" do
        file = File.read("#{@dir}/alarma_values_gras_tmp.sql")
        file.should include("INSERT INTO `values` (`id`, `result`, `coordinate_id`, `moment_id`, `setup_id`) VALUES")
        file.should include("(481, 6.1, 1, 1, 6),") # 481st value => 1st coordinate, year 2001, month January
        file.should include("(564, 9.3, 2, 36, 6),") # 564th value => 2nd coordinate, year 2003, month December
        file.should include("(576, 8.8, 2, 48, 6);") # last sql-entry with ';' - 96 values max (starting at id 481 + 95 others)
      end

      it "should parse the correct values for scenario sedg and variable gdd" do
        file = File.read("#{@dir}/alarma_values_sedg_gdd.sql")
        file.should include("INSERT INTO `values` (`id`, `result`, `coordinate_id`, `moment_id`, `setup_id`) VALUES")
        file.should include("(577, 53.0, 1, 1, 7),") # 577th value => 1st coordinate, year 2001, month January
        file.should include("(623, 111.0, 1, 47, 7),") # 623rd value => 1st coordinate, year 2004, month November
        file.should include("(672, 124.0, 2, 48, 7);") # last sql-entry with ';' - 96 values max (starting at id 577 + 95 others)
      end

      it "should parse the correct values for scenario sedg and variable pre" do
        file = File.read("#{@dir}/alarma_values_sedg_pre.sql")
        file.should include("INSERT INTO `values` (`id`, `result`, `coordinate_id`, `moment_id`, `setup_id`) VALUES")
        file.should include("(673, 191.9, 1, 1, 8),") # 673rd value => 1st coordinate, year 2001, month January
        file.should include("(740, 82.0, 2, 20, 8),") # 740th value => 2nd coordinate, year 2002, month August
        file.should include("(768, 177.0, 2, 48, 8);") # last sql-entry with ';' - 96 values max (starting at id 673 + 95 others)
      end

      it "should parse the correct values for scenario sedg and variable tmp" do
        file = File.read("#{@dir}/alarma_values_sedg_tmp.sql")
        file.should include("INSERT INTO `values` (`id`, `result`, `coordinate_id`, `moment_id`, `setup_id`) VALUES")
        file.should include("(771, 6.3, 1, 3, 9),") # 771st value => 1st coordinate, year 2001, month March
        file.should include("(799, 14.6, 1, 31, 9),") # 799th value => 2nd coordinate, year 2003, month July
        file.should include("(864, 8.9, 2, 48, 9);") # last sql-entry with ';' - 96 values max (starting at id 769 + 95 others)
      end

      after(:each) do
        Dir.glob("#{@dir}/*").each { |file| File.delete(file) }
      end

    end
  end
end