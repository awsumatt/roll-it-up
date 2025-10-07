# frozen_string_literal: true

require 'io/console'
require 'json'
require_relative 'store'
require_relative 'writer'
require_relative 'config'

stores = {}

MAX_PROGRESS = STORES.length
curr_progress = 0

def progress_bar(progress)
  $stdout.erase_line(1)
  bar = '[' + ('=' * progress) + (' ' * (MAX_PROGRESS - progress)) + ']'
  print "\r#{bar} #{progress}/#{MAX_PROGRESS}"
end

STORES.each do |store|
  stores[store[:name].to_sym] = Store.new(
    MANAGEMENT_SUMMARY_V,
    store[:mgmt_v_page] - 1,
    store[:aged_receivable],
    store[:rollup_row] - 1
  )
end

roll_up = Writer.new(ROLL_UP)

stores.each_value do |store|
  curr_progress += 1
  roll_up.write(store, store.rollup_row)
  progress_bar(curr_progress)
end

puts "\n\nDone ✓"
