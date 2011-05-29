require 'sqlite3'
require 'optparse'

options = {}

optparse = OptionParser.new do |opts|
	opts.banner = "Usage: create_db.rb [options]"

	options[:input] = 'dictionary.txt'
	opts.on( '-i', '--input FILE', 'Input file' ) do |file|
		options[:input] = file
	end

	options[:output] = 'dictionary.db'
	opts.on( '-o', '--output FILE', 'Output file' ) do |file|
		options[:output] = file
	end

	opts.on( '-h', '--help', 'Display this screen' ) do
		puts opts
		exit
	end
end

optparse.parse!

input = File.new( options[:input], 'r' )
db = SQLite3::Database.new( options[:output] )

line = input.gets

while line = input.gets
	puts line
end

db.execute("CREATE TABLE IF NOT EXISTS dictionary(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	word TEXT NOT NULL,
	pronunciation TEXT NOT NULL,
	translation TEXT NOT NULL
	);")

