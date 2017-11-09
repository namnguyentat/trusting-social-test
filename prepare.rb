require 'csv'
require_relative './helpers'

headers = %w[PHONE_NUMBER ACTIVATION_DATE DEACTIVATION_DATE]

ACTIVATION_DATE = '2016-03-01'.freeze
DEACTIVATION_DATE = '2017-03-01'.freeze

print_memory_usage do
  print_time_spent do
    CSV.open('input.csv', 'w', write_headers: true, headers: headers) do |csv|
      ('0987000001'..'0988000001').each do |phone_number|
        csv << [phone_number, ACTIVATION_DATE, DEACTIVATION_DATE]
      end
    end
  end
end
