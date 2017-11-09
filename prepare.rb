require 'csv'

headers = %w[PHONE_NUMBER ACTIVATION_DATE DEACTIVATION_DATE]

PHONE_NUMBER = '0987000001'
ACTIVATION_DATE = '2016-03-01'.freeze
DEACTIVATION_DATE = '2017-03-01'.freeze

CSV.open('1M_SAME_NUMBER.csv', 'w', write_headers: true, headers: headers) do |csv|
  1_000_000.times do |_|
    csv << [PHONE_NUMBER, ACTIVATION_DATE, DEACTIVATION_DATE]
  end
end

CSV.open('1M_DIFF_NUMBER.csv', 'w', write_headers: true, headers: headers) do |csv|
  ('0987000001'..'0988000001').each do |phone_number|
    csv << [phone_number, ACTIVATION_DATE, DEACTIVATION_DATE]
  end
end