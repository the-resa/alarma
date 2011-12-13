require Rails.root + "lib/tasks/parser.rb"

namespace :alarma do
  desc "Import Alarm Data"

  task :import => :environment do
    Alarma::Parser.new
  end
end