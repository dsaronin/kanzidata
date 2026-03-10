#!/usr/bin/env ruby
# sheet_to_json.rb
# Converts CSV/Sheet data to a JSON format for flashcards grouped by topic.
# Outputs fc_data as an array of arrays [front, back].

require 'csv'
require 'json'

# Usage: ruby sheet_to_json.rb sentences.csv sentences.json
input_file = ARGV[0]
output_file = ARGV[1]

if input_file.nil? || output_file.nil?
  puts "Usage: ruby sheet_to_json.rb <input_csv> <output_filename>"
  exit
end

output_map = {}
current_topic = nil

# Using headers: true to skip the first row and access columns by name
CSV.foreach(input_file, headers: true) do |row|
  topic_name = row['TOPIC']&.strip
  next if topic_name.nil? || topic_name.empty?

  # Check for a new topic block
  if topic_name != current_topic
    current_topic = topic_name
    output_map[current_topic] = { "fc_data" => [] }
  end

  # Append the flashcard pair as a list [front, back]
  # This removes the "front" and "back" keys and uses square brackets
  output_map[current_topic]["fc_data"] << [
    row['Türkçe']&.strip,
    row['English']&.strip
  ]
end

# Write the minimized JSON to the file
File.open(output_file, "w") do |f|
  f.write(JSON.pretty_generate(output_map))
end

puts "Processing complete."
puts "Source: #{input_file}"
puts "Output: #{output_file} (#{output_map.keys.size} topics processed)"
