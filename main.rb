# frozen_string_literal: true

require 'io/console'
require 'json'
require_relative 'store'
require_relative 'writer'


config_file = File.read('./config.json')
config = JSON.parse(config_file)

json_stores = config['stores']
stores = {}

MAX_PROGRESS = json_stores.length * 5
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
  stores[store['name'].to_sym] = Store.new(
    config['management_summary_v'],
    store['mgmt_v_page'] - 1,
    store['aged_receivable'],
    store['rollup_row'] - 1,
    store['insurance_row'] - 1
  )
end

roll_up = Writer.new(config['roll_up'])

stores.each_value do |store|
  curr_progress += 5
  roll_up.write(store, store.rollup_row)
  progress_bar(curr_progress)
end

puts "\n\nDone ✓"
