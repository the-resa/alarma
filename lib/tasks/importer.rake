require Rails.root + "lib/tasks/parser.rb"

namespace :alarma do
  desc "Parse Alarm data and create sql-dumps"
  task :parse => :environment do
    start_timer

    Alarma::Parser.new

    puts "Successfully parsed all Alarma data and created sql files!"
    stop_timer "Parsing ............................."
  end

  desc "Import Alarm data to MySQL db"
  task :import => :environment do
    db_config = ActiveRecord::Base.configurations["#{Rails.env}"]
    dir = Rails.env.test? ? "spec/fixtures/sql/" : "db/alarm/sql/"

    if Dir.entries(dir).size <= 2
      puts "No sql files found. Please use 'rake alarma:parse' to generate them!"

    elsif Coordinate.count == 0 && Dir.entries(dir).size > 2
      start_timer

      Dir.glob("#{dir}*.sql").sort.each do |file|
        puts "Dumping #{File.basename(file)} to #{db_config['database']} ..."
        system "mysql --user=#{db_config['username']} --password=#{db_config['password']} \
                #{db_config['database']} < #{Rails.root}/#{file}"
      end

      puts "Successfully dumped all sql files to database!"
      stop_timer "Importing SQL........................"
      
    else
      puts "Database is already fully loaded!"
    end
  end

  desc "Parse Alarm data and directly dump them to MySQL database"
  task :all => [:parse, :dump]
end

def start_timer
  @start_time = Time.now
end

def stop_timer message
  @stop_time = Time.now
  puts "#{message} takes #{@stop_time - @start_time} seconds"
end