require 'csv'
require_relative './helper'
require 'fileutils'
require 'pry'

DATE_FORMAT = '%Y-%m-%d'.freeze

class Main
  def initialize(input_file_path, output_file_path)
    @input_file_path = input_file_path
    @output_file_path = output_file_path
  end

  def call
    print_memory_usage do
      print_time_spent do
        puts '===================================================='
        puts 'initialize_tempts_folder'
        initialize_tempts_folder
      end
    end

    print_memory_usage do
      print_time_spent do
        puts '===================================================='
        puts 'split_csv_to_each_number'
        split_csv_to_each_number
      end
    end

    print_memory_usage do
      print_time_spent do
        puts '===================================================='
        puts 'write_real_activation_date'
        write_real_activation_date
      end
    end

    print_memory_usage do
      print_time_spent do
        puts '===================================================='
        puts 'generate_output'
        generate_output
      end
    end
  end

  private

  def initialize_tempts_folder
    FileUtils.remove_dir('tempts') if File.directory?('tempts')
    Dir.mkdir 'tempts'
  end

  def split_csv_to_each_number
    CSV.foreach(@input_file_path, headers: true) do |row|
      File.open("tempts/#{row['PHONE_NUMBER']}.csv", 'a') do |file|
        file.puts [row['ACTIVATION_DATE'], row['DEACTIVATION_DATE']].join(',')
      end
    end
  end

  def write_real_activation_date
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

      File.open(file_path, 'w') do |file|
        file.puts "#{phone_number},#{real_activation_date}"
      end
    end
  end

  def generate_output
    headers = 'PHONE_NUMBER,REAL_ACTIVATION_DATE'
    File.open(@output_file_path, 'w') do |file|
      file.puts headers

      Dir['tempts/*.csv'].each do |file_path|
        file.puts File.read(file_path)
        File.delete(file_path)
      end
    end
  end
end
