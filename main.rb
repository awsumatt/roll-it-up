# frozen_string_literal: true

require 'io/console'
require 'json'
require_relative 'configurator'
require_relative 'row-getter'
require_relative 'store'
require_relative 'writer'

begin
  config_file = File.read('./config.json')
  config = JSON.parse(config_file)
rescue IOError => e
  puts "No configuration found. Running configurator...\n\n"
  configurator = Configurator.new
  configurator.configure
  config_file = File.read('./config.json')
  config = JSON.parse(config_file)
end

json_stores = config['stores']
stores = {}

MAX_PROGRESS = json_stores.length * 5 * 3
curr_progress = 0

def progress_bar(progress)
  $stdout.erase_line(1)
  progress_percent = (progress.to_f / MAX_PROGRESS) * 100
  bar_complete = '#' * progress
  bar_incomplete = '-' * (MAX_PROGRESS - progress)
  bar = "[#{bar_complete}#{bar_incomplete}]"

  print "\r#{bar} #{progress_percent.round(2)}%/100%"
end


json_stores.each do |store|
  curr_progress += 5
  stores[store['store_num']] = Store.new(
    store['store_num'],
    config['management_summary_v'],
    store['mgmt_v_page'] - 1,
    config['aged_receivable']
  )
  progress_bar(curr_progress)
end

get_rows = RowGetter.new(stores, config['aged_receivable'], config['roll_up'])

ar_rows = get_rows.find_ar_rows
rollup_rows = get_rows.find_roll_up_rows
insurance_rows = get_rows.find_insurance_rows

ar_rows.each do |store_num, row|
  curr_progress += 5
  stores[store_num].ar_row = row
  stores[store_num].rollup_row = rollup_rows[store_num] - 1
  stores[store_num].insurance_row = insurance_rows[store_num] - 1
  stores[store_num].pull_data
  progress_bar(curr_progress)
end


roll_up = Writer.new(config['roll_up'])

stores.each_value do |store|
  curr_progress += 5
  roll_up.write(store)
  progress_bar(curr_progress)
end

puts "\n\nDone ✓"
