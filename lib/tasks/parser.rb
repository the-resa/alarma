module Alarma
  class Parser
    require "active_record"

    def initialize
      @zone = Setup::ZONES[:europe]
      @multi = 0 # Multiplikator
      @scenario = @x = @y = @start_time = @stop_time = @current_line = 0
      @setup_id = @value_id = 1
      @months ||= []
      @coordinates ||= {}
      @moments ||= {}
      @setups ||= {}
      @values ||= {}
      @sql_dir = Rails.env.test? ? "spec/fixtures/sql" : "db/alarm/sql"
      raise "Error: Files have already been parsed and sql-dumps created!" if Dir.entries(@sql_dir).size > 2
      
      read
    end

    private

    def read
      dir = (Rails.env.development? || Rails.env.production?) ? "db/alarm/" : "spec/fixtures/"

      Dir.glob("#{dir}*.*").sort.each do |file|
        @coordinate_id = @moment_id = 1
        @scenario = File.basename(file).split(".")[0].downcase.to_sym
        @variable = File.extname(file)[1..-1].downcase.to_sym
        @setups[file] = {:id => @setup_id,
                    :zone => @zone,
                    :scenario => Setup::SCENARIOS[@scenario],
                    :variable => Setup::VARIABLES[@variable]}
        # debugger "Filename: #{File.basename(file)} \n"
        # debugger "Szenario: #{@scenario}"

        f = File.open(file,"r")
        total_lines= f.lines.count
        f.close

        File.readlines(file).each do |line|      
          @current_line += 1
          
          if filter = line.match(/(Years=)\s*(\d+)/)
            @start_year = filter[2].to_i
            # debugger "Startyear: #{@start_year}"
          end

          if filter = line.match(/(Multi=)\s*(\d+\.\d+)/)
            @multi = filter[2].to_f
            # debugger "Multi: #{@multi}"
          end

          if filter = line.match(/Grid-ref=\s*(\d+),\s*(\d+)/)
            @x = filter[1].to_i
            @y = filter[2].to_i
            @current_year = @start_year
                  
            @coordinates[@x] = {} unless @coordinates.keys.include?(@x)
            unless @coordinates[@x].values.include?(@y)
              @coordinates[@x][@coordinate_id] = @y
              @coordinate_id += 1
            end

            # debugger "Coordinates: #{@x} / #{@y}"
          end

          if line.match(/^(\s*\d+)/)
            @months = line.split(" ")
            current_month = 0

            @months.each do |month|
              current_month == 12 ? 1 : (current_month += 1)

              @moments[@current_year] = {} unless @moments.keys.include?(@current_year)
              unless @moments[@current_year].values.include?(current_month)
                @moments[@current_year][@moment_id] = current_month
                @moment_id += 1
              end

              value_coordinate_id = @coordinates[@x].key(@y)
              value_moment_id = @moments[@current_year].key(current_month)
              value_setup_id = @setups[file][:id]
              result = (month.to_f * @multi).round(1)

              @values[@value_id] = {
                :result => result,
                :m_id => value_moment_id,
                :s_id => value_setup_id,
                :c_id => value_coordinate_id}
              @value_id += 1

              # debugger "Year #{@current_year}"
              # debugger "Monat #{current_month} Value: #{(month.to_f * @multi).round(1)}"
            end
            @current_year += 1
          end

          if @current_line % 10000 == 0
            values_dump

            percent = (@current_line.to_f / total_lines.to_f*100.0).round(2)
            debugger "#{percent}% of #{File.basename(file)} done"
          end
        end

        values_dump if Rails.env.test?
        @setup_id += 1
      end

      coordinates_dump
      moments_dump
      setups_dump
    end

    def debugger message
      puts "Debugger: #{message} \n" unless Rails.env.test?
    end

    def coordinates_dump
      dump = File.open("#{@sql_dir}/alarma_coordinates.sql", "w")
      dump.puts "INSERT INTO `coordinates` (`id`, `x`, `y`) VALUES"

      tmp = 1
      coordinates_size = @coordinates.values.last.keys.last
      @coordinates.each do |k, v|
        v.each do |a, b|
          tmp == coordinates_size ?
            dump.puts("(#{a}, #{k}, #{b});") : dump.puts("(#{a}, #{k}, #{b}),")
          tmp += 1
        end
      end

      dump.close
    end

    def moments_dump
      dump = File.open("#{@sql_dir}/alarma_moments.sql", "w")
      dump.puts "INSERT INTO `moments` (`id`, `year`, `month`) VALUES"

      tmp = 1
      moments_size = @moments.values.last.keys.last
      @moments.each do |k, v|
        v.each do |a, b|
          tmp == moments_size ?
            dump.puts("(#{a}, #{k}, #{b});") : dump.puts("(#{a}, #{k}, #{b}),")
          tmp += 1
        end
      end

      dump.close
    end

    def setups_dump
      dump = File.open("#{@sql_dir}/alarma_setups.sql", "w")
      dump.puts "INSERT INTO `setups` (`id`, `zone`, `scenario`, `variable`) VALUES"

      tmp = 1
      setups_size = @setups.length
      @setups.each do |k, v|
        tmp == setups_size ?
          dump.puts("(#{v[:id]}, #{v[:zone]}, #{v[:scenario]}, #{v[:variable]});") :
          dump.puts("(#{v[:id]}, #{v[:zone]}, #{v[:scenario]}, #{v[:variable]}),")
        tmp += 1
      end

      dump.close
    end

    def values_dump
      dump = File.open("#{@sql_dir}/alarma_values_#{@scenario}_#{@variable}.sql", "a")
      dump.puts "INSERT INTO `values` (`id`, `result`, `coordinate_id`, `moment_id`, `setup_id`) VALUES"

      tmp = 1
      v_size = @values.length
      @values.each do |k, v|
        tmp == v_size ?
          dump.puts("(#{k}, #{v[:result]}, #{v[:c_id]}, #{v[:m_id]}, #{v[:s_id]});") :
          dump.puts("(#{k}, #{v[:result]}, #{v[:c_id]}, #{v[:m_id]}, #{v[:s_id]}),")
        tmp += 1
      end

      dump.close
      @values = {}
    end

  end
end