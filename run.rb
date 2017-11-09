require_relative './src/main'

puts "Input file path - Absolute path"
input_file_path = gets.chomp

puts "Output file path - Absolute path"
output_file_path = gets.chomp

begin
  Main.new(input_file_path, output_file_path).call
rescue => e
  puts e
end