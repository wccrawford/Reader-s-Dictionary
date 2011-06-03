#!/usr/bin/env ruby
require 'sqlite3'
require 'optparse'

options = {}

optparse = OptionParser.new do |opts|
	opts.banner = "Usage: create_db.rb [options]"

	options[:input] = 'dictionary/edict'
	opts.on( '-i', '--input FILE', 'Input file' ) do |file|
		options[:input] = file
	end

	options[:output] = 'dictionary/dictionary.db'
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

db.execute("DROP TABLE IF EXISTS dictionary;")

db.execute("CREATE VIRTUAL TABLE dictionary USING FTS3(
	word TEXT,
	pronunciation TEXT,
	translation TEXT
	);")
	#id INTEGER PRIMARY KEY AUTOINCREMENT,

#db.execute("CREATE INDEX idx_word ON dictionary(word COLLATE NOCASE);");
#db.execute("CREATE INDEX idx_pronunciation ON dictionary(pronunciation COLLATE NOCASE);");
#db.execute("CREATE INDEX idx_translation ON dictionary(translation COLLATE NOCASE);");

line = input.gets

regex = Regexp.new '^(?<word>[^ ]+)( ?\[(?<pronunciation>[^\]]+)\])?( ?/(?<translation>.+)/)?$'
wordsProcessed = 0
while line = input.gets
	wordsProcessed += 1
	matches = regex.match(line)
	db.execute("INSERT INTO dictionary (word, pronunciation, translation) VALUES (?,?,?);",
		[matches[:word], matches[:pronunciation], matches[:translation]])
	puts wordsProcessed if wordsProcessed % 1000 == 0
end
puts wordsProcessed

input.close

