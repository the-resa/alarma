module Alarma
  class Parser

    def initialize
      @start_year = 0
      @multi = 1            # Multiplikator
      @zone = "Europa"
      @months ||= []          # All months of a year
      @scenario = @x = @y = @start_time = @stop_time = 0
      
      read
    end

    private

    def read
      
      start_timer

      Dir.glob("db/alarm/*.*") do |file|

        debugger "Filename #{File.basename(file)} \n"
        @variable = File.extname(file)[1..-1]
        scenario = File.basename(file).split(".")[0]
        debugger "Szenario: #{scenario}"

        File.readlines(file).each do |line|
          if filter = line.match(/(Years=)\s*(\d+)/)
            @start_year = filter[2].to_i
            debugger "STARTYEAR #{@start_year}"
          end

          if filter = line.match(/(Multi=)\s*(\d+\.\d+)/)
            @multi = filter[2].to_f
            debugger "Multi: #{@multi}"
          end

          if filter = line.match(/Grid-ref=\s*(\d+),\s*(\d+)/)
            x = filter[1].to_i
            y = filter[2].to_i
            debugger "Coordinates #{x} / #{y}"
          end

          if line.match(/^(\s*\d+)/)
            @months = line.split(" ")
            current_month = 0

            debugger "Year #{@start_year}"
            @months.each do |month|
              current_month == 12 ? 1 : (current_month += 1)
              debugger "Monat #{current_month} Value: #{(month.to_f * @multi).round(1)}"
            end
            @start_year += 1
          end
        end
      end

      stop_timer
    end

    def debugger message
      puts "Debugger: #{message} \n"
    end

    def start_timer
      @start_time = Time.now
    end

    def stop_timer
      @stop_time = Time.now
      debugger "It takes #{@stop_time - @start_time} seconds"
    end
  end
end