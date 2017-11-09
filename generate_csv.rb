require 'csv'
require_relative './helpers'
require 'fileutils'

DATE_FORMAT = '%Y-%m-%d'.freeze

def split_csv_to_each_number
  FileUtils.remove_dir('tempts') if File.directory?('tempts')
  Dir.mkdir 'tempts'

  CSV.foreach('input.csv', headers: true) do |row|
    File.open("tempts/#{row['PHONE_NUMBER']}.csv", 'a') do |file|
      file.puts [row['ACTIVATION_DATE'], row['DEACTIVATION_DATE']].join(',')
    end
  end
end

def generate_output
  headers = %w[PHONE_NUMBER REAL_ACTIVATION_DATE]

  CSV.open('output.csv', 'w', write_headers: true, headers: headers) do |csv|
    Dir['tempts/*.csv'].each do |file_path|
      # get phone number through file path
      phone_number = File.basename(file_path, '.csv')

      # get all activation_date and deactivation_date of phone number
      # and sort by activation_date asending order
      sorted_dates = CSV.parse(File.read(file_path)).sort_by do |range|
        Date.strptime(range[0], DATE_FORMAT)
      end

      # Initializer real_activation_date with first activation_date
      real_activation_date = sorted_dates[0][0]

      # Iterate through all dates
      # If there is a gap between 2 range
      # current_deactivation_date does not equal next_activation_date
      # assign real_activation_date to next activation_date
      (0..(sorted_dates.length - 2)).each do |index|
        current_deactivation_date = sorted_dates[index][1]

        next if current_deactivation_date.nil?

        next_activation_date = sorted_dates[index + 1][0]

        if current_deactivation_date != next_activation_date
          real_activation_date = sorted_dates[index + 1][0]
        end
      end

      # Write ouput
      csv << [phone_number, real_activation_date]
    end
  end
end

print_memory_usage do
  print_time_spent do
    puts '===================================================='
    puts 'split input file'
    split_csv_to_each_number
  end
end

print_memory_usage do
  print_time_spent do
    puts '===================================================='
    puts 'generate output file'
    generate_output
  end
end

print_memory_usage do
  print_time_spent do
    puts '===================================================='
    puts 'remove tempts files'
    FileUtils.remove_dir('tempts') if File.directory?('tempts')
  end
end
