module Alarma
  class Parser
    require 'active_record'

    def initialize
      @zone = Setup::ZONES[:europe]
      @multi = 0 # Multiplikator
      @months ||= [] 
      @scenario = @x = @y = @start_time = @stop_time = 0
      raise "Error: Files have already been imported and database is fully loaded!" if Coordinate.count != 0

      read
    end

    private

    def read
      start_timer

      dir = (Rails.env.development? || Rails.env.production?) ? "db/alarm/" : "spec/fixtures/"

      Dir.glob("#{dir}*.*").sort.each do |file|
        
        @scenario = File.basename(file).split(".")[0].downcase.to_sym
        @variable = File.extname(file)[1..-1].downcase.to_sym
        @setup = Setup.find_or_create_by_zone_and_scenario_and_variable(
                :zone => @zone,
                :scenario => Setup::SCENARIOS[@scenario],
                :variable => Setup::VARIABLES[@variable])
        debugger "Filename: #{File.basename(file)} \n"
        debugger "Szenario: #{@scenario}"

        File.readlines(file).each do |line|

          if filter = line.match(/(Years=)\s*(\d+)/)
            @start_year = filter[2].to_i
            debugger "Startyear: #{@start_year}"
          end

          if filter = line.match(/(Multi=)\s*(\d+\.\d+)/)
            @multi = filter[2].to_f
            debugger "Multi: #{@multi}"
          end

          if filter = line.match(/Grid-ref=\s*(\d+),\s*(\d+)/)
            @x = filter[1].to_i
            @y = filter[2].to_i
            @current_year = @start_year
            @coordinate = Coordinate.find_or_create_by_x_and_y(:x => @x, :y => @y)
            debugger "Coordinates: #{@x} / #{@y}"
          end

          if line.match(/^(\s*\d+)/)
            @months = line.split(" ")
            current_month = 0

            @months.each do |month|
              current_month == 12 ? 1 : (current_month += 1)

              moment = Moment.find_or_create_by_year_and_month(
                :year => @current_year,
                :month => current_month)
              
              value = Value.find_or_create_by_result(
                :result => (month.to_f * @multi).round(1))

              moment.values << value
              @coordinate.values << value
              @setup.values << value

              debugger "Year #{@current_year}"
              debugger "Monat #{current_month} Value: #{(month.to_f * @multi).round(1)}"
            end
            @current_year += 1
          end
        end
      end

      stop_timer
    end

    def debugger message
      puts "Debugger: #{message} \n" unless Rails.env.test?
    end

    def start_timer
      @start_time = Time.now
    end

    def stop_timer
      @stop_time = Time.now
      puts "It takes #{@stop_time - @start_time} seconds"
    end
  end
end