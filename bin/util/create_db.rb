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

db.execute("DROP TABLE dictionary;")

db.execute("CREATE TABLE IF NOT EXISTS dictionary(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	word TEXT NOT NULL,
	pronunciation TEXT,
	translation TEXT NOT NULL
	);")

line = input.gets

regex = Regexp.new '^(?<word>[^ ]+)( ?\[(?<pronunciation>[^\]]+)\])?( ?/(?<translation>.+)/)?$'
while line = input.gets
	puts line
	matches = regex.match(line)
#	puts matches
#	puts matches[:word]
#	puts matches[:pronunciation]
#	puts matches[:translation]
	db.execute("INSERT INTO dictionary (word, pronunciation, translation) VALUES (?,?,?);",
		[matches[:word], matches[:pronunciation], matches[:translation]])
end

input.close

