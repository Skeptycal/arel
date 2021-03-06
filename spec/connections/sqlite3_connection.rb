require "activerecord"
puts "Using native SQLite3"

ActiveRecord::Base.logger = Logger.new("debug.log")

db_file = "spec/fixtures/fixture_database.sqlite3"

ActiveRecord::Base.configurations = {
  "unit" => {
    :adapter  => 'sqlite3',
    :database => db_file,
    :timeout  => 5000
  }
}

unless File.exist?(db_file)
  puts "SQLite3 database not found at #{db_file}. Rebuilding it."
  FileUtils.mkdir_p(File.dirname(db_file))
  sqlite_command = %Q{sqlite3 "#{db_file}" "create table a (a integer); drop table a;"}
  puts "Executing '#{sqlite_command}'"
  raise "Seems that there is no sqlite3 executable available" unless system(sqlite_command)
end

ActiveRecord::Base.establish_connection("unit")
